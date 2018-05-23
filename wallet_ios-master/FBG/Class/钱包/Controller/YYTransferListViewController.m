//
//  YYTransferListViewController.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYTransferListViewController.h"
#import "PPNetworkCache.h"

#import "DBHTncTransferViewController.h"
#import "DBHTransferViewController.h"
#import "DBHTransferWithETHViewController.h"
#import "DBHTransferDetailViewController.h"

#import "DBHTransferListHeaderView.h"
#import "DBHTransferListTableViewCell.h"

#import "DBHWalletManagerForNeoModelList.h"
#import "DBHWalletDetailTokenInfomationModelData.h"
#import "DBHTransferListDataModels.h"
#import "DBHWalletManagerForNeoModelCategory.h"
#import "YYWalletConversionListModel.h"
#import "DBHWalletManagerForNeoModelList.h"
#import "YYTransferListETHModel.h"

#define WALLET_ORDER_LIST_KEY(userName, address) [NSString stringWithFormat:@"WALLET_ORDER_LIST_%@_%@", userName, address]
#define WALLET_ORDER_LIST @"WALLET_ORDER_LIST"
#define WALLET_ORDER_BALANCE @"WALLET_ORDER_BALANCE"
#define WALLET_ORDER_PRICECNY @"WALLET_ORDER_PRICECNY"
#define WALLET_ORDER_PRICEUSD @"WALLET_ORDER_PRICEUSD"

typedef void (^RequestCompleteBlock) (void);

static NSString *const kDBHTransferListTableViewCellIdentifier = @"kDBHTransferListTableViewCellIdentifier";

@interface YYTransferListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    dispatch_queue_t queue;
    dispatch_group_t group;
}

@property (nonatomic, strong) DBHTransferListHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *transferButton;

@property (nonatomic, copy) NSString * minBlockNumber;  //最小块号 确认 12
@property (nonatomic, assign) NSString * maxBlockNumber;  //最大块号 当前
@property (nonatomic, copy) NSString * blockPerSecond;  //发生时间  5
@property (nonatomic, copy) NSString *canUseGasBalance; // Gas可用余额

@property (nonatomic, assign) NSInteger page; // 分页
@property (nonatomic, assign) BOOL isRequestSuccess; // 是否请求成功
@property (nonatomic, assign) BOOL isCanTransferAccounts; // 是否可以转账
@property (nonatomic, assign) BOOL isRequestMinBlockSuccess; // 最小块高是否请求成功
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isNeedInvalidateTimer; // 是否将timer置空

/** 计时器 */
//@property (nonatomic, strong) NSTimer * timer;

@end

@implementation YYTransferListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setUI];
}

- (void)dealloc {
//    [self removeTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![UserSignData share].user.isLogin) {
        return;
    }
    [self getDataFromServer];
}

- (void)getDataFromServer {
    if ([self isEth]) {
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            [self loadMaxblockNumber:^{
                dispatch_group_leave(group);
            }];
        });
        
        dispatch_group_notify(group, queue, ^{
            [self getNeoTransferListIsLoadMore:NO];
            [self getBalance];
        });
    } else {
        dispatch_async(queue, ^{
            [self getNeoTransferListIsLoadMore:NO];
            [self getBalance];
        });
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isNeedInvalidateTimer = YES;

    NSLog(@"list----退出当前界面");
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.transferButton];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.transferButton.mas_top);
    }];
    [self.transferButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(45.5));
        make.centerX.bottom.equalTo(weakSelf.view);
    }];
    [self addRefresh];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHTransferListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHTransferListTableViewCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.dataSource.count) {
        cell.neoWalletModel = self.neoWalletModel; //必须放在第一行
        cell.model = self.dataSource[indexPath.row];
    }
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 交易详情
    DBHTransferDetailViewController *transferDetailViewController = [[DBHTransferDetailViewController alloc] init];
    transferDetailViewController.tokenModel = self.tokenModel;
//    if ([self isEth]) {
//        transferDetailViewController.ethModel = self.dataSource[indexPath.row];
//    } else {
//        transferDetailViewController.neoModel = self.dataSource[indexPath.row];
//    }
    [self.navigationController pushViewController:transferDetailViewController animated:YES];
}

