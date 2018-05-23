//
//  YYRedPacketPackagingViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketPackagingViewController.h"
#import "YYRedPacketSendSecondViewController.h"
#import "YYRedPacketSendThirdViewController.h"
#import "LDProgressView.h"
#import "SystemConvert.h"

@interface YYRedPacketPackagingViewController () {
    dispatch_queue_t queue;
    dispatch_group_t group;
    dispatch_source_t timer;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *backToHomeBtn;
@property (weak, nonatomic) IBOutlet UILabel *afterTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet LDProgressView *progress;

@property (nonatomic, copy) NSString *auth_tx_id; // 授权的tx_id
@property (nonatomic, assign) NSInteger auth_block; // 授权的块高

@property (nonatomic, copy) NSString * minBlockNumber;  //最小块高 确认 12
@property (nonatomic, assign) NSString *currentBlockNumber;  //当前块高
@property (nonatomic, copy) NSString * blockPerSecond;  //发生时间  5

@property (nonatomic, assign) BOOL isHaveNoFinishOrder;

@end

@implementation YYRedPacketPackagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    if (self.packageType == PackageTypeCash) { // 礼金打包
        [self transferAccountsForETHToken];
    }
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redPacketNavigationBar];
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send RedPacket", nil);
    
    if (self.packageType == PackageTypeCash) {
        self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Cash Packaging", nil);
    } else {
        self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Red Packet Creating", nil);
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"(%@)", DBHGetStringWithKeyFromTable(@"Waitting Confirm", nil)];
    self.afterTipLabel.text = DBHGetStringWithKeyFromTable(@"Check the creation of the red packets later", nil);
    [self.backToHomeBtn setTitle:DBHGetStringWithKeyFromTable(@"Back To RedPacket Home Page", nil) forState:UIControlStateNormal];
    
    [self.nextBtn setTitle:DBHGetStringWithKeyFromTable(@"Next", nil) forState:UIControlStateNormal];
    
    [self.nextBtn setCorner:2];
    [self.nextBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    [self.nextBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    
    CALayer *layer = [CALayer layer];
    if (self.packageType == PackageTypeCash) {
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.25, 4);
    } else {
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 4);
    }
    
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    
    self.progress.progress = 0.0f;
    self.progress.showText = @0;
    
    self.nextBtn.enabled = NO;
}


#pragma mark ------- Data ---------

//获取最小块高  默认12
- (void)loadMinblockNumber {
    WEAKSELF
    [PPNetworkHelper GET:@"min-block" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:3];
    } failure:^(NSString *error) {
        NSLog(@"group---- leave  loadMinblockNumber error = %@", error);
        dispatch_group_leave(group);
    }];
}

/**
 获取轮询时间
 */
- (void)getBlockPerSecond {
    WEAKSELF
    //获取轮询时间 当前块发生速度  最小5秒
    [PPNetworkHelper POST:@"extend/blockPerSecond" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:4];
    } failure:^(NSString *error) {
        NSLog(@"group---- leave  getBlockPerSecond error = %@", error);
        dispatch_group_leave(group);
    }];
}

//当前当前块号
- (void)loadCurrentblockNumber {
    if (!self.isHaveNoFinishOrder) {
        dispatch_suspend(timer);
        dispatch_source_cancel(timer);
        
        return;
    }
    
    WEAKSELF
    [PPNetworkHelper POST:@"extend/blockNumber" baseUrlType:1 parameters:nil hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:5];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

/**
 ETH转账
 */
- (void)transferAccountsForETHToken {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //ETH代币转账
        NSString *addr = self.walletModel.address;
        if (addr.length > 0) {
            if (![addr hasPrefix:@"0x"]) {
                addr = [NSString stringWithFormat:@"0x%@", addr];
            }
            
            NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
            [parametersDic setObject:addr forKey:@"address"];
            
            WEAKSELF
            [PPNetworkHelper POST:@"extend/getTransactionCount" baseUrlType:1 parameters:parametersDic hudString:nil success:^(id responseObject) {
                [weakSelf handleResponseObj:responseObject type:0];
            } failure:^(NSString *error) {
                [LCProgressHUD showFailure:error];
            }];
            
        }
    });
}

