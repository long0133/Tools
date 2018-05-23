//
//  DBHWalletDetailViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletDetailViewController.h"
#import "WXApi.h"
#import "PackupsWordsVC.h"
#import "YYTransferListViewController.h"

#import "DBHQrCodeViewController.h"
#import "DBHAddPropertyViewController.h"
#import "DBHTokenSaleViewController.h"
#import "DBHTransferListViewController.h"
#import "DBHExtractGasViewController.h"
#import "DBHImportWalletViewController.h"

#import "DBHWalletDetailTitleView.h"
#import "DBHInputPasswordPromptView.h"
#import "DBHWalletDetailHeaderView.h"
#import "DBHMenuView.h"
#import "DBHWalletDetailTableViewCell.h"

#import "WalletLeftListModel.h"

#import "DBHWalletDetailTokenInfomationDataModels.h"
#import "DBHLookWalletInfoViewController.h"
#import "CustomActivity.h"
#import "LYShareMenuView.h"
//#import <TencentOpenApi/QQApiInterface.h>
#import "TencentOpenAPI.framework/Headers/QQApiInterface.h"
#import "YYWalletConversionListModel.h"

static NSString *const kDBHWalletDetailTableViewCellIdentifier = @"kDBHWalletDetailTableViewCellIdentifier";

@interface DBHWalletDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, LYShareMenuViewDelegate>

@property (nonatomic, strong) DBHWalletDetailTitleView *titleView;
@property (nonatomic, strong) DBHWalletDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHMenuView *menuView;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;

@property (nonatomic, assign) BOOL isHideZero;

@property (nonatomic, strong) NSMutableArray *noZeroDatasource; // 没有为0的代币列表

@property (nonatomic, assign) NSInteger operationType; // 操作类型 1:备份助记词 2:备份Keystore 3:删除钱包
@property (nonatomic, strong) NSMutableArray *menuArray; // 菜单选项
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) LYShareMenuView *sharedMenuView;

@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *neoModel;
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *gasModel;

@end

@implementation DBHWalletDetailViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.titleView;
    
    [self setUI];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.neoWalletModel.listIdentifier)] && self.menuArray.count > 2) {
        [self.menuArray removeObjectAtIndex:0];
        self.menuView.dataSource = [self.menuArray copy];
    }
    if (self.neoWalletModel.isLookWallet) {
        _menuArray = [@[@"Convert to Hot Wallet", @"Delete Wallet"] mutableCopy];
    } else {
        _menuArray = [@[@"Backup Mnemonic", @"Backup Keystore", @"Delete Wallet"] mutableCopy];
    }
    
    self.isHideZero = [[NSUserDefaults standardUserDefaults] boolForKey:IS_HIDE_ZERO_KEY];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [self getWalletAssetInfomation];
    });
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    if (_sharedMenuView.delegate) {
        _sharedMenuView.delegate = nil;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"导出"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToMenuBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(- STATUS_HEIGHT - 44);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    [self judgeIsShowGuide];
}

- (void)judgeIsShowGuide {
    BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:IS_SHOW_WALLET_DETAIL_GUIDE];
    if (!isShow) {
        [self addGuideView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_SHOW_WALLET_DETAIL_GUIDE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)addGuideView {
    [self.view layoutIfNeeded];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    bgView.backgroundColor = COLORFROM16(0x323232, 0.8);
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_detail_guide_arrow"]];
    
    arrowImg.contentMode = UIViewContentModeScaleAspectFit;
    
    arrowImg.frame = CGRectMake(AUTOLAYOUTSIZE(290), AUTOLAYOUTSIZE(19) + STATUS_HEIGHT + 44, AUTOLAYOUTSIZE(22), AUTOLAYOUTSIZE(41));
    [bgView addSubview:arrowImg];
    
    UIImageView *tipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DBHGetStringWithKeyFromTable(@"wallet_detail_guide_tip_en", nil)]];
    
    tipImg.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat width = AUTOLAYOUTSIZE(180);
    tipImg.frame = CGRectMake(CGRectGetMinX(arrowImg.frame) - width + 16, AUTOLAYOUTSIZE(19) + STATUS_HEIGHT + 54, width, 40);
    [bgView addSubview:tipImg];
    
    UIButton *iKownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    width = AUTOLAYOUTSIZE(100);
    
    CGRect btnFrame = iKownBtn.frame;
    btnFrame.origin.x = CGRectGetMidX(tipImg.frame);
    btnFrame.origin.y = CGRectGetMaxY(tipImg.frame) + 68;
    btnFrame.size.width = width;
    btnFrame.size.height = 36;
    
    iKownBtn.frame = btnFrame;
    
    iKownBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [iKownBtn setImage:[UIImage imageNamed:DBHGetStringWithKeyFromTable(@"info_guide_ikown_en", nil)] forState:UIControlStateNormal];
    [iKownBtn addTarget:self action:@selector(iKownClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:iKownBtn];
    [keyWindow addSubview:bgView];
}

