//
//  DBHTransferConfirmationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTransferConfirmationViewController.h"

#import "SystemConvert.h"

#import "DBHInputPasswordPromptView.h"

#import "DBHWalletDetailTokenInfomationModelData.h"


@interface DBHTransferConfirmationViewController ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *poundageLabel;
@property (nonatomic, strong) UILabel *originalPoundageLabel;
@property (nonatomic, strong) UILabel *collectionAddressLabel;
@property (nonatomic, strong) UILabel *collectionAddressValueLabel;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UILabel *remarkValueLabel;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;

@end

@implementation DBHTransferConfirmationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Transfer Confirmation", nil);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.unitLabel];
    [self.view addSubview:self.poundageLabel];
    [self.view addSubview:self.originalPoundageLabel];
    [self.view addSubview:self.collectionAddressLabel];
    [self.view addSubview:self.collectionAddressValueLabel];
    [self.view addSubview:self.grayLineView];
    [self.view addSubview:self.remarkLabel];
    [self.view addSubview:self.remarkValueLabel];
    [self.view addSubview:self.sureButton];
    
    WEAKSELF
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(47));
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.numberLabel.mas_right);
        make.bottom.equalTo(weakSelf.numberLabel).offset(- AUTOLAYOUTSIZE(5));
    }];
    [self.poundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(AUTOLAYOUTSIZE(8));
    }];
    [self.originalPoundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.poundageLabel.mas_bottom).offset(AUTOLAYOUTSIZE(5));
    }];
    [self.collectionAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.bottom.equalTo(weakSelf.collectionAddressValueLabel.mas_top).offset(- AUTOLAYOUTSIZE(11.5));
    }];
    [self.collectionAddressValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.bottom.equalTo(weakSelf.grayLineView.mas_top).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(60));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(AUTOLAYOUTSIZE(150));
    }];
    [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(40));
    }];
    [self.remarkValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.remarkLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11.5));
    }];
    [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(47.5));
    }];
}

#pragma mark ------ Data ------
/**
 ETH转账
 */