#pragma mark ------ Data ------
- (void)getDataFromCache {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSString *lastUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_USER_EMAIL];
        NSMutableDictionary *dict = [PPNetworkCache getResponseCacheForKey:WALLET_ORDER_LIST_KEY(lastUserEmail, self.tokenModel.address)];
        if (![NSObject isNulllWithObject:dict]) {
            self.dataSource = dict[WALLET_ORDER_LIST];
            NSString *balance = dict[WALLET_ORDER_BALANCE];
            NSString *priceCny = dict[WALLET_ORDER_PRICECNY];
            NSString *priceUsd = dict[WALLET_ORDER_PRICEUSD];
            
            if ([NSObject isNulllWithObject:balance]) {
                balance = @"0.00";
            }
            
            if ([NSObject isNulllWithObject:priceCny]) {
                priceCny = @"0.00";
            }
            
            if ([NSObject isNulllWithObject:priceUsd]) {
                priceUsd = @"0.00";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.headerView.balance = balance;
                
                if (![self.flag isEqualToString:NEO] && ![self.flag isEqualToString:GAS]) {
                    self.headerView.headImageUrl = self.tokenModel.icon;
                }
                
                NSString *price = [UserSignData share].user.walletUnitType == 1 ? priceCny : priceUsd;
                NSString *asset = [NSString DecimalFuncWithOperatorType:2 first:balance secend:price value:0];
                self.headerView.asset = asset;
            });
        }
    });
}

- (void)getBalance {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        WEAKSELF
        NSString *urlStr = [NSString stringWithFormat:@"conversion/%ld", self.neoWalletModel.listIdentifier];
        NSDictionary *param = nil;
        
        NSInteger type = 4; // NEO、Gas
        if ([self isEth]) { // eth及其代币
            if ([self.flag isEqualToString:ETH]) { // eth
                NSArray *idArr = @[@(self.neoWalletModel.listIdentifier)];
                param = @{@"wallet_ids" : [idArr toJSONStringForArray]};
                urlStr = @"conversion";
                
                type = 5;
            } else { //eth代币
                param = @{@"contract" : self.tokenModel.address,
                          @"address" : self.neoWalletModel.address
                          };
                urlStr = @"extend/balanceOf";
                
                type = 6;
            }
        } else { // neo gas 及其代币
            if (![self.flag isEqualToString:NEO] && ![self.flag isEqualToString:GAS]) { // NEO代币
                urlStr = [NSString stringWithFormat:@"extend/getNeoGntInfo?address=%@&wallet=%@", self.tokenModel.address, self.neoWalletModel.addressHash160];
                
                type = 7;
            }
        }
        [PPNetworkHelper GET:urlStr baseUrlType:1 parameters:param hudString:nil success:^(id responseObject) {
            [weakSelf handleResponseObject:responseObject type:type];
        } failure:^(NSString *error) {
        }];
    });
}

/**
 将16进制的字符串转换成NSData
 */
- (NSData *)convertHexStrToData:(NSString *)str {
    NSString *balance = [NSString stringWithFormat:@"%@", str];
    if (!balance || [balance length] == 0) {
        
        return nil;
        
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    
    NSRange range;
    
    if ([balance length] %2 == 0) {
        
        range = NSMakeRange(0,2);
        
    } else {
        
        range = NSMakeRange(0,1);
        
    }
    
    for (NSInteger i = range.location; i < [balance length]; i += 2) {
        
        unsigned int anInt;
        
        NSString *hexCharStr = [balance substringWithRange:range];
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        
        
        [scanner scanHexInt:&anInt];
        
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        
        [hexData appendData:entity];
        
        
        
        range.location += range.length;
        
        range.length = 2;
        
    }
    
    return [hexData copy];
}
/**
 byte转换成余额
 */
- (unsigned long long)getBalanceWithByte:(Byte *)byte length:(NSInteger)length {
    Byte newByte[length];
    for (NSInteger i = 0; i < length; i++) {
        newByte[i] = byte[length - i - 1];
    }
    
    NSString *hexStr = @"";
    for(int i=0;i < length;i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",newByte[i]&0xff]; // 16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    NSScanner * scanner = [NSScanner scannerWithString:hexStr];
    
    unsigned long long balance;
    
    [scanner scanHexLongLong:&balance];
    
    return balance;
}

- (void)initData {
    self.blockPerSecond = @"10";
    self.minBlockNumber = @"12";
    
    [self getDataFromCache];
    
    // 创建全局并行
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self loadMinblockNumber:^{
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self getBlockPerSecond:^{
            dispatch_group_leave(group);
        }];
    });
}

/**
 获取轮询时间
 */
- (void)getBlockPerSecond:(RequestCompleteBlock)block {
    WEAKSELF
    //获取轮询时间 当前块发生速度  最小5秒
    [PPNetworkHelper POST:@"extend/blockPerSecond" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        if (block) {
            block();
        }
        [weakSelf handleResponseObject:responseObject type:2];
    } failure:^(NSString *error) {
        if (block) {
            block();
        }
    }];
}