- (void)iKownClicked:(UIButton *)btn {
    [btn.superview removeFromSuperview];
}
#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.isHideZero ? self.noZeroDatasource.count : self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHWalletDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHWalletDetailTableViewCellIdentifier forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSInteger count = self.isHideZero ? self.noZeroDatasource.count : self.dataSource.count;
    if (row < count) {
        cell.model = self.isHideZero ? self.noZeroDatasource[row] : self.dataSource[row];
    }
    
    WEAKSELF
    [cell clickExtractButtonBlock:^{
        if (weakSelf.neoWalletModel.isLookWallet) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Watch wallet doesn't support claim Gas", nil)];
        } else {
            // 提取Gas
            DBHExtractGasViewController *extractGasViewController = [[DBHExtractGasViewController alloc] init];
            extractGasViewController.wallectId = [NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.neoWalletModel.listIdentifier];
            extractGasViewController.neoTokenModel = weakSelf.isHideZero ? weakSelf.noZeroDatasource.firstObject : weakSelf.dataSource.firstObject;
            extractGasViewController.gasTokenModel = weakSelf.isHideZero ? weakSelf.noZeroDatasource[1] : weakSelf.dataSource[1];
            [weakSelf.navigationController pushViewController:extractGasViewController animated:YES];
        }
    }];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHTransferListViewController *transferListViewController = [[DBHTransferListViewController alloc] init];
//    YYTransferListViewController *transferListViewController = [[YYTransferListViewController alloc] init];
    NSInteger row = indexPath.row;
    NSInteger count = self.isHideZero ? self.noZeroDatasource.count : self.dataSource.count;
    if (row < count) {
        DBHWalletDetailTokenInfomationModelData *model = self.isHideZero ? self.noZeroDatasource[row] : self.dataSource[row];
        model.typeName = NEO;
        transferListViewController.title = model.flag;
        transferListViewController.neoWalletModel = self.neoWalletModel;
        transferListViewController.tokenModel = model;
        [self.navigationController pushViewController:transferListViewController animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row > 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加一个删除按钮
    WEAKSELF
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:DBHGetStringWithKeyFromTable(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [weakSelf deleteTokenWithIndex:indexPath.row];
        tableView.editing = NO;
    }];
    //删除按钮颜色
    
    deleteAction.backgroundColor = [UIColor colorWithHexString:@"FF841C"];
    
    // 添加一个置顶按钮
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:DBHGetStringWithKeyFromTable(@"Top", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了置顶");
        [weakSelf topTokenWithIndex:indexPath.row];
        tableView.editing = NO;
    }];
    
    return @[topAction, deleteAction];
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    CGFloat offsetY = scrollView.contentOffset.y + STATUS_HEIGHT + 44;
    //
    //    CGFloat alpha = offsetY / 260;
    //    UIBarButtonItem *backBarButtonItem = self.navigationItem.leftBarButtonItems.firstObject;
    //    UIButton *backButton = backBarButtonItem.customView;
    //    self.titleView.hidden = !(alpha >= 0.12);
    //    [backButton setImage:[UIImage imageNamed:alpha >= 0.12 ? @"login_close" : @"关闭-4"] forState:UIControlStateNormal];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:COLORFROM16(0xFFFFFF, alpha) Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:alpha >= 0.12 ? @"导出1" : @"导出"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToMenuBarButtonItem)];
}


#pragma mark ------ Data ------
- (void)handleResponseObj:(id)responseObj {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        if (![NSObject isNulllWithObject:responseObj]) {
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *record = responseObj[RECORD];
                [self handleNeoAndGas:record];
                
                NSArray *list = responseObj[LIST];
                [self handleTokenList:list];
                
                return;
            }
        }
        
        [self showDataWithArray:nil];
    });
}