- (void)transferAccountsForETHWithPassword:(NSString *)password {
    // ETH钱包转账
    //子线程异步执行下载任务，防止主线程卡顿
    NSError * error;
    id data = [PDKeyChain load:KEYCHAIN_KEY(self.neoWalletModel.address)];
    EthmobileWallet * Wallet = EthmobileFromKeyStore(data,password,&error);
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //异步返回主线程，根据获取的数据，更新UI
    dispatch_async(mainQueue, ^ {
                       if (!error) {
                           if (![self.tokenModel.name isEqualToString:@"ETH"]) { // eth代币
                                   //热钱包代币转账
                                NSString *addr = self.neoWalletModel.address;
                               if (addr.length > 0) {
                                   if (![addr hasPrefix:@"0x"]) {
                                       addr = [NSString stringWithFormat:@"0x%@", addr];
                                   }
                                   
                                   NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
                                   [parametersDic setObject:addr forKey:@"address"];
                                   
                                   WEAKSELF
                                   [PPNetworkHelper POST:@"extend/getTransactionCount" baseUrlType:1 parameters:parametersDic hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
                                       if (responseObject) {
                                           NSString *count = responseObject[@"count"];
                                           if ([NSObject isNulllWithObject:count]) {
                                               count = @"0";
                                           }
                                           
                                           NSError * error;
                                           long long transfer = weakSelf.transferNumber.doubleValue * pow(10, weakSelf.tokenModel.decimals.integerValue);
                                           
                                           NSString *transferStr = [NSString stringWithFormat:@"0x%@", [NSString getHexByDecimal:transfer]];
                                           
                                           NSString *gas = [NSString DecimalFuncWithOperatorType:2 first:weakSelf.poundage secend:@"1000000000000000000" value:10];
                                           
                                           gas = [NSString DecimalFuncWithOperatorType:3 first:gas secend:weakSelf.tokenModel.gas value:8];
                                           
                                           if ([NSObject isNulllWithObject:gas]) {
                                               gas = @"0";
                                           }
                                           
                                           gas = [NSString stringWithFormat:@"0x%@", [SystemConvert decimalToHex:gas.doubleValue]];
                                           
                                           NSString *gasLimit = [NSString stringWithFormat:@"0x%@",[NSString getHexByDecimal:weakSelf.tokenModel.gas.integerValue]];
                                           
                                           NSString *data = [Wallet transferERC20:weakSelf.tokenModel.address
                                                                            nonce:count
                                                                               to:weakSelf.address
                                                                           amount:transferStr
                                                                         gasPrice:gas
                                                                        gasLimits:gasLimit
                                                                            error:&error];
                                           if (!error) {
                                               [LCProgressHUD hide];
                                               [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer successfully", nil)];
                                               
                                               //热钱包生成订单
                                               [weakSelf creatOrderWithData:[NSString stringWithFormat:@"0x%@",data] asset_id:[weakSelf.tokenModel.address lowercaseString] transferNum:transferStr handleFee:gasLimit];
                                           } else {
                                               [LCProgressHUD hide];
                                               [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer failed, please try again later", nil)];
                                           }
                                           
                                       }
                                   } failure:^(NSString *error) {
                                       [LCProgressHUD showFailure:error];
                                   }];
                               }
                               /**
                                   NSString * price = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:[[NSString stringWithFormat:@"%.0f000000000000",[self.transferNumber floatValue] * 1000000] longLongValue]]];
                                   NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
                                   [parametersDic setObject:[self.tokenModel.address lowercaseString] forKey:@"contract"];
                                   [parametersDic setObject:[self.address lowercaseString] forKey:@"to"];
                                   [parametersDic setObject:price forKey:VALUE];
                                   
                                   [PPNetworkHelper POST:@"extend/transferABI" baseUrlType:1 parameters:parametersDic hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
                                        //生成data
                                        NSError * error;
                                        NSString * gas = [SystemConvert decimalToHex:[[NSString stringWithFormat:@"%@",[NSString DecimalFuncWithOperatorType:2 first:self.poundage secend:@"1000000000000000000" value:10]] integerValue]];
                                        
                                        NSString *data = [Wallet transferERC20:[responseObject objectForKey:@"data"]
                                                                        nonce:self.nonce to:self.address
                                                                       amount:self.transferNumber
                                                                     gasPrice:[NSString stringWithFormat:@"0x%@",gas]
                                                                    gasLimits:[NSString stringWithFormat:@"0x%@",[NSString getHexByDecimal:self.tokenModel.gas.integerValue]]
                                                                        error:&error];
                                        
                                        dispatch_queue_t mainQueue = dispatch_get_main_queue();
                                        //异步返回主线程，根据获取的数据，更新UI
                                        dispatch_async(mainQueue, ^
                                                       {
                                                           if (!error)
                                                           {
                                                               [LCProgressHUD hide];
                                                               [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer successfully", nil)];
                                                               
                                                               //热钱包生成订单
                                                               [self creatOrderWithData:[NSString stringWithFormat:@"0x%@",data] asset_id:[self.tokenModel.address lowercaseString]];
                                                           }
                                                           else
                                                           {
                                                               [LCProgressHUD hide];
                                                               [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer failed, please try again later", nil)];
                                                           }
                                                       });
                                        
                                    } failure:^(NSString *error)
                                    {
                                        [LCProgressHUD hide];
                                        [LCProgressHUD showFailure:error];
                                    }];
                               */
//                               }
                           } else { // eth
                               //普通钱包转账
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               
                               long long transfer = self.transferNumber.doubleValue * 1000000000000000000;
                               NSString * price = [NSString getHexByDecimal:transfer];
                               price = [NSString stringWithFormat:@"0x%@", price];
                               
                               NSString *gas = [NSString DecimalFuncWithOperatorType:3 first:self.poundage secend:@"90000" value:18];
                               gas = [NSString DecimalFuncWithOperatorType:2 first:gas secend:@"1000000000000000000" value:0];
                               
                               NSString * gasPrice = [SystemConvert decimalToHex:gas.integerValue];
                               gasPrice = [NSString stringWithFormat:@"0x%@", [gasPrice lowercaseString]];
                               
                               NSString *data = [Wallet transfer:self.nonce
                                                             to:[self.address lowercaseString]
                                                         amount:price
                                                       gasPrice:gasPrice
                                                      gasLimits:@"0x15f90" error:&error];
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer successfully", nil)];
                                                      
//                                                      if (self.isCodeWallet)
//                                                      {
//                                                          //冷钱包进入 转账后生成二维码转给观察钱包
//                                                          [self creatCIQRCodeImageWithString:[NSString stringWithFormat:@"0x%@",[NSString convertDataToHexStr:data]]];
//                                                          [self.codeWalletCodeView showWithView:nil];
//                                                      }
//                                                      else
//                                                      {
                                                          //热钱包生成订单
                                                          [self creatOrderWithData:[NSString stringWithFormat:@"0x%@",data] asset_id:@"0x0000000000000000000000000000000000000000" transferNum:price handleFee:gasPrice];
//                                                      }
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer failed, please try again later", nil)];
                                                  }
                                              });
                           }
                           
                       } else {
                           [LCProgressHUD hide];
                           [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"The password is incorrect. Please try again later", nil)];
                       }
                   });
}
/**
 NEO转账
 */