- (BOOL)isEth {
    return self.neoWalletModel.categoryId == 1;
}

- (NSString *)flag {
    return self.tokenModel.flag;
}

- (void)loadMinblockNumber:(RequestCompleteBlock)block {
    //获取最小块高  默认12
    WEAKSELF
    [PPNetworkHelper GET:@"min-block" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        if (block) {
            block();
        }
        [weakSelf handleResponseObject:responseObject type:1];
    } failure:^(NSString *error) {
        if (block) {
            block();
        }
    }];
}

- (void)handleResponseObject:(id)responseObject type:(NSInteger)type {
    if (![NSObject isNulllWithObject:responseObject]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            switch (type) {
                case 1: // min-block
                    self.minBlockNumber = [responseObject objectForKey:MIN_BLOCK_NUM];
                    break;
                case 2: // extend/blockPerSecond
                    self.blockPerSecond = [NSString stringWithFormat:@"%f", 1 / [[responseObject objectForKey:BPS] floatValue]];
                    break;
                case 3: { // current-block
                    NSString *value = [responseObject objectForKey:VALUE];
                    if (![NSObject isNulllWithObject:value] && value.length > 2) {
                        NSString *temp = [value substringFromIndex:2];
                        self.maxBlockNumber = [NSString stringWithFormat:@"%@",[NSString numberHexString:temp]];
                    }
                    break;
                }
//            ----- 获取余额----
                case 4: { // NEO、Gas
                    NSString *tempBalance = @"0";
                    NSString *tempPriceCny = @"0";
                    NSString *tempPriceUsd = @"0";
                    
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        if (![self isEth]) { // NEO gas 及代币
                            NSDictionary *record = responseObject[RECORD];
                            if (![NSObject isNulllWithObject:record]) {
                                DBHWalletManagerForNeoModelList *recordModel = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:record];
                                if ([self.flag isEqualToString:NEO]) {
                                    self.tokenModel.balance = recordModel.balance;
                                    
                                    NSString *neoPriceForCny = recordModel.cap.priceCny;
                                    NSString *neoPriceForUsd = recordModel.cap.priceUsd;
                                    self.tokenModel.priceCny = neoPriceForCny;
                                    self.tokenModel.priceUsd = neoPriceForUsd;
                                } else if([self.flag isEqualToString:GAS]) { // GAS
                                    NSArray *gnt = recordModel.gnt;
                                    
                                    NSString *gasPriceForCny = @"0";
                                    NSString *gasPriceForUsd = @"0";
                                    if (![NSObject isNulllWithObject:gnt] && gnt.count > 0) {
                                        YYWalletRecordGntModel *gasGntModel = gnt.firstObject;
                                        gasPriceForCny = gasGntModel.cap.priceCny;
                                        gasPriceForUsd = gasGntModel.cap.priceUsd;
                                    }
                                    
                                    self.tokenModel.priceCny = gasPriceForCny;
                                    self.tokenModel.priceUsd = gasPriceForUsd;
                                }
                            }
                        }
                        
                        if ([self.flag isEqualToString:NEO]) { // neo
                            tempBalance = [NSString stringWithFormat:@"%.0lf", self.tokenModel.balance.doubleValue];
                        } else if ([self.flag isEqualToString:GAS]) { // gas
                            tempBalance = self.tokenModel.balance;
                        }
                        
                        tempPriceCny = self.tokenModel.priceCny;
                        tempPriceUsd = self.tokenModel.priceUsd;
                        
                        tempBalance = [NSString stringWithFormat:@"%.4lf", tempBalance.doubleValue];
                        [self cacheBalance:tempBalance cny:tempPriceCny usd:tempPriceUsd];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.headerView.balance = tempBalance;
                            
                            NSString *price = [UserSignData share].user.walletUnitType == 1 ? tempPriceCny : tempPriceUsd;
                            NSString *asset = [NSString DecimalFuncWithOperatorType:2 first:tempBalance secend:price value:0];
                            self.headerView.asset = asset;
                            if (![self.flag isEqualToString:NEO] && ![self.flag isEqualToString:GAS]) {
                                self.headerView.headImageUrl = self.tokenModel.icon;
                            }
                        });
                    }
                    break;
                }
                    
                case 5: { // eth
                    NSString *tempBalance = @"0";
                    NSString *tempPriceCny = @"0";
                    NSString *tempPriceUsd = @"0";
                    
                    NSArray *dataArray = responseObject[LIST];
                    if (![NSObject isNulllWithObject:dataArray] && dataArray.count > 0) {
                        for (NSDictionary *dict in dataArray) {
                            @autoreleasepool {
                                DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dict];
                                
                                NSString *price_cny = model.category.cap.priceCny;
                                NSString *price_usd = model.category.cap.priceUsd;
                                NSString *balance = model.balance;
                                
                                NSString *second = balance;
                                if (model.categoryId == 1) { //ETH
                                    NSString *temp = @"0";
                                    if (![NSObject isNulllWithObject:balance]) {
                                        temp = [NSString numberHexString:[balance substringFromIndex:2]];
                                    }
                                    second = [NSString DecimalFuncWithOperatorType:3 first:temp secend:@"1000000000000000000" value:8];
                                    
                                    tempBalance = [NSString DecimalFuncWithOperatorType:0 first:tempBalance secend:second value:8];
                                    tempPriceCny = price_cny;
                                    tempPriceUsd = price_usd;
                                }
                            }
                        }
                    }
                    
                    tempBalance = [NSString stringWithFormat:@"%.4lf", tempBalance.doubleValue];
                    [self cacheBalance:tempBalance cny:tempPriceCny usd:tempPriceUsd];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.headerView.balance = tempBalance;
                        
                        NSString *price = [UserSignData share].user.walletUnitType == 1 ? tempPriceCny : tempPriceUsd;
                        NSString *asset = [NSString DecimalFuncWithOperatorType:2 first:tempBalance secend:price value:0];
                        self.headerView.asset = asset;
                        if (![self.flag isEqualToString:NEO] && ![self.flag isEqualToString:GAS]) {
                            self.headerView.headImageUrl = self.tokenModel.icon;
                        }
                    });
                    
                    break;
                }
                    
                case 6: { //eth代币
                    NSString *tempBalance = @"0";
                    NSString *tempPriceCny = @"0";
                    NSString *tempPriceUsd = @"0";
                    
                    NSString *value = responseObject[@"value"];
                    if (![NSObject isNulllWithObject:value] && value.length > 2) {
                        value = [value substringFromIndex:2];
                        
                        NSString *temp = [NSString numberHexString:value];
                        tempBalance = [NSString DecimalFuncWithOperatorType:3 first:temp secend:[NSString stringWithFormat:@"%@", @(pow(10, self.tokenModel.decimals.intValue))] value:0];
                        
                        tempPriceCny = self.tokenModel.priceCny;
                        tempPriceUsd = self.tokenModel.priceUsd;
                    }
                    tempBalance = [NSString stringWithFormat:@"%.4lf", tempBalance.doubleValue];
                    [self cacheBalance:tempBalance cny:tempPriceCny usd:tempPriceUsd];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.headerView.balance = tempBalance;
                        
                        NSString *price = [UserSignData share].user.walletUnitType == 1 ? tempPriceCny : tempPriceUsd;
                        NSString *asset = [NSString DecimalFuncWithOperatorType:2 first:tempBalance secend:price value:0];
                        self.headerView.asset = asset;
                        if (![self.flag isEqualToString:NEO] && ![self.flag isEqualToString:GAS]) {
                            self.headerView.headImageUrl = self.tokenModel.icon;
                        }
                    });
                    break;
                }
                    
                case 7: { // NEO代币
                    NSString *tempBalance = @"0";
                    NSString *tempPriceCny = @"0";
                    NSString *tempPriceUsd = @"0";
                    
                    NSString *balance = responseObject[BALANCE];
                    NSString *decimals = responseObject[DECIMALS];
                    
                    if (![NSObject isNulllWithObject:balance]) {
                        NSData *data = [self convertHexStrToData:balance];
                        tempBalance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals.integerValue)];
                    }
                    tempPriceCny = self.tokenModel.priceCny;
                    tempPriceUsd = self.tokenModel.priceUsd;
                    
                    tempBalance = [NSString stringWithFormat:@"%.4lf", tempBalance.doubleValue];
                    [self cacheBalance:tempBalance cny:tempPriceCny usd:tempPriceUsd];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.headerView.balance = tempBalance;
                        
                        NSString *price = [UserSignData share].user.walletUnitType == 1 ? tempPriceCny : tempPriceUsd;
                        NSString *asset = [NSString DecimalFuncWithOperatorType:2 first:tempBalance secend:price value:0];
                        self.headerView.asset = asset;
                        if (![self.flag isEqualToString:NEO] && ![self.flag isEqualToString:GAS]) {
                            self.headerView.headImageUrl = self.tokenModel.icon;
                        }
                    });
                    break;
                }
                default:
                    break;
            }
            
            
            
        });
    }
}