- (void)handleTokenList:(NSArray *)list {
    NSMutableArray *tempArr = [NSMutableArray array];
    if (![NSObject isNulllWithObject:list] && [list isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in list) {
            @autoreleasepool {
                YYWalletConversionListModel *listModel = [YYWalletConversionListModel mj_objectWithKeyValues:dict];
                
                NSString *price_cny = listModel.gnt_category.cap.priceCny;
                NSString *price_usd = listModel.gnt_category.cap.priceUsd;
                
                NSString *symbol = listModel.symbol;
                NSString *name = listModel.name;
                NSString *balance = listModel.balance;
                NSInteger decimals = listModel.decimals;
                
                DBHWalletDetailTokenInfomationModelData *model = [[DBHWalletDetailTokenInfomationModelData alloc] init];
                model.name = name;
                model.icon = listModel.gnt_category.icon;
                model.address = listModel.gnt_category.address;
                model.flag = name;
                model.symbol = symbol;
                model.dataIdentifier = [NSString stringWithFormat:@"%@", @(listModel.listId)];
                model.typeName = NEO;
                
                NSData *data = [self convertHexStrToData:balance];
                model.decimals = [NSString stringWithFormat:@"%@", @(decimals)];
                model.balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, decimals)];
                
                model.priceUsd = price_usd;
                model.priceCny = price_cny;
                
                [tempArr addObject:model];
            }
        }
    }
    
    [self showDataWithArray:[NSArray arrayWithArray:tempArr]];
}

- (void)handleNeoAndGas:(NSDictionary *)record {
    NSString *priceCny = @"0";
    NSString *priceUsd = @"0";
    NSString *balance = @"0";
    if (![NSObject isNulllWithObject:record]) {
        DBHWalletManagerForNeoModelList *recordModel = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:record];
        self.neoModel.address = recordModel.address;
        self.gasModel.address = recordModel.address;
        
        balance = recordModel.balance;
        priceCny = recordModel.cap.priceCny;
        priceUsd = recordModel.cap.priceUsd;
        
        NSString *gasPriceCny = @"0";
        NSString *gasPriceUsd = @"0";
        NSString *gasBalance = @"0";
        NSString *capId = @"0";
        NSString *canExtractbalance = @"0";
        NSString *noExtractbalance = @"0";
        
        NSArray *gnt = recordModel.gnt;
        if (![NSObject isNulllWithObject:gnt] && gnt.count > 0) {
            YYWalletRecordGntModel *gasGntModel = gnt.firstObject;
            gasPriceCny = gasGntModel.cap.priceCny;
            gasPriceUsd = gasGntModel.cap.priceUsd;
            gasBalance = gasGntModel.balance;
            capId = gasGntModel.cap.icoIdentifier;
            
            canExtractbalance = gasGntModel.available;
            noExtractbalance = gasGntModel.unavailable;
        }
        
        self.gasModel.balance = gasBalance;
        self.gasModel.priceCny = gasPriceCny;
        self.gasModel.priceUsd = gasPriceUsd;
        self.gasModel.canExtractbalance = canExtractbalance;
        self.gasModel.noExtractbalance = noExtractbalance;
        self.gasModel.symbol = GAS;
        self.gasModel.dataIdentifier = capId;
    }
    
    self.neoModel.balance = balance;
    
    self.neoModel.priceCny = priceCny;
    self.neoModel.priceUsd = priceUsd;
}

- (void)showDataWithArray:(NSArray *)array {
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:array];
    
    [tempArr insertObject:self.neoModel atIndex:0];
    [tempArr insertObject:self.gasModel atIndex:1];

    [self handleArray:tempArr];
}