/**
 去授权
 */
- (void)gotoAuth:(NSString *)authTxID withBlock:(NSString *)authBlock {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (![NSObject isNulllWithObject:authTxID]) {
        [params setObject:authTxID forKey:AUTH_TX_ID];
    }
    
    [params setObject:@(authBlock.integerValue) forKey:AUTH_BLOCK];
    
    NSString *addr = self.walletModel.address;
    NSString *symbol = self.tokenModel.name;
    if (![NSObject isNulllWithObject:addr]) {
        [params setObject:addr forKey:REDBAG_ADDR];
    }
    
    if (![NSObject isNulllWithObject:symbol]) {
        [params setObject:symbol forKey:REDBAG_SYMBOL];
    }
    
    if (![NSObject isNulllWithObject:self.redbag]) {
        [params setObject:self.redbag forKey:REDBAG];
    }
    
    [params setObject:[NSString stringWithFormat:@"%ld", self.redbag_number] forKey:REDBAG_NUMBER];
    
    
    [PPNetworkHelper POST:@"redbag/auth" baseUrlType:3 parameters:params hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:2];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}


- (void)handleResponseObj:(id)responseObj type:(NSInteger)type {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (type == 0) { // ETH代币转账
            if (![responseObj isKindOfClass:[NSDictionary class]]) {
                return;
            }
            NSString *count = responseObj[@"count"];
            if ([NSObject isNulllWithObject:count]) {
                count = @"0";
            }
            
            NSError * error;
            long long transfer = self.redbag.doubleValue * pow(10, self.tokenModel.decimals);
            NSString *transferStr = [NSString stringWithFormat:@"0x%@", [NSString getHexByDecimal:transfer]];
            NSString *gas = [NSString DecimalFuncWithOperatorType:2 first:self.poundage secend:@"1000000000000000000" value:10];
            
            gas = [NSString DecimalFuncWithOperatorType:3 first:gas secend:self.tokenModel.gas value:8];
            
            if ([NSObject isNulllWithObject:gas]) {
                gas = @"0";
            }
            
            gas = [NSString stringWithFormat:@"0x%@", [SystemConvert decimalToHex:gas.doubleValue]];
            
            NSString *gasLimit = [NSString stringWithFormat:@"0x%@",[NSString getHexByDecimal:self.tokenModel.gas.integerValue]];
            
            NSString *contractAddr = TEST_REDPACKET_CONTRACT_ADDRESS;
            if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) { // 正式网还没有 YYTODO
                contractAddr = REDPACKET_CONTRACT_ADDRESS;
            }
            
            NSString *data = [self.walletModel.ethWallet transferERC20:self.tokenModel.address
                                                     nonce:count
                                                        to:contractAddr
                                                    amount:self.redbag
                                                  gasPrice:gas
                                                 gasLimits:gasLimit
                                                     error:&error];
            if (!error) {
                //热钱包生成订单
                [self creatOrderWithData:[NSString stringWithFormat:@"0x%@",data] asset_id:[self.tokenModel.address lowercaseString] transferNum:transferStr handleFee:gasLimit contractAddr:contractAddr];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                     [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer failed, please try again later", nil)]; // YYTODO
                });
            }
        } else if (type == 1) { // 创建转账订单
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                NSString *auth_tx_id = responseObj[@"tx"];
                NSString *auth_block = responseObj[@"blocks"];
                [self gotoAuth:auth_tx_id withBlock:auth_block];
            }
        } else if (type == 2) { // 授权
            self.auth_block = [responseObj[@"auth_block"] integerValue];
            
            // 创建全局并行
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            group = dispatch_group_create();
            
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                [self loadMinblockNumber];
            });
            
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                [self getBlockPerSecond];
            });
            
            dispatch_group_notify(group, queue, ^{
                self.isHaveNoFinishOrder = YES;
                timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW,
                                          self.blockPerSecond.floatValue * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
                dispatch_source_set_event_handler(timer, ^() {
                    [self loadCurrentblockNumber];
                });
                dispatch_resume(timer);
            });
        } else if (type == 3) { // 最小块高
            self.minBlockNumber = [responseObj objectForKey:MIN_BLOCK_NUM];
            dispatch_group_leave(group);
        } else if (type == 4) { // 轮询时间
            self.blockPerSecond = [NSString stringWithFormat:@"%f", 1 / [[responseObj objectForKey:BPS] floatValue]];
            dispatch_group_leave(group);
        } else if (type == 5) { // 当前块高
            NSString *value = [responseObj objectForKey:VALUE];
            if (value.length > 2) {
                value = [value substringFromIndex:2];
                self.currentBlockNumber = [NSString stringWithFormat:@"%@",[NSString numberHexString:value]];
                
                //（当前块高 - 订单里的块高 + 1）/最小块高
                NSInteger number = self.currentBlockNumber.integerValue - self.auth_block + 1;
                if (number < 0) {
                    //小于0 置为0
                    number = 0;
                }
                
                if (number < self.minBlockNumber.integerValue) {
                    self.isHaveNoFinishOrder = YES;
                } else {
                    number = self.minBlockNumber.integerValue;
                    self.isHaveNoFinishOrder = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.nextBtn.enabled = YES;
                    });
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.statusLabel.text = [NSString stringWithFormat:@"(%@%ld/%@)", DBHGetStringWithKeyFromTable(@"Confirmed", nil), number, self.minBlockNumber];
                    self.progress.progress = (CGFloat)number / self.minBlockNumber.floatValue;
                });
            }
        }
    });
}