- (void)cacheBalance:(NSString *)balance cny:(NSString *)cny usd:(NSString *)usd {
    NSString *lastUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_USER_EMAIL];
    NSMutableDictionary *dict = [PPNetworkCache getResponseCacheForKey:WALLET_ORDER_LIST_KEY(lastUserEmail, self.tokenModel.address)];
    if ([NSObject isNulllWithObject:dict]) {
        dict =  [NSMutableDictionary dictionary];
    }
    
    if ([NSObject isNulllWithObject:balance]) {
        balance = @"0";
    }
    if ([NSObject isNulllWithObject:cny]) {
        cny = @"0";
    }
    if ([NSObject isNulllWithObject:usd]) {
        usd = @"0";
    }
    
    [dict setObject:balance forKey:WALLET_ORDER_BALANCE];
    [dict setObject:cny forKey:WALLET_ORDER_PRICECNY];
    [dict setObject:usd forKey:WALLET_ORDER_PRICEUSD];
    
    [PPNetworkCache saveResponseCache:dict forKey:WALLET_ORDER_LIST_KEY(lastUserEmail, self.tokenModel.address)];
}

- (void)loadMaxblockNumber:(RequestCompleteBlock)block {
    //当前当前块号  //轮询这个
    WEAKSELF
    [PPNetworkHelper POST:@"extend/blockNumber" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        if (block) {
            block();
        }
        [weakSelf handleResponseObject:responseObject type:3];
    } failure:^(NSString *error) {
        if (block) {
            block();
        }
        [LCProgressHUD showFailure:error];
    }];
}