- (void)handleArray:(NSMutableArray *)array {
    self.dataSource = array;
    
    WEAKSELF
    __block NSString *tokenTotal = @"0";
    
    self.noZeroDatasource = [NSMutableArray arrayWithArray:self.dataSource];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            DBHWalletDetailTokenInfomationModelData *model = (DBHWalletDetailTokenInfomationModelData *)obj;
            if (![model.flag isEqualToString:NEO] && ![model.flag isEqualToString:GAS]) {
                NSString *tokenPrice = [UserSignData share].user.walletUnitType == 1 ? model.priceCny : model.priceUsd;
                
                tokenPrice = [NSString DecimalFuncWithOperatorType:2 first:model.balance secend:tokenPrice value:8];
                tokenTotal = [NSString DecimalFuncWithOperatorType:0 first:tokenTotal secend:tokenPrice value:8];
                
                NSString *bala = model.balance;
                if (bala.doubleValue == 0 && [weakSelf.noZeroDatasource containsObject:model]) { // 为0 且存在在数组中 移除
                    [weakSelf.noZeroDatasource removeObject:model];
                }
            }
        }
    }];
    
    
    NSString *neoPrice = [NSString DecimalFuncWithOperatorType:2 first:self.neoModel.balance secend:[UserSignData share].user.walletUnitType == 1 ? self.neoModel.priceCny : self.neoModel.priceUsd value:8];
    
    NSString *gasPrice = [NSString DecimalFuncWithOperatorType:2 first:self.gasModel.balance secend:[UserSignData share].user.walletUnitType == 1 ? self.gasModel.priceCny : self.gasModel.priceUsd value:8];
    
//    NSString *neoPrice = [UserSignData share].user.walletUnitType == 1 ? self.neoModel.priceCny : self.neoModel.priceUsd;
//    NSString *gasPrice = [UserSignData share].user.walletUnitType == 1 ? self.gasModel.priceCny : self.gasModel.priceUsd;
    
    NSString *gasNeo = [NSString DecimalFuncWithOperatorType:0 first:neoPrice secend:gasPrice value:8];
    
    NSString *totalAsset = [NSString DecimalFuncWithOperatorType:0 first:gasNeo secend:tokenTotal value:8];
    
    if ([NSObject isNulllWithObject:totalAsset] || [totalAsset isEqualToString:@"0"]) {
        totalAsset = @"0.00";
    } else {
        totalAsset = [NSString stringWithFormat:@"%.02f", totalAsset.doubleValue];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleView.totalAsset = totalAsset;
        self.headerView.asset =  totalAsset;
        self.headerView.isHideZeroAsset = self.isHideZero;
        
        [self.tableView reloadData];
    });
}

/**
 获取钱包资产信息
 */
- (void)getWalletAssetInfomation {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"conversion/%ld", (NSInteger)self.neoWalletModel.listIdentifier] baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf handleResponseObj:responseCache];
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        [weakSelf handleResponseObj:responseObject];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    } specialBlock:^{
        if (![UserSignData share].user.isLogin) {
            return ;
        }
    }];
}

- (void)topTokenWithIndex:(NSInteger)index {
    DBHWalletDetailTokenInfomationModelData *model = self.isHideZero ? self.noZeroDatasource[index] : self.dataSource[index];
    WEAKSELF
    //    https://dev.inwecrypto.com:4431/v2/api/user-gnt/id
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [PPNetworkHelper PUT:[NSString stringWithFormat:@"user-gnt/%@", model.dataIdentifier] baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
            
            if (weakSelf.isHideZero) {
                DBHWalletDetailTokenInfomationModelData *model = [weakSelf.noZeroDatasource objectAtIndex:index];
                [weakSelf.noZeroDatasource removeObject:model];
                [weakSelf.noZeroDatasource insertObject:model atIndex:2];
            } else {
                DBHWalletDetailTokenInfomationModelData *model = [weakSelf.dataSource objectAtIndex:index];
                [weakSelf.dataSource removeObject:model];
                [weakSelf.dataSource insertObject:model atIndex:2];
            }
            [weakSelf.tableView reloadData];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    });
}

/**
 删除代币
 */
- (void)deleteTokenWithIndex:(NSInteger)index {
    DBHWalletDetailTokenInfomationModelData *model = self.isHideZero ? self.noZeroDatasource[index] : self.dataSource[index];
    WEAKSELF
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [PPNetworkHelper DELETE:[NSString stringWithFormat:@"user-gnt/%@", model.dataIdentifier] baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Deleting...", nil) success:^(id responseObject) {
            //1.更新数据
            if (weakSelf.isHideZero) {
                [weakSelf.noZeroDatasource removeObjectAtIndex:index];
                if ([weakSelf.dataSource containsObject:model]) {
                    [weakSelf.dataSource removeObject:model];
                }
            } else {
                [weakSelf.dataSource removeObjectAtIndex:index];
                if ([weakSelf.noZeroDatasource containsObject:model]) {
                    [weakSelf.noZeroDatasource removeObject:model];
                }
            }
            //2.更新UI
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    });
}

#pragma mark ------ Event Responds ------
/**
 菜单
 */