/**
 上传后台提交ETH订单
 */
- (void)creatOrderWithData:(NSString *)data asset_id:(NSString *)asset_id transferNum:(NSString *)transferNum handleFee:(NSString *)handleFee contractAddr:(NSString *)contractAddr {
    //创建钱包订单
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(self.walletModel.listIdentifier) forKey:WALLET_ID];
    [dic setObject:data forKey:@"data"];
    [dic setObject:[self.walletModel.address lowercaseString] forKey:PAY_ADDRESS];
    [dic setObject:[contractAddr lowercaseString] forKey:RECEIVE_ADDRESS];
    [dic setObject:transferNum forKey:FEE];
    [dic setObject:self.tokenModel.name forKey:@"flag"];
    [dic setObject:asset_id forKey:@"asset_id"];
    
    if ([self.tokenModel.name isEqualToString:ETH]) { // eth
        [dic setObject:[NSString stringWithFormat:@"0x%@", [NSString getHexByDecimal:[NSString DecimalFuncWithOperatorType:2 first:self.poundage secend:@"1000000000000000000" value:8].integerValue]] forKey:HANDLE_FEE];
    } else { // 代币
        [dic setObject:handleFee forKey:HANDLE_FEE];
    }
    
    WEAKSELF
    [PPNetworkHelper POST:@"wallet-order" baseUrlType:1 parameters:dic hudString:nil success:^(id responseObject) {
        [weakSelf handleResponseObj:responseObject type:1];
     } failure:^(NSString *error) {
         [LCProgressHUD showFailure:error];
     }];
}



#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToBackToHomeBtn:(UIButton *)sender {
    self.backIndex = 2;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)respondsToNextBtn:(UIButton *)sender {
    if (self.packageType == PackageTypeCash) {
        YYRedPacketSendSecondViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_SECOND_STORYBOARD_ID];
        vc.tokenModel = self.tokenModel;
        vc.walletModel = self.walletModel;
        vc.redbag_number = self.redbag_number;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        YYRedPacketSendThirdViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_SEND_THIRD_STORYBOARD_ID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