/**
- (void)handleResponseObj:(id)responseObject {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        if ([NSObject isNulllWithObject:responseObject]) {
            return;
        }
        
        NSString *resultBalance = @"0.0000";
        NSString *resultAsset = @"0.0000";
        NSString *headImageUrl = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *list = responseObject[LIST];
            if ([self isEth]) { // ETH 及其代币
                for (NSDictionary *dict in list) {
                    @autoreleasepool {
                        YYWalletConversionListModel *listModel = [YYWalletConversionListModel mj_objectWithKeyValues:dict];
                        NSString *name = listModel.name;
                        if ([name isEqualToString:self.tokenModel.name]) {
                            NSString *price_cny = listModel.gnt_category.cap.priceCny;
                            NSString *price_usd = listModel.gnt_category.cap.priceUsd;
                            NSString *balance = listModel.balance;
                            
                            
                            if ([name isEqualToString:ETH]) {
                                resultBalance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[balance substringFromIndex:2]] secend:@"1000000000000000000" value:4];
                            } else {
                                NSInteger decimals = listModel.decimals;
                                resultBalance = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[balance substringFromIndex:2]] secend:[NSString stringWithFormat:@"%lf", pow(10, decimals)] value:4];
                            }
                            resultAsset = [UserSignData share].user.walletUnitType == 1 ? price_cny : price_usd;
                        }
                    }
                }
            } else { // NEO
                NSDictionary *record = responseObject[RECORD];
                if (![NSObject isNulllWithObject:record]) {
                    DBHWalletManagerForNeoModelList *recordModel = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:record];
                    if ([self.flag isEqualToString:NEO]) {
                        self.tokenModel.balance = recordModel.balance;
                        
                        NSString *neoPriceForCny = recordModel.cap.priceCny;
                        NSString *neoPriceForUsd = recordModel.cap.priceUsd;
                        self.tokenModel.priceCny = neoPriceForCny;
                        self.tokenModel.priceUsd = neoPriceForUsd;
                    } else if([self.flag isEqualToString:GAS]) { // GAS
                        NSArray *gnt = recordModel.gnt;
                        
                        NSString *gasPriceForCny = @"0";
                        NSString *gasPriceForUsd = @"0";
                        if (![NSObject isNulllWithObject:gnt] && gnt.count > 0) {
                            YYWalletRecordGntModel *gasGntModel = gnt.firstObject;
                            gasPriceForCny = gasGntModel.cap.priceCny;
                            gasPriceForUsd = gasGntModel.cap.priceUsd;
                        }
                        
                        self.tokenModel.priceCny = gasPriceForCny;
                        self.tokenModel.priceUsd = gasPriceForUsd;
                    }
                    
                } else { // 代币
                    for (NSDictionary *dict in list) {
                        @autoreleasepool {
                            YYWalletConversionListModel *listModel = [YYWalletConversionListModel mj_objectWithKeyValues:dict];
                            NSString *name = listModel.name;
                            if ([name isEqualToString:self.flag]) {
                                NSData *data = [self convertHexStrToData:listModel.balance];
                                NSInteger decimals = listModel.decimals;
                                
                                self.tokenModel.decimals = [NSString stringWithFormat:@"%@", @(decimals)];
                                self.tokenModel.balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals)];
                                
                                NSString *price_cny = listModel.gnt_category.cap.priceCny;
                                NSString *price_usd = listModel.gnt_category.cap.priceUsd;
                                
                                self.tokenModel.priceCny = [NSString stringWithFormat:@"%@", price_cny];
                                self.tokenModel.priceUsd = [NSString stringWithFormat:@"%@", price_usd];
                            }
                        }
                    }
                }
                
                if (![self.flag isEqualToString:NEO] && ![self.flag isEqualToString:GAS]) { //代币
                    headImageUrl = self.tokenModel.icon;
                }
                
                if ([self.flag isEqualToString:NEO]) { // neo
                    resultBalance = [NSString stringWithFormat:@"%.0lf", self.tokenModel.balance.doubleValue];
                } else if ([self.flag isEqualToString:GAS]) { // gas
                    resultBalance = self.tokenModel.balance;
                } else { // dai'b
                    resultBalance = [NSString stringWithFormat:@"%.4lf", self.tokenModel.balance.doubleValue];
                }
                NSString *price = [UserSignData share].user.walletUnitType == 1 ? self.tokenModel.priceCny : self.tokenModel.priceUsd;
                resultAsset = [NSString DecimalFuncWithOperatorType:2 first:price secend:self.tokenModel.balance value:2];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headerView.headImageUrl = headImageUrl;
            self.headerView.balance = resultBalance;
            self.headerView.asset = resultAsset;
        });
    });
}
*/
/**
 获取余额
 */