- (void)respondsToMenuBarButtonItem {
    if (!self.neoWalletModel.isLookWallet && self.menuArray.count > 2 && [[UserSignData share].user.walletZhujiciIdsArray containsObject:@(self.neoWalletModel.listIdentifier)]) {
        [self.menuArray removeObjectAtIndex:0];
    }
    self.menuView.dataSource = [self.menuArray copy];
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.menuView animationShow];
    });
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(
                                                 DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 0), ^{
            [weakSelf getWalletAssetInfomation];
        });
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
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

#pragma mark ------ Getters And Setters ------

- (DBHWalletDetailTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[DBHWalletDetailTitleView alloc] initWithFrame:CGRectMake(0, 0, AUTOLAYOUTSIZE(SCREENWIDTH), 44)];
        _titleView.intrinsicContentSize = CGSizeMake(SCREENWIDTH, 44);
        _titleView.hidden = YES;
        
        WEAKSELF
        [_titleView clickShowPriceBlock:^{
            [weakSelf.headerView refreshAsset];
            [weakSelf.tableView reloadData];
        }];
    }
    return _titleView;
}
- (DBHWalletDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DBHWalletDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(336.5) + STATUS_HEIGHT + 44 + 30)];
        
        WEAKSELF
        [_headerView clickButtonBlock:^(NSInteger index) {
            switch (index) {
                case -2: { //显示/隐藏数量为0的资产
                    weakSelf.isHideZero = !weakSelf.isHideZero;
                    [[NSUserDefaults standardUserDefaults] setBool:weakSelf.isHideZero forKey:IS_HIDE_ZERO_KEY];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_ISHIDEZERO object:nil];
                    weakSelf.headerView.isHideZeroAsset = weakSelf.isHideZero;
                    [weakSelf.tableView reloadData];
                    break;
                }
                    
                case -1: {
                    // 显示/隐藏资产
                    weakSelf.titleView.totalAsset = weakSelf.titleView.totalAsset;
                    [weakSelf.tableView reloadData];
                    
                    break;
                }
                case 0: {
                    // 二维码
                    DBHQrCodeViewController *qrCodeViewController = [[DBHQrCodeViewController alloc] init];
                    qrCodeViewController.walletModel = weakSelf.neoWalletModel;
                    [weakSelf.navigationController pushViewController:qrCodeViewController animated:YES];
                    
                    break;
                }
                case 1: {
                    // 添加资产
                    DBHAddPropertyViewController *addPropertyViewController = [[DBHAddPropertyViewController alloc] init];
                    addPropertyViewController.walletModel = weakSelf.neoWalletModel;
                    [weakSelf.navigationController pushViewController:addPropertyViewController animated:YES];
                    
                    break;
                }
                case 2: {
                    // 加入
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                    
                    //                    DBHTokenSaleViewController *tokenSaleViewController = [[DBHTokenSaleViewController alloc] init];
                    //                    [weakSelf.navigationController pushViewController:tokenSaleViewController animated:YES];
                    break;
                }
                case 3: {
                    // 查看
                    
                    if (weakSelf.dataSource.count) {
                        DBHLookWalletInfoViewController *lookInfoVC = [[DBHLookWalletInfoViewController alloc] init];
                        NSMutableArray *flagArr = [NSMutableArray array];
                        for (DBHWalletDetailTokenInfomationModelData *data in weakSelf.dataSource) {
                            [flagArr addObject:data.flag];
                        }
                        lookInfoVC.unitsArr = [NSArray arrayWithArray:flagArr];
                        [weakSelf.navigationController pushViewController:lookInfoVC animated:YES];
                    } else {
                        NSLog(@"数据源为空");
                    }
                    
                    
                    //                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                    
                    break;
                }
                case 4: {
                    // 查看
                    [weakSelf.titleView refreshAsset];
                    
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    if ([[NSThread currentThread] isMainThread]) {
        _headerView.neoWalletModel = self.neoWalletModel;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _headerView.neoWalletModel = self.neoWalletModel;
        });
    }
    return _headerView;
}