- (void)transferAccountsForNEOWithPassword:(NSString *)password unspent:(NSString *)unspent {
    id data = [PDKeyChain load:KEYCHAIN_KEY(self.neoWalletModel.address)];
    NSString *assert = [self.tokenModel.flag isEqualToString:@"NEO"] ? @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" : @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
    // NEO钱包转账
    //子线程异步执行下载任务，防止主线程卡顿
    NSError * error;
    NeomobileWallet *Wallet = NeomobileFromKeyStore(data, password, &error);
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //异步返回主线程，根据获取的数据，更新UI
    dispatch_async(mainQueue, ^
                   {
                       if (!error)
                       {
                           //代币钱包转账
//                           if (self.isCodeWallet)
//                           {
//                               //冷钱包进入 转账后生成二维码转给观察钱包
//                               //生成data
//                               NSError * error;
//
//                               [Wallet createAssertTx:assert from:Wallet.address to:self.address amount:self.price.doubleValue unspent:unspent error:&error];
//
//                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
//                               //异步返回主线程，根据获取的数据，更新UI
//                               dispatch_async(mainQueue, ^
//                                              {
//                                                  if (!error)
//                                                  {
//                                                      [LCProgressHUD hide];
//                                                      [self caneButtonClicked];
//                                                      [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer successfully", nil)];
//
//                                                      //冷钱包
//                                                      [self creatCIQRCodeImageWithString:[NSString stringWithFormat:@"0x%@",[NSString convertDataToHexStr:data]]];
//                                                      [self.codeWalletCodeView showWithView:nil];
//                                                  }
//                                                  else
//                                                  {
//                                                      [LCProgressHUD hide];
//                                                      [self caneButtonClicked];
//                                                      [LCProgressHUD showMessage:@"转账失败，请稍后重试"];
//                                                  }
//                                              });
//
//
//                           }
//                           else
//                           {
                               //热钱包代币转账
//                               NSString * price = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:[[NSString stringWithFormat:@"%.0f000000000000",[self.transferNumber floatValue] * 1000000] longLongValue]]];
//                               NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
//                               [parametersDic setObject:self.neoWalletModel.address forKey:@"contract"];
//                               [parametersDic setObject:self.address forKey:@"to"];
//                               [parametersDic setObject:price forKey:VALUE];
                           
                               //生成data
                               NSError * error;
                               NeomobileTx *tx = [Wallet createAssertTx:assert from:Wallet.address to:self.address amount: self.transferNumber.doubleValue unspent:unspent error:&error];
                           
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer successfully", nil)];
                                                      
                                                      //热钱包生成订单
                                                      [self creatNeoOrderWithData:tx.data trade_no:tx.id_];
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer failed, please try again later", nil)];
                                                  }
                                              });
//                           }
                       } else {
                           [LCProgressHUD hide];
                           [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"The password is incorrect. Please try again later", nil)];
                       }
                   });
}
/**
 TNC转账
 */