/**
- (void)getNeoBalance {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)self.neoWalletModel.listIdentifier] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf handleResponseObj:responseCache];
    } success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject];
    } failure:^(NSString *error) {
        //        [LCProgressHUD showFailure:error];
    } specialBlock:^{
        if (![UserSignData share].user.isLogin) {
            return ;
        }
    }];
}
 */


/**
 获取订单列表成功的处理

 @param responseObject result
 @param isLoadMore 是否加载更多
 */
- (void)handleWalletOrderResponse:(id)responseObject loadMore:(BOOL)isLoadMore {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.isRequestSuccess = YES;
        
        NSMutableArray *tempArr = [NSMutableArray array];
        if (isLoadMore) { // 加载更多 在原有基础上添加
            tempArr = [NSMutableArray arrayWithArray:self.dataSource];
        }
        
        if (![NSObject isNulllWithObject:responseObject] && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *list = responseObject[LIST];
            if (![NSObject isNulllWithObject:list] && [list isKindOfClass:[NSArray class]]) {
                BOOL isHaveNoFinishOrder = NO;
                if (list.count < 10) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    });
                }
                
                for (NSDictionary *dict in list) {
                    @autoreleasepool {
                        if ([self isEth]) {
                            YYTransferListETHModel *model = [YYTransferListETHModel mj_objectWithKeyValues:dict];
                            
                            model.flag = self.flag;
                            model.typeName = self.tokenModel.typeName;
                            
                            if ([model.fee containsString:@"0x"]) {
                                model.fee = [NSString numberHexString:[model.fee substringFromIndex:2]];
                            }
                            
                            if ([model.handle_fee containsString:@"0x"]) {
                                model.handle_fee = [NSString numberHexString:[model.handle_fee substringFromIndex:2]];
                            }
                            
                            NSString *secondStr = @"1000000000000000000";
                            model.handle_fee = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[model.handle_fee substringFromIndex:2]] secend:secondStr value:8];
                            
                            if (![self.flag isEqualToString:ETH]) { //ETH代币
                                secondStr = [NSString stringWithFormat:@"%lf", pow(10, self.tokenModel.decimals.doubleValue)];
                            }
                            model.fee = [NSString DecimalFuncWithOperatorType:3 first:model.fee secend:secondStr value:8];
                            
                            model.maxBlockNumber = self.maxBlockNumber;
                            model.minBlockNumber = self.minBlockNumber;
                            
                            int number;
                            
                            int tempValue = model.maxBlockNumber.intValue - model.block_number.intValue + 1;
                            if (tempValue < 0) {
                                //小于0 置为0
                                number = 0;
                            } else {
                                number = tempValue;
                            }
                            
                            if (number < model.minBlockNumber.doubleValue && [NSObject isNulllWithObject:model.confirm_at]) {
                                isHaveNoFinishOrder = YES;
                            }
                            
                            
                            if ([[model.pay_address lowercaseString] isEqualToString:[model.receive_address lowercaseString]]) {
                                // 自转
                                model.transferType = 0;
                            } else {
                                model.transferType = [[model.pay_address lowercaseString] isEqualToString:[self.neoWalletModel.address lowercaseString]] ? 1 : 2;
                            }
                            
                            [tempArr addObject:model];
                        } else {
                            DBHTransferListModelList *model = [DBHTransferListModelList mj_objectWithKeyValues:dict];
                            
                            model.flag = self.flag;
                            model.typeName = self.tokenModel.typeName;
                            
                            // 只有neo的代币才设置value   // 代币的话，value值应该要除以10的decimals次方
                            if (!([self.flag isEqualToString:NEO] ||
                                  [self.flag isEqualToString:GAS])) {
                                model.value = [NSString DecimalFuncWithOperatorType:3 first:model.value secend:[NSString stringWithFormat:@"%lf", pow(10, self.tokenModel.decimals.doubleValue)] value:8];
                            }
                            
                            if ([NSObject isNulllWithObject:model.confirmTime]) {
                                isHaveNoFinishOrder = YES;
                            }
                            
                            if ([[model.from lowercaseString] isEqualToString:[model.to lowercaseString]]) {
                                // 自转
                                model.transferType = 0;
                            } else {
                                model.transferType = [[model.from lowercaseString] isEqualToString:[self.neoWalletModel.address lowercaseString]] ? 1 : 2;
                            }
                            
                            [tempArr addObject:model];
                        }
                    }
                        
                }
                
                self.isCanTransferAccounts = !isHaveNoFinishOrder;
                if (!isLoadMore && isHaveNoFinishOrder) { // 第一页有未完成订单
                    // 轮询一次 TODO
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.blockPerSecond.intValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSLog(@"list----%fs后", self.blockPerSecond.floatValue);
                        if (self.isNeedInvalidateTimer) { // 不在当前页面 或者  不是第一页 或者 全都是已完成订单
                             NSLog(@"list----不再执行");
                        } else {
                            NSLog(@"list----从服务器获取数据");
                            [self getDataFromServer];
                        }
                    });
                } else { // 不是第一页 或者 全都是已完成订单
                    self.isNeedInvalidateTimer = YES;
                    NSLog(@"list----不是第一页 或者 全都是已完成订单");
                }
                self.dataSource = tempArr;
                
                if (!isLoadMore) { // 第一页 缓存到本地
                    NSString *lastUserEmail = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_USER_EMAIL];
                    NSMutableDictionary *dict = [PPNetworkCache getResponseCacheForKey:WALLET_ORDER_LIST_KEY(lastUserEmail, self.tokenModel.address)];
                    if ([NSObject isNulllWithObject:dict]) {
                        dict =  [NSMutableDictionary dictionary];
                    }
                    if (![NSObject isNulllWithObject:tempArr]) {
                        [dict setObject:tempArr forKey:WALLET_ORDER_LIST];
                    }
                    
                    [PPNetworkCache saveResponseCache:dict forKey:WALLET_ORDER_LIST_KEY(lastUserEmail, self.tokenModel.address)];
                }
            }
        }
    });
}
/**
 获取转账列表
 */