- (void)setNeoWalletModel:(DBHWalletManagerForNeoModelList *)neoWalletModel {
    _neoWalletModel = neoWalletModel;
    if ([[NSThread currentThread] isMainThread]) {
        _headerView.neoWalletModel = self.neoWalletModel;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _headerView.neoWalletModel = self.neoWalletModel;
        });
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(62);
        
        _tableView.tableHeaderView = self.headerView;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHWalletDetailTableViewCell class] forCellReuseIdentifier:kDBHWalletDetailTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[DBHMenuView alloc] init];
        
        WEAKSELF
        [_menuView selectedBlock:^(NSInteger index) {
            if (weakSelf.neoWalletModel.isLookWallet) {
                if (![UserSignData share].user.isLogin) {
                    [[AppDelegate delegate] goToLoginVC:weakSelf];
                    return ;
                }
                
                if (!index) {
                    // 转化钱包
                    DBHImportWalletViewController *importWalletViewController = [[DBHImportWalletViewController alloc] init];
                    importWalletViewController.isTransform = YES;
                    importWalletViewController.neoWalletModel = weakSelf.neoWalletModel;
                    [weakSelf.navigationController pushViewController:importWalletViewController animated:YES];
                } else {
                    dispatch_async(dispatch_get_global_queue(
                                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                             0), ^{
                        // 删除钱包
                        [PPNetworkHelper DELETE:[NSString stringWithFormat:@"wallet/%ld", (NSInteger)weakSelf.neoWalletModel.listIdentifier] baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Deleting...", nil) success:^(id responseObject) {
                            [PDKeyChain delete:KEYCHAIN_KEY(weakSelf.neoWalletModel.address)];
                            [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Delete successfully", nil)];
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                            
                        } failure:^(NSString *error) {
                            [LCProgressHUD showFailure:error];
                        }];
                    });
                }
            } else {
                weakSelf.operationType = index + (self.menuArray.count == 3 ? 1 : 2);
                
                // 弹出密码框
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.inputPasswordPromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.inputPasswordPromptView animationShow];
                });
            }
        }];
    }
    return _menuView;
}
- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            switch (weakSelf.operationType) {
                case 1: {
                    // 备份助记词
                    NSString *data = [PDKeyChain load:KEYCHAIN_KEY(weakSelf.neoWalletModel.address)];
                    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"In the validation...", nil)];
                    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(globalQueue, ^
                                   {
                                       //子线程异步执行下载任务，防止主线程卡顿
                                       NSError * error;
                                       NeomobileWallet *Wallet = NeomobileFromKeyStore(data,password,&error);
                                       
                                       if (!error) {
                                           //子线程异步执行下载任务，防止主线程卡顿
                                           NSError * error;
                                           NSString * mnemonic = [Wallet mnemonic:[[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh_CN" : @"en_US" error:&error];
                                           dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                           //异步返回主线程，根据获取的数据，更新UI
                                           dispatch_async(mainQueue, ^
                                                          { 
                                                              if (!error)
                                                              {
                                                                  [LCProgressHUD hide];
                                                                  
                                                                  PackupsWordsVC * vc = [[PackupsWordsVC alloc] init];
                                                                  vc.mnemonic = mnemonic;
                                                                  
                                                                  WalletLeftListModel *model = [[WalletLeftListModel alloc] init];
                                                                  model.id = self.neoWalletModel.listIdentifier;
                                                                  model.category_id = self.neoWalletModel.categoryId;
                                                                  model.name = self.neoWalletModel.name;
                                                                  model.address = self.neoWalletModel.address;
                                                                  model.created_at = self.neoWalletModel.createdAt;
                                                                  vc.model = model;
                                                                  
                                                                  [self.navigationController pushViewController:vc animated:YES];
                                                              } else {
                                                                  [LCProgressHUD hide];
                                                                  [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Get mnemonic failed, please retry later!", nil)];
                                                              }
                                                              
                                                          });
                                           
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [LCProgressHUD hide];
                                               [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"The password is incorrect. Please try again later", nil)];
                                           });
                                       }
                                       
                                       
                                   });
                    
                    break;
                }
                case 2: {
                    //备份keyStore
                    NSString *data = [PDKeyChain load:KEYCHAIN_KEY(weakSelf.neoWalletModel.address)];
                    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"In the validation...", nil)];
                    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(globalQueue, ^
                                   {
                                       //子线程异步执行下载任务，防止主线程卡顿
                                       NSError * error;
                                       NeomobileFromKeyStore(data,password,&error);
                                       
                                       dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                       //异步返回主线程，根据获取的数据，更新UI
                                       dispatch_async(mainQueue, ^
                                                      {
                                                          if (!error)
                                                          {
                                                              //要分享内容
                                                              [LCProgressHUD hide];
//                                                              [weakSelf activityOriginalShare];
                                                              [weakSelf activityCustomShare];
                                                          } else {
                                                              [LCProgressHUD hide];
                                                              [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Wrong password, please re-enter", nil)];
                                                          }
                                                      });
                                       
                                   });
                    
                    break;
                }
                case 3: {
                    //删除
                    WEAKSELF
                    NSString *data = [PDKeyChain load:KEYCHAIN_KEY(self.neoWalletModel.address)];
                    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"In the validation...", nil)];
                    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(globalQueue, ^{
                        //子线程异步执行下载任务，防止主线程卡顿
                        NSError * error;
                        NeomobileFromKeyStore(data,password,&error);
                        
                        if (!error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [LCProgressHUD hide];
                                dispatch_async(globalQueue, ^{
                                    [PPNetworkHelper DELETE:[NSString stringWithFormat:@"wallet/%ld", (NSInteger)self.neoWalletModel.listIdentifier] baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Deleting...", nil) success:^(id responseObject) {
                                        
                                        [PDKeyChain delete:KEYCHAIN_KEY(weakSelf.neoWalletModel.address)];
                                        
                                        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Delete successfully", nil)];
                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                        
                                    } failure:^(NSString *error) {
                                        [LCProgressHUD showFailure:error];
                                    }];
                                });
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [LCProgressHUD hide];
                                [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"The password is incorrect. Please try again later", nil)];
                            });
                        }
                        
                    });
                    
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    return _inputPasswordPromptView;
}