- (void)transferAccountsForTNCWithPassword:(NSString *)password unspent:(NSString *)unspent {
    id data = [PDKeyChain load:KEYCHAIN_KEY(self.neoWalletModel.address)];
    // NEO钱包转账
    //子线程异步执行下载任务，防止主线程卡顿
    NSError * error;
    NeomobileWallet *Wallet = NeomobileFromKeyStore(data, password, &error);
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //异步返回主线程，根据获取的数据，更新UI
    dispatch_async(mainQueue, ^
                   {
                       if (!error)
                       {
                           //代币钱包转账
                           //                           if (self.isCodeWallet)
                           //                           {
                           //                               //冷钱包进入 转账后生成二维码转给观察钱包
                           //                               //生成data
                           //                               NSError * error;
                           //
                           //                               [Wallet createAssertTx:assert from:Wallet.address to:self.address amount:self.price.doubleValue unspent:unspent error:&error];
                           //
                           //                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                           //                               //异步返回主线程，根据获取的数据，更新UI
                           //                               dispatch_async(mainQueue, ^
                           //                                              {
                           //                                                  if (!error)
                           //                                                  {
                           //                                                      [LCProgressHUD hide];
                           //                                                      [self caneButtonClicked];
                           //                                                      [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer successfully", nil)];
                           //
                           //                                                      //冷钱包
                           //                                                      [self creatCIQRCodeImageWithString:[NSString stringWithFormat:@"0x%@",[NSString convertDataToHexStr:data]]];
                           //                                                      [self.codeWalletCodeView showWithView:nil];
                           //                                                  }
                           //                                                  else
                           //                                                  {
                           //                                                      [LCProgressHUD hide];
                           //                                                      [self caneButtonClicked];
                           //                                                      [LCProgressHUD showMessage:@"转账失败，请稍后重试"];
                           //                                                  }
                           //                                              });
                           //
                           //
                           //                           }
                           //                           else
                           //                           {
                           //热钱包代币转账
//                           NSString * price = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:[[NSString stringWithFormat:@"%.0f000000000000",[self.transferNumber floatValue] * [self.tokenModel.decimals floatValue]] longLongValue]]];
//                           NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
//                           [parametersDic setObject:self.neoWalletModel.address forKey:@"contract"];
//                           [parametersDic setObject:self.address forKey:@"to"];
//                           [parametersDic setObject:price forKey:VALUE];
                           
                           //生成data
                           NSError * error;
                           NeomobileTx *tx = [Wallet createNep5Tx:self.tokenModel.address from:NeomobileDecodeAddress(self.neoWalletModel.address, nil) to:NeomobileDecodeAddress(self.address, nil) amount:(NSInteger)(self.transferNumber.doubleValue * pow(10, self.tokenModel.decimals.doubleValue)) unspent:unspent error:&error];
                           
                           dispatch_queue_t mainQueue = dispatch_get_main_queue();
                           //异步返回主线程，根据获取的数据，更新UI
                           dispatch_async(mainQueue, ^  {
                                              if (!error) {
                                                  [LCProgressHUD hide];
                                                  [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer successfully", nil)];
                                                  
                                                  //热钱包生成订单
                                                  [self creatNeoOrderWithData:tx.data trade_no:tx.id_];
                                              } else {
                                                  [LCProgressHUD hide];
                                                  [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Transfer failed, please try again later", nil)];
                                              }
                                              
                                          });
                           //                           }
                       } else {
                           [LCProgressHUD hide];
                           [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"The password is incorrect. Please try again later", nil)];
                       }
                   });
}
/**
 上传后台提交ETH订单
 */
- (void)creatOrderWithData:(NSString *)data asset_id:(NSString *)asset_id transferNum:(NSString *)transferNum handleFee:(NSString *)handleFee {
    //创建钱包订单
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(self.neoWalletModel.listIdentifier) forKey:WALLET_ID];
    [dic setObject:data forKey:@"data"];
    [dic setObject:[self.neoWalletModel.address lowercaseString] forKey:PAY_ADDRESS];
    [dic setObject:[self.address lowercaseString] forKey:RECEIVE_ADDRESS];
    [dic setObject:self.remark forKey:REMARK];
    [dic setObject:transferNum forKey:FEE];
    
    if ([self.tokenModel.flag isEqualToString:ETH]) { // eth
        [dic setObject:[NSString stringWithFormat:@"0x%@", [NSString getHexByDecimal:[NSString DecimalFuncWithOperatorType:2 first:self.poundage secend:@"1000000000000000000" value:8].integerValue]] forKey:HANDLE_FEE];
    } else { // 代币
        [dic setObject:handleFee forKey:HANDLE_FEE];
    }
    [dic setObject:self.tokenModel.name forKey:@"flag"];
    [dic setObject:asset_id forKey:@"asset_id"];
    
    WEAKSELF
    [PPNetworkHelper POST:@"wallet-order" baseUrlType:1 parameters:dic hudString:DBHGetStringWithKeyFromTable(@"Creating...", nil) success:^(id responseObject)
     {
         //进入订单详情
         /*
          WalletOrderModel * model = [[WalletOrderModel alloc] initWithDictionary:dic];
          model.fee = self.price;
          model.handle_fee = self.totleGasPrice;
          model.created_at = [NSString nowDate];
          TransactionInfoVC * vc = [[TransactionInfoVC alloc] init];
          vc.isTransfer = YES;˜
          vc.model = model;
          vc.isNotPushWithList = YES;
          [self.navigationController pushViewController:vc animated:YES];
          */
         //返回转账列表
         [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Order successfully created", nil)];
         [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[2] animated:YES];
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
         //         [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
     }];
   
    /*
     //发送签名后的交易[post] extend/sendRawTransaction
     NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
     [parametersDic setObject:data forKey:@"data"];
     
     [PPNetworkHelper POST:@"extend/sendRawTransaction" parameters:parametersDic hudString:@"转账中..." success:^(id responseObject)
     {
     } failure:^(NSString *error)
     {
     [LCProgressHUD showFailure:error];
     }];
     */
}
/**
 上传后台提交NEO订单
 */
- (void)creatNeoOrderWithData:(NSString *)data trade_no:(NSString *)trade_no {
    //创建钱包订单
    NSString *assert;
    if ([self.tokenModel.flag isEqualToString:NEO]) {
        assert = @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b";
    } else if ([self.tokenModel.flag isEqualToString:GAS]) {
        assert = @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7";
    } else {
        NSString *address = self.tokenModel.address;
        if([address containsString:@"0x"]) {
            assert = address;
        } else {
            assert = [NSString stringWithFormat:@"0x%@", address];
        }
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(self.neoWalletModel.listIdentifier) forKey:WALLET_ID];
    [dic setObject:data forKey:@"data"];
    [dic setObject:self.neoWalletModel.address forKey:PAY_ADDRESS];
    [dic setObject:self.address forKey:RECEIVE_ADDRESS];
    [dic setObject:self.remark forKey:REMARK];
    
    NSString *feeStr = self.transferNumber;
    if (![self.tokenModel.flag isEqualToString:NEO] &&
        ![self.tokenModel.flag isEqualToString:GAS]) {
        feeStr = [NSString stringWithFormat:@"%.0lf", self.transferNumber.doubleValue * pow(10, self.tokenModel.decimals.doubleValue)];
    }
    [dic setObject:feeStr forKey:FEE];
    [dic setObject:@"0" forKey:HANDLE_FEE];
    [dic setObject:@"NEO" forKey:@"flag"];
    [dic setObject:[NSString stringWithFormat:@"0x%@", trade_no] forKey:TRADE_NO];
    [dic setObject:assert forKey:@"asset_id"];
    
    [PPNetworkHelper POST:@"wallet-order" baseUrlType:1 parameters:dic hudString:DBHGetStringWithKeyFromTable(@"Creating...", nil) success:^(id responseObject) {
         //进入订单详情
         /*
          WalletOrderModel * model = [[WalletOrderModel alloc] initWithDictionary:dic];
          model.fee = self.price;
          model.handle_fee = self.totleGasPrice;
          model.created_at = [NSString nowDate];
          TransactionInfoVC * vc = [[TransactionInfoVC alloc] init];
          vc.isTransfer = YES;˜
          vc.model = model;
          vc.isNotPushWithList = YES;
          [self.navigationController pushViewController:vc animated:YES];
          */
         //返回转账列表
         [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Order successfully created", nil)];
         [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
         
     } failure:^(NSString *error) {
         [LCProgressHUD showFailure:error];
         //         [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
     }];
    /*
     //发送签名后的交易[post] extend/sendRawTransaction
     NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
     [parametersDic setObject:data forKey:@"data"];
     
     [PPNetworkHelper POST:@"extend/sendRawTransaction" parameters:parametersDic hudString:@"转账中..." success:^(id responseObject)
     {
     } failure:^(NSString *error)
     {
     [LCProgressHUD showFailure:error];
     }];
     */
}
- (void)getUnspentWithPassword:(NSString *)password {
    WEAKSELF
    if ([self.tokenModel.flag isEqualToString:GAS]) {
        [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", self.neoWalletModel.address, @"neo-gas-asset-id"] baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            NSArray *result = responseObject[@"result"];
            [weakSelf transferAccountsForNEOWithPassword:password unspent:[result toJSONStringForArray]];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    } else if ([self.tokenModel.flag isEqualToString:NEO]) {
        [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", self.neoWalletModel.address, @"neo-asset-id"] baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            NSArray *result = responseObject[@"result"];
            [weakSelf transferAccountsForNEOWithPassword:password unspent:[result toJSONStringForArray]];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    } else {
        NSMutableArray *result = [NSMutableArray array];
        [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", self.neoWalletModel.address, @"neo-asset-id"] baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            [result addObjectsFromArray:responseObject[@"result"]];
            [PPNetworkHelper GET:[NSString stringWithFormat:@"extend/getNeoUtxo?address=%@&type=%@", weakSelf.neoWalletModel.address, @"neo-gas-asset-id"] baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
                [result addObjectsFromArray:responseObject[@"result"]];
                [weakSelf transferAccountsForTNCWithPassword:password unspent:[result toJSONStringForArray]];
            } failure:^(NSString *error) {
                [LCProgressHUD showFailure:error];
            }];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    }
}

#pragma mark ------ Event Responds ------
/**
 确定
 */
- (void)respondsToSureButton {
    [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.inputPasswordPromptView animationShow];
    });
}

#pragma mark ------ Getters And Setters ------
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = FONT(30);
        _numberLabel.text = [NSString stringWithFormat:@"%.4lf", self.transferNumber.doubleValue];
        _numberLabel.textColor = COLORFROM16(0x008D55, 1);
    }
    return _numberLabel;
}
- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = FONT(8);
        _unitLabel.text = [NSString stringWithFormat:@"（%@）", self.tokenModel.flag];
        _unitLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _unitLabel;
}
- (UILabel *)poundageLabel {
    if (!_poundageLabel) {
        _poundageLabel = [[UILabel alloc] init];
        _poundageLabel.font = FONT(11);
        
        if (self.neoWalletModel.categoryId == 1) { //eth
             _poundageLabel.text = [NSString stringWithFormat:@"%@：%.8lf", DBHGetStringWithKeyFromTable(@"Fees", nil), self.poundage.doubleValue];
        } else {
            if ([self.tokenModel.flag isEqualToString:NEO] || [self.tokenModel.flag isEqualToString:GAS]) {
                _poundageLabel.text = [NSString stringWithFormat:@"%@：%.4lf", DBHGetStringWithKeyFromTable(@"Fees", nil), self.poundage.doubleValue];
            } else {
                 _poundageLabel.text = [NSString stringWithFormat:@"%@：%lf Gas", DBHGetStringWithKeyFromTable(@"Fees", nil), self.realityPoundage.doubleValue];
            }
        }
        
        _poundageLabel.textColor = COLORFROM16(0xF85803, 1);
    }
    return _poundageLabel;
}
- (UILabel *)originalPoundageLabel {
    if (!_originalPoundageLabel) {
        _originalPoundageLabel = [[UILabel alloc] init];
        _originalPoundageLabel.font = FONT(9);
        
        BOOL isNeoDB = NO;
        if (self.neoWalletModel.categoryId == 2 && ![self.tokenModel.flag isEqualToString:NEO] && ![self.tokenModel.flag isEqualToString:GAS] ) {
            isNeoDB = YES;
        }
        _originalPoundageLabel.hidden = !isNeoDB;
        _originalPoundageLabel.text = [NSString stringWithFormat:@"（%@：%lf Gas）", DBHGetStringWithKeyFromTable(@"Original Fees", nil), self.poundage.doubleValue];
        _originalPoundageLabel.textColor = COLORFROM16(0xD5D5D5, 1);
    }
    return _originalPoundageLabel;
}
- (UILabel *)collectionAddressLabel {
    if (!_collectionAddressLabel) {
        _collectionAddressLabel = [[UILabel alloc] init];
        _collectionAddressLabel.font = FONT(13);
        _collectionAddressLabel.text = DBHGetStringWithKeyFromTable(@"To:", nil);
        _collectionAddressLabel.textColor = COLORFROM16(0x8A8A8A, 1);
    }
    return _collectionAddressLabel;
}
- (UILabel *)collectionAddressValueLabel {
    if (!_collectionAddressValueLabel) {
        _collectionAddressValueLabel = [[UILabel alloc] init];
        _collectionAddressValueLabel.font = FONT(13);
        _collectionAddressValueLabel.text = self.address;
        _collectionAddressValueLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _collectionAddressValueLabel;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xEAEAEA, 1);
    }
    return _grayLineView;
}
- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font = FONT(13);
        _remarkLabel.text = DBHGetStringWithKeyFromTable(@"Memo", nil);
        _remarkLabel.textColor = COLORFROM16(0x8A8A8A, 1);
    }
    return _remarkLabel;
}
- (UILabel *)remarkValueLabel {
    if (!_remarkValueLabel) {
        _remarkValueLabel = [[UILabel alloc] init];
        _remarkValueLabel.font = FONT(13);
        _remarkValueLabel.text = self.remark;
        _remarkValueLabel.textColor = COLORFROM16(0x3D3D3D, 1);
        _remarkValueLabel.numberOfLines = 0;
    }
    return _remarkValueLabel;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = MAIN_ORANGE_COLOR;
        _sureButton.titleLabel.font = FONT(14);
        [_sureButton setTitle:DBHGetStringWithKeyFromTable(@"Confirm", nil) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"In the validation...", nil)];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               if (weakSelf.neoWalletModel.categoryId == 2) { //neo gas 代币
                                   [weakSelf getUnspentWithPassword:password];
                               } else { // eth 代币
                                   [weakSelf transferAccountsForETHWithPassword:password];
                               }
                           });
        }];
    }
    return _inputPasswordPromptView;
}

@end