- (void)getNeoTransferListIsLoadMore:(BOOL)isLoadMore {
    if (isLoadMore) {
        self.page += 1;
    } else {
        self.page = 0;
    }
    
    WEAKSELF
    NSString *asset_id;
    NSString *flag;
    if ([self isEth]) { // eth及其代币
        if ([self.flag isEqualToString:ETH]) { // eth
            flag = self.neoWalletModel.category.name;
            asset_id = @"0x0000000000000000000000000000000000000000";
        } else { //eth代币
            flag = self.tokenModel.name;
            asset_id = [self.tokenModel.address lowercaseString];
        }
    } else { // neo gas 及其代币
        flag = NEO;
        if ([self.flag isEqualToString:NEO]) {
            asset_id = @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b";
        } else if ([self.flag isEqualToString:GAS]) {
            asset_id = @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
        } else {
            asset_id = self.tokenModel.address;
        }
    }
    
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.neoWalletModel.listIdentifier) forKey:WALLET_ID];
    [parametersDic setObject:flag forKey:FLAG];
    [parametersDic setObject:@(self.page) forKey:PAGE];
    [parametersDic setObject:asset_id forKey:ASSET_ID];
    
    //包含事务块高  列表   （当前块高-订单里的块高）/最小块高
    [PPNetworkHelper GET:@"wallet-order" baseUrlType:1 parameters:parametersDic hudString:nil success:^(id responseObject) {
        [weakSelf endRefresh];
        [weakSelf handleWalletOrderResponse:responseObject loadMore:isLoadMore];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 转账
 */
- (void)respondsToTransferButton {
    if (self.neoWalletModel.isLookWallet) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Transferring from cold wallet is not supported at the moment. Please Change to hot wallet", nil)];
        
        return;
    }
    if (!self.isRequestSuccess) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Order list has not been loaded yet", nil)];
        
        return;
    }
    if (!self.isCanTransferAccounts) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"You still have unfinished orders! Please try again later!", nil)];
        
        return;
    }
    
    NSString *flag = self.flag;
    if ([flag isEqualToString:NEO] || [flag isEqualToString:GAS]) { // neo gas
        DBHTransferViewController *transferViewController = [[DBHTransferViewController alloc] init];
        transferViewController.neoWalletModel = self.neoWalletModel;
        transferViewController.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:transferViewController animated:YES];
    } else if ([self isEth]) { // eth
        DBHTransferWithETHViewController *transferWithETHViewController = [[DBHTransferWithETHViewController alloc] init];
        transferWithETHViewController.neoWalletModel = self.neoWalletModel;
        transferWithETHViewController.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:transferWithETHViewController animated:YES];
    } else { // neo代币
        DBHTncTransferViewController *tncTransferViewController = [[DBHTncTransferViewController alloc] init];
        tncTransferViewController.canUseGasBalance = self.canUseGasBalance;
        tncTransferViewController.neoWalletModel = self.neoWalletModel;
        tncTransferViewController.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:tncTransferViewController animated:YES];
    }
}