- (void)activityOriginalShare {
    NSString *data = [PDKeyChain load:KEYCHAIN_KEY(self.neoWalletModel.address)];
    NSString *result = data;
    NSArray *activityItems = @[result];
    
    CustomActivity *weixinActivity = [[CustomActivity alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"WeChat", nil) ActivityImage:[UIImage imageNamed:@"fenxiang_weixin"] URL:[NSURL URLWithString:@"WeChat"] ActivityType:@"WeChat"];
    
    CustomActivity *momentsActivity = [[CustomActivity alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Moments", nil) ActivityImage:[UIImage imageNamed:@"friend_pr"] URL:[NSURL URLWithString:@"Moments"] ActivityType:@"Moments"];
    
    NSArray *activityArray = @[weixinActivity, momentsActivity];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activityArray];
    //applicationActivities可以指定分享的应用，不指定为系统默认支持的
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];
    kWeakSelf(activityVC)
    WEAKSELF
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if(completed) {
            if ([activityType isEqualToString:@"WeChat"]) {
                [WXApi sendReq:[weakSelf shareToWX:1 contet:result]];
            } else if ([activityType isEqualToString:@"Moments"]) {
                [WXApi sendReq:[weakSelf shareToWX:0 contet:result]];
            } else {
                [self backupSuccess:YES];
                NSLog(@"Share success");
            }
        } else {
            NSLog(@"Cancel the share");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakactivityVC dismissViewControllerAnimated:YES completion:nil];
        });
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:activityVC animated:YES completion:nil];
    });
}

- (void)backupSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Backup successfully", nil)];
        if ([NSString isNulllWithObject:[UserSignData share].user.walletIdsArray]) {
            [UserSignData share].user.walletIdsArray = [[NSMutableArray alloc] init];
        }
        if (![[UserSignData share].user.walletIdsArray containsObject:@(self.neoWalletModel.listIdentifier)]) {
            [[UserSignData share].user.walletIdsArray addObject:@(self.neoWalletModel.listIdentifier)];
            [[UserSignData share] storageData:[UserSignData share].user];
        }
        
        self.neoWalletModel.isBackUpMnemonnic = YES;
        self.headerView.neoWalletModel = self.neoWalletModel;
    } else {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Backup failed", nil)];
    }
    
    
}

#pragma mark ----- Share Delegate ------
- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    NSString *data = [PDKeyChain load:KEYCHAIN_KEY(self.neoWalletModel.address)];
    switch (index) {
        case 2: { // QQ
            [self shareToQQ:data];
            break;
        }
        default: {
            [WXApi sendReq:[self shareToWX:index contet:data]];
            break;
        }
            
    }
}