#pragma mark ------ Private Methods ------
/**
- (void)timerDown {
    [self removeTimer];
    if (!self.isNeedInvalidateTimer) {
        //开始计时
        self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.blockPerSecond intValue] target:self selector:@selector(countDownTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}*/


/**
 每隔几秒需要执行一次 获取最大块高

- (void)countDownTime {
    if (self.isNeedInvalidateTimer) {
        [self removeTimer];
    } else {
        NSLog(@"countDownTime --- %@", [NSDate date]);
        //10s 请求一次接口
        if ([self isEth]) {
            [self loadMaxblockNumber:nil];
        } else {
            [self getNeoTransferListIsLoadMore:NO];
        }
        [self getNeoBalance];
    }
} */

- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataFromServer];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getNeoTransferListIsLoadMore:YES];
    }];
}

- (void)endRefresh {
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (void)setTokenModel:(DBHWalletDetailTokenInfomationModelData *)tokenModel {
    _tokenModel = tokenModel;
    
    if ([_tokenModel.flag isEqualToString:NEO]) {
        self.headerView.balance = _tokenModel.balance;
    } else {
        self.headerView.balance = [NSString stringWithFormat:@"%.4lf", _tokenModel.balance.doubleValue];
    }
    
    NSString *price = [UserSignData share].user.walletUnitType == 1 ? _tokenModel.priceCny : _tokenModel.priceUsd;
    NSString *asset = [NSString DecimalFuncWithOperatorType:2 first:tokenModel.balance secend:price value:0];
    self.headerView.asset = asset;
    self.headerView.headImageUrl = _tokenModel.icon;
}

- (DBHTransferListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DBHTransferListHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(210))];
    }
    return _headerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(65);
        
        _tableView.tableHeaderView = self.headerView;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHTransferListTableViewCell class] forCellReuseIdentifier:kDBHTransferListTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIButton *)transferButton {
    if (!_transferButton) {
        _transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferButton.backgroundColor = MAIN_ORANGE_COLOR;
        _transferButton.titleLabel.font = BOLDFONT(14);
        _transferButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, AUTOLAYOUTSIZE(2.5));
        _transferButton.titleEdgeInsets = UIEdgeInsetsMake(0, AUTOLAYOUTSIZE(2.5), 0, 0);
        [_transferButton setImage:[UIImage imageNamed:@"跨行转账"] forState:UIControlStateNormal];
        [_transferButton setTitle:DBHGetStringWithKeyFromTable(@"Transfer", nil) forState:UIControlStateNormal];
        [_transferButton addTarget:self action:@selector(respondsToTransferButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferButton;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