- (void)shareToQQ:(NSString *)content {
    WEAKSELF
    [[AppDelegate delegate] setQqResultBlock:^(QQBaseResp *res) {
        if ([res isKindOfClass:[SendMessageToQQResp class]]) {
            if (res.type == ESENDMESSAGETOQQRESPTYPE) { // 手Q->第三方
                if ([res.result intValue] == 0) { // 没有错误
                    [weakSelf backupSuccess:YES];
                } else {
                    if (res.result.intValue == -4) { // 取消分享
                        [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Cancel share", nil)];
                    } else {
                        [weakSelf backupSuccess:NO];
                    }
                }
            }
        }
    }];
    
    QQApiTextObject *textObj = [QQApiTextObject objectWithText:content];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:textObj];
    QQApiSendResultCode send = [QQApiInterface sendReq:req];
    [self handleSendResult:send];
}

- (void)handleSendResult:(QQApiSendResultCode)code {
    switch (code) {
        case EQQAPIAPPNOTREGISTED: // 未注册
            NSLog(@"未注册");
            break;
        case EQQAPIQQNOTINSTALLED:
            [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Please install QQ mobile", nil)]; // todo
            break;
        case EQQAPISENDFAILD:
            [self backupSuccess:NO];
            break;
        default:
            break;
    }
}

/**
 发送消息到微信
 
 @param index 0 - 朋友圈  1 - 好友
 @return 消息
 */
- (SendMessageToWXReq *)shareToWX:(NSInteger)index contet:(NSString *)content {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    WEAKSELF
    [appDelegate setResultBlock:^(BaseResp *res) {
        if ([res isKindOfClass:[SendMessageToWXResp class]]) {
            if (res.errCode == 0) { // 没有错误
                //本地记录备份了
                [weakSelf backupSuccess:YES];
            } else {
                if (res.errCode == -2) { // cancel
                } else {
                    [weakSelf backupSuccess:NO];
                }
            }
        }
    }];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;           // 指定为发送文本
    req.text = content;
    
    if (index == 0) {
        req.scene = WXSceneTimeline; // 朋友圈
    } else {
        req.scene =  WXSceneSession; // 好友
    }
    return req;
}


- (NSMutableArray *)menuArray {
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
        
        if (self.neoWalletModel.isLookWallet) {
            _menuArray = [@[@"Convert to Hot Wallet", @"Delete Wallet"] mutableCopy];
        } else {
            _menuArray = [@[@"Backup Mnemonic", @"Backup Keystore", @"Delete Wallet"] mutableCopy];
        }
    }
    return _menuArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)noZeroDatasource {
    if (!_noZeroDatasource) {
        _noZeroDatasource = [NSMutableArray array];
    }
    return _noZeroDatasource;
}

- (void)activityCustomShare {
    [[UIApplication sharedApplication].keyWindow addSubview:self.sharedMenuView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sharedMenuView show];
    });
}

- (LYShareMenuView *)sharedMenuView {
    if (!_sharedMenuView) {
        _sharedMenuView = [[LYShareMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        LYShareMenuItem *friendItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"friend_pr" itemTitle:DBHGetStringWithKeyFromTable(@"Moments", nil)];
        LYShareMenuItem *weixinItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"weixin_pr" itemTitle:DBHGetStringWithKeyFromTable(@"WeChat", nil)];
        LYShareMenuItem *qqItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"qq_pr" itemTitle:@"QQ"];
        
        _sharedMenuView.shareMenuItems = [NSMutableArray arrayWithObjects:friendItem, weixinItem, qqItem, nil];
    }
    if (!_sharedMenuView.delegate) {
        _sharedMenuView.delegate = self;
    }
    return _sharedMenuView;
}

- (DBHWalletDetailTokenInfomationModelData *)neoModel {
    if (!_neoModel) {
        _neoModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        _neoModel.name = @"NEO";
        _neoModel.icon = @"NEO_add";
        _neoModel.balance = @"0";
        _neoModel.priceCny = @"0";
        _neoModel.priceUsd = @"0";
        _neoModel.flag = @"NEO";
        _neoModel.symbol = NEO;
    }
    return _neoModel;
}

- (DBHWalletDetailTokenInfomationModelData *)gasModel {
    if (!_gasModel) {
        _gasModel = [[DBHWalletDetailTokenInfomationModelData alloc] init];
        _gasModel.name = GAS;
        _gasModel.icon = @"NEO_add";
        _gasModel.balance = @"0";
        _gasModel.priceCny = @"0";
        _gasModel.priceUsd = @"0";
        _gasModel.flag = GAS;
    }
    return _gasModel;
}
@end

