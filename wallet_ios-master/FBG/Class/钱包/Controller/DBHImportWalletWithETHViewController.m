//
//  DBHImportWalletWithETHViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHImportWalletWithETHViewController.h"

#import "ScanVC.h"
#import "DBHCreateWalletWithETHViewController.h"
#import "DBHCreateWalletWithNameViewController.h"
#import "DBHWalletDetailWithETHViewController.h"

#import "DBHInputPasswordPromptView.h"

#import "DBHWalletManagerForNeoModelList.h"
#import "DBHWalletManagerForNeoModelCategory.h"
#import "DBHInputPasswordNamePromptView.h"

@interface DBHImportWalletWithETHViewController ()<UITextViewDelegate, ScanVCDelegate>

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIButton *scanQRCodeButton;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIButton *importButton;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;
@property (nonatomic, strong) DBHInputPasswordNamePromptView *inputPasswordNamePromptView;

@property (nonatomic, strong) EthmobileWallet *ethWallet;
@property (nonatomic, assign) NSInteger currentSelectedIndex; // 当前选中下标
@property (nonatomic, copy) NSArray *placeHolderArray;
@property (nonatomic, strong) NSMutableArray *typeArray;

@property (nonatomic, copy) NSString *keystoneStr;
@property (nonatomic, copy) NSString *zhujiStr;
@property (nonatomic, copy) NSString *siyaoStr;
@property (nonatomic, copy) NSString *watchStr;

@end

@implementation DBHImportWalletWithETHViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = DBHGetStringWithKeyFromTable(self.isTransform ? @"Convert to Hot Wallet" : @"Import Wallet", nil);
    
    if (self.isTransform) {
        [self.typeArray removeLastObject];
    }
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.bottomLineView];
    [self.view addSubview:self.scanQRCodeButton];
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.placeHolderLabel];
    [self.view addSubview:self.importButton];
    
    WEAKSELF
    [self.scanQRCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(57));
        make.height.offset(AUTOLAYOUTSIZE(34));
        make.right.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(15));
    }];
    [self.contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(39));
        make.height.offset(AUTOLAYOUTSIZE(298));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.scanQRCodeButton.mas_bottom).offset(AUTOLAYOUTSIZE(15));
    }];
    [self.placeHolderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentTextView).offset(AUTOLAYOUTSIZE(7));
        make.right.equalTo(weakSelf.contentTextView).offset(- AUTOLAYOUTSIZE(7));
        make.top.equalTo(weakSelf.contentTextView).offset(AUTOLAYOUTSIZE(9));
    }];
    [self.importButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(45.5));
    }];
    
    for (NSInteger i = 0; i < self.typeArray.count; i++) {
        UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.tag = 200 + i;
        typeButton.titleLabel.font = FONT(12);
        typeButton.selected = self.currentSelectedIndex == i;
        [typeButton setTitle:DBHGetStringWithKeyFromTable(self.typeArray[i], nil) forState:UIControlStateNormal];
        [typeButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [typeButton setTitleColor:COLORFROM16(0x0A9234, 1) forState:UIControlStateSelected];
        [typeButton addTarget:self action:@selector(respondsToTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:typeButton];
        
        [typeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.offset([NSString getWidthtWithString:DBHGetStringWithKeyFromTable(self.typeArray[i], nil) fontSize:12]);
            make.height.offset(AUTOLAYOUTSIZE(30));
            make.left.equalTo(!i ? weakSelf.contentTextView : [weakSelf.view viewWithTag:199 + i].mas_right).offset(!i ? 0 : AUTOLAYOUTSIZE(15));
            make.centerY.equalTo(weakSelf.scanQRCodeButton);
        }];
    }
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(13.5));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.centerX.equalTo([weakSelf.view viewWithTag:200]);
        make.bottom.equalTo([weakSelf.view viewWithTag:200]);
    }];
}

#pragma mark ------ UITextViewDelegate ------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *changeAfterString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    switch (self.currentSelectedIndex) {
        case 0:
            self.keystoneStr = changeAfterString;
            break;
        case 1:
            self.zhujiStr = changeAfterString;
            break;
        case 2:
            self.siyaoStr = changeAfterString;
            break;
        case 3:
            self.watchStr = changeAfterString;
            break;
        default:
            break;
    }
    
    self.placeHolderLabel.hidden = changeAfterString.length;
    
    return YES;
}

#pragma mark ------ ScanVCDelegate ------
- (void)scanSucessWithObject:(id)object
{
    //扫一扫回调
    NSString *string = object;
    if (!self.currentSelectedIndex && (![[string substringToIndex:1] isEqualToString:@"{"] || ![[object substringFromIndex:string.length - 1] isEqualToString:@"}"])) {
        [LCProgressHUD showFailure:@"请输入正确的KeyStore"];
        
        return;
    }
    
    self.contentTextView.text = [NSString stringWithFormat:@"%@", object];
    self.placeHolderLabel.hidden = self.contentTextView.text.length;
}

#pragma mark ------ Event Responds ------
/**
 扫描二维码
 */
- (void)respondsToScanQRCodeButton {
    ScanVC * vc = [[ScanVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 导入
 */
- (void)respondsToImportButton {
    if (!self.contentTextView.text.length) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"The input cannot be empty", nil)];
        return;
    }
    
    WEAKSELF
    self.inputPasswordPromptView.inputPsdType = self.currentSelectedIndex;
    self.inputPasswordNamePromptView.inputPsdType = self.currentSelectedIndex;
    switch (self.currentSelectedIndex) {
        case 0: {
            // Keystore
            if (self.ethWalletModel) {
                [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordNamePromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.inputPasswordNamePromptView animationShow];
                });
            } else {
                [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.inputPasswordPromptView animationShow];
                });
            }
            break;
        }
        case 1: {
            // 助记词
            
            if (self.ethWalletModel) {
                [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordNamePromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.inputPasswordNamePromptView animationShow];
                });
            } else {
                [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.inputPasswordPromptView animationShow];
                });
            }
            /**
            [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"In the validation...", nil)];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               self.ethWallet = EthmobileFromMnemonic(self.contentTextView.text, [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh_CN" : @"en_US", &error);
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      
                                                      //                                                      //创建成功
                                                      if (self.ethWalletModel)
                                                      {
                                                          //观察钱包升级 助记词
                                                          if ([[self.ethWallet address] isEqualToString:self.ethWalletModel.address])
                                                          {
                                                              DBHCreateWalletWithETHViewController *createWalletWithETHViewController = [[DBHCreateWalletWithETHViewController alloc] init];
//                                                              createWalletWithETHViewController.ethWalletModel = self.ethWalletModel;
                                                              createWalletWithETHViewController.ethWallet = self.ethWallet;
                                                              [self.navigationController pushViewController:createWalletWithETHViewController animated:YES];
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Incorrect wallet address, please confirm and try again", nil)];
                                                          }
                                                      }
                                                      else
                                                      {
                                                          DBHCreateWalletWithETHViewController *createWalletWithETHViewController = [[DBHCreateWalletWithETHViewController alloc] init];
                                                          createWalletWithETHViewController.ethWallet = self.ethWallet;
                                                          [self.navigationController pushViewController:createWalletWithETHViewController animated:YES];
                                                      }
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Failed to import wallet", nil)];
                                                  }
                                              });
                               
                           });*/
            
            break;
        }
        case 2: {
            // 私钥
            
            if (self.ethWalletModel) {
                [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordNamePromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.inputPasswordNamePromptView animationShow];
                });
            } else {
                [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.inputPasswordPromptView animationShow];
                });
            }
            /**
            [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"In the validation...", nil)];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^
                           {
                               //子线程异步执行下载任务，防止主线程卡顿
                               NSError * error;
                               self.ethWallet = EthmobileFromPrivateKey(self.contentTextView.text, &error);
                               
                               dispatch_queue_t mainQueue = dispatch_get_main_queue();
                               //异步返回主线程，根据获取的数据，更新UI
                               dispatch_async(mainQueue, ^
                                              {
                                                  if (!error)
                                                  {
                                                      [LCProgressHUD hide];
                                                      //创建成功
                                                      if (self.ethWalletModel)
                                                      {
                                                          //观察钱包升级 私钥
                                                          if ([[self.ethWallet address] isEqualToString:self.ethWalletModel.address])
                                                          {
                                                              DBHCreateWalletWithETHViewController *createWalletWithETHViewController = [[DBHCreateWalletWithETHViewController alloc] init];
//                                                              createWalletWithETHViewController.ethWalletModel = self.ethWalletModel;
                                                              createWalletWithETHViewController.ethWallet = self.ethWallet;
                                                              [self.navigationController pushViewController:createWalletWithETHViewController animated:YES];
                                                          }
                                                          else
                                                          {
                                                              [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Incorrect wallet address, please confirm and try again", nil)];
                                                          }
                                                      }
                                                      else
                                                      {
                                                          DBHCreateWalletWithETHViewController *createWalletWithETHViewController = [[DBHCreateWalletWithETHViewController alloc] init];
                                                          createWalletWithETHViewController.ethWallet = self.ethWallet;
                                                          [self.navigationController pushViewController:createWalletWithETHViewController animated:YES];
                                                      }
                                                  }
                                                  else
                                                  {
                                                      [LCProgressHUD hide];
                                                      [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Failed to import wallet", nil)];
                                                  }
                                              });
                               
                           });*/
            
            break;
        }
        case 3: {
            // 观察
            if ([NSString isAdress:[self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
            {
                //创建成功
                DBHCreateWalletWithNameViewController *createWalletWithNameViewController = [[DBHCreateWalletWithNameViewController alloc] init];
                createWalletWithNameViewController.walletType = 1;
                createWalletWithNameViewController.from = (int)self.currentSelectedIndex;
                createWalletWithNameViewController.address = [self.contentTextView.text
                                                              stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [self.navigationController pushViewController:createWalletWithNameViewController animated:YES];
            }
            else
            {
                [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter the correct wallet address", nil)];
            }
            
            break;
        }
            
        default:
            break;
    }
}
/**
 类型选择
 */
- (void)respondsToTypeButton:(UIButton *)sender {
    if (sender.tag - 200 == self.currentSelectedIndex) {
        return;
    }
    
    if (self.ethWalletModel && sender.tag - 200 == 3) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"It is already a monitoring wallet", nil)];
        return;
    }
    
    UIButton *lastSelectedButton = [self.view viewWithTag:self.currentSelectedIndex + 200];
    lastSelectedButton.selected = NO;
    
    sender.selected = YES;
    self.currentSelectedIndex = sender.tag - 200;
    switch (self.currentSelectedIndex) {
        case 0:
            self.contentTextView.text = self.keystoneStr;
            break;
        case 1:
            self.contentTextView.text = self.zhujiStr;
            break;
        case 2:
            self.contentTextView.text = self.siyaoStr;
            break;
        case 3:
            self.contentTextView.text = self.watchStr;
            break;
        default:
            break;
    }
    
    self.placeHolderLabel.hidden = self.contentTextView.text.length;
    
    self.placeHolderLabel.text = DBHGetStringWithKeyFromTable(self.placeHolderArray[sender.tag - 200], nil);
    
    WEAKSELF
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(13.5));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.centerX.equalTo(sender);
        make.bottom.equalTo([weakSelf.view viewWithTag:200]);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

#pragma mark ------ Getters And Setters ------
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0x0A9234, 1);
    }
    return _bottomLineView;
}
- (UIButton *)scanQRCodeButton {
    if (!_scanQRCodeButton) {
        _scanQRCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanQRCodeButton setImage:[UIImage imageNamed:@"身份证扫描"] forState:UIControlStateNormal];
        [_scanQRCodeButton addTarget:self action:@selector(respondsToScanQRCodeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanQRCodeButton;
}
- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
        _contentTextView.delegate = self;
        _contentTextView.font = FONT(12);
        _contentTextView.textColor = COLORFROM16(0x333333, 1);
    }
    return _contentTextView;
}
- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.font = FONT(12);
        _placeHolderLabel.text = DBHGetStringWithKeyFromTable(self.placeHolderArray.firstObject, nil);
        _placeHolderLabel.textColor = COLORFROM16(0xCFCFCF, 1);
        _placeHolderLabel.numberOfLines = 0;
    }
    return _placeHolderLabel;
}
- (UIButton *)importButton {
    if (!_importButton) {
        _importButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _importButton.backgroundColor = MAIN_ORANGE_COLOR;
        _importButton.titleLabel.font = BOLDFONT(14);
        _importButton.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        [_importButton setTitle:DBHGetStringWithKeyFromTable(@"Start Import", nil) forState:UIControlStateNormal];
        [_importButton addTarget:self action:@selector(respondsToImportButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importButton;
}
- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            NSString *data = self.contentTextView.text;
            [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"In the validation...", nil)];
            NSInteger type = weakSelf.inputPasswordPromptView.inputPsdType;
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^ {
                //子线程异步执行下载任务，防止主线程卡顿
                NSError * error;
                switch (type) {
                    case 0: { // keyStore
                        weakSelf.ethWallet = EthmobileFromKeyStore(data, password, &error);
                    }
                        break;
                    case 1: { // 助记词
                        weakSelf.ethWallet = EthmobileFromMnemonic(data, [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh_CN" : @"en_US", &error);
                    }
                        break;
                    case 2: { // 私钥
                        @try {
                           const char *bytes = [data UTF8String];
                            weakSelf.ethWallet = EthmobileFromPrivateKey([[NSData alloc] initWithBytes:bytes length:sizeof(bytes)], &error);
                        } @catch (NSException *exception) {
                            NSLog(@"@exception");
                        } @finally {
                            NSLog(@"@finally");
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LCProgressHUD hide];
                    if (!error) { //创建成功
                        if (weakSelf.ethWalletModel) { // 转化钱包
                            if ([[weakSelf.ethWallet address] isEqualToString:weakSelf.ethWalletModel.address]) {
                                if (weakSelf.inputPasswordPromptView.inputPsdType == 0) { // 通过keystore转化钱包
                                    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Successfully converted", nil)];
                                    [PDKeyChain save:KEYCHAIN_KEY([weakSelf.ethWalletModel address]) data:data];
                                    DBHWalletDetailWithETHViewController *walletDetailViewController = [[DBHWalletDetailWithETHViewController alloc] init];
                                    weakSelf.ethWalletModel.isLookWallet = NO;
                                    walletDetailViewController.ethWalletModel = weakSelf.ethWalletModel;
                                    walletDetailViewController.backIndex = (weakSelf.navigationController.viewControllers.count == 4) ? 2 : 1;
                                    [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
                                } else { // 助记词 私钥
                                    NSError *error;
                                    NSString *data = [weakSelf.ethWallet toKeyStore:password error:&error];
                                    NSString * address = weakSelf.ethWallet.address;
                                    [PDKeyChain save:KEYCHAIN_KEY(address) data:data];
                                    
                                    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Successfully converted", nil)];
                                    NSArray *arr = self.navigationController.viewControllers;
                                    if (arr.count >= 2) {
                                        if ([arr[arr.count - 2] isKindOfClass:[DBHWalletDetailWithETHViewController class]]) {
                                            DBHWalletDetailWithETHViewController *walletDetailViewController = (DBHWalletDetailWithETHViewController *)arr[arr.count - 2];
                                            
                                            weakSelf.ethWalletModel.isLookWallet = NO;
                                            walletDetailViewController.ethWalletModel = weakSelf.ethWalletModel;
                                            walletDetailViewController.backIndex = (weakSelf.navigationController.viewControllers.count == 4) ? 2 : 1;
                                            [weakSelf.navigationController popToViewController:walletDetailViewController animated:YES];
                                        }
                                    } else {
                                        DBHWalletDetailWithETHViewController *walletDetailViewController = [[DBHWalletDetailWithETHViewController alloc] init];
                                        
                                        
                                        weakSelf.ethWalletModel.isLookWallet = NO;
                                        walletDetailViewController.ethWalletModel = weakSelf.ethWalletModel;
                                        walletDetailViewController.backIndex = (weakSelf.navigationController.viewControllers.count == 4) ? 2 : 1;
                                        [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
                                    }
                                    
                                }
                            } else {
                                [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Incorrect wallet address, please confirm and try again", nil)];
                            }
                        } else { // 导入钱包
                            if (weakSelf.inputPasswordPromptView.inputPsdType == 0) { // 通过keystore转化钱包
                                DBHCreateWalletWithNameViewController *createWalletWithNameViewController = [[DBHCreateWalletWithNameViewController alloc] init];
                                createWalletWithNameViewController.from = (int)weakSelf.inputPasswordPromptView.inputPsdType;
                                createWalletWithNameViewController.walletType = 1;
                                createWalletWithNameViewController.address = weakSelf.ethWallet.address;
                                createWalletWithNameViewController.password = password;
                                [PDKeyChain save:KEYCHAIN_KEY([weakSelf.ethWallet address]) data:data];
                                [weakSelf.navigationController pushViewController:createWalletWithNameViewController animated:YES];
                                
                            } else { // 助记词 私钥
                                DBHCreateWalletWithNameViewController *createWalletWithNameViewController = [[DBHCreateWalletWithNameViewController alloc] init];
                                createWalletWithNameViewController.from = (int)weakSelf.inputPasswordPromptView.inputPsdType;
                                createWalletWithNameViewController.walletType = 1;
                                createWalletWithNameViewController.address = weakSelf.ethWallet.address;
                                createWalletWithNameViewController.ethWallet = weakSelf.ethWallet;
                                createWalletWithNameViewController.password = password;
                                [weakSelf.navigationController pushViewController:createWalletWithNameViewController animated:YES];
                            }
                            
                        }
                    } else {
                        if (weakSelf.inputPasswordPromptView.inputPsdType == 0) { // 通过keystore转化钱包
                            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Incorrect password", nil)];
                        } else {
                            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Failed to import wallet", nil)];
                        }
                    }
                });
            });
        }];
    }
    return _inputPasswordPromptView;
}

- (DBHInputPasswordNamePromptView *)inputPasswordNamePromptView {
    if (!_inputPasswordNamePromptView) {
        _inputPasswordNamePromptView = [[DBHInputPasswordNamePromptView alloc] init];
        WEAKSELF
        [_inputPasswordNamePromptView commitBlock:^(NSString *password) {
                NSString *data = self.contentTextView.text;
                NSInteger type = weakSelf.inputPasswordNamePromptView.inputPsdType;
                [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"In the validation...", nil)];
                dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(globalQueue, ^ {
                    //子线程异步执行下载任务，防止主线程卡顿
                    NSError * error;
                    switch (type) {
                        case 0: { // keyStore
                            weakSelf.ethWallet = EthmobileFromKeyStore(data, password, &error);
                        }
                            break;
                        case 1: { // 助记词
                            weakSelf.ethWallet = EthmobileFromMnemonic(data, [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh_CN" : @"en_US", &error);
                        }
                            break;
                        case 2: { // 私钥
                            const char *bytes = [data UTF8String];
                            weakSelf.ethWallet = EthmobileFromPrivateKey([[NSData alloc] initWithBytes:bytes length:sizeof(bytes)], &error);
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [LCProgressHUD hide];
                        if (!error) { //创建成功
                            if (weakSelf.ethWalletModel) { // 转化钱包
                                if ([[weakSelf.ethWallet address] isEqualToString:weakSelf.ethWalletModel.address]) {
                                    if (weakSelf.inputPasswordPromptView.inputPsdType == 0) { // 通过keystore转化钱包
                                        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Successfully converted", nil)];
                                        [PDKeyChain save:KEYCHAIN_KEY([weakSelf.ethWalletModel address]) data:data];
                                        DBHWalletDetailWithETHViewController *walletDetailViewController = [[DBHWalletDetailWithETHViewController alloc] init];
                                        weakSelf.ethWalletModel.isLookWallet = NO;
                                        walletDetailViewController.ethWalletModel = weakSelf.ethWalletModel;
                                        walletDetailViewController.backIndex = (weakSelf.navigationController.viewControllers.count == 4) ? 2 : 1;
                                        [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
                                    } else { // 助记词 私钥
                                        NSError *error;
                                        NSString *data = [weakSelf.ethWallet toKeyStore:password error:&error];
                                        NSString * address = weakSelf.ethWallet.address;
                                        [PDKeyChain save:KEYCHAIN_KEY(address) data:data];
                                        
                                        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Successfully converted", nil)];
                                        NSArray *arr = self.navigationController.viewControllers;
                                        if (arr.count >= 2) {
                                            if ([arr[arr.count - 2] isKindOfClass:[DBHWalletDetailWithETHViewController class]]) {
                                                DBHWalletDetailWithETHViewController *walletDetailViewController = (DBHWalletDetailWithETHViewController *)arr[arr.count - 2];
                                                
                                                weakSelf.ethWalletModel.isLookWallet = NO;
                                                walletDetailViewController.ethWalletModel = weakSelf.ethWalletModel;
                                                walletDetailViewController.backIndex = (weakSelf.navigationController.viewControllers.count == 4) ? 2 : 1;
                                                [weakSelf.navigationController popToViewController:walletDetailViewController animated:YES];
                                            }
                                        } else {
                                            DBHWalletDetailWithETHViewController *walletDetailViewController = [[DBHWalletDetailWithETHViewController alloc] init];
                                            
                                            
                                            weakSelf.ethWalletModel.isLookWallet = NO;
                                            walletDetailViewController.ethWalletModel = weakSelf.ethWalletModel;
                                            walletDetailViewController.backIndex = 2;
                                            [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
                                        }
                                        
                                    }
                                } else {
                                    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Incorrect wallet address, please confirm and try again", nil)];
                                }
                            } else { // 导入钱包
                                if (weakSelf.inputPasswordPromptView.inputPsdType == 0) { // 通过keystore转化钱包
                                    DBHCreateWalletWithNameViewController *createWalletWithNameViewController = [[DBHCreateWalletWithNameViewController alloc] init];
                                    createWalletWithNameViewController.from = (int)weakSelf.inputPasswordPromptView.inputPsdType;
                                    createWalletWithNameViewController.walletType = 1;
                                    createWalletWithNameViewController.address = weakSelf.ethWallet.address;
                                    createWalletWithNameViewController.password = password;
                                    [PDKeyChain save:KEYCHAIN_KEY([weakSelf.ethWallet address]) data:data];
                                    [weakSelf.navigationController pushViewController:createWalletWithNameViewController animated:YES];
                                    
                                } else { // 助记词 私钥
                                    DBHCreateWalletWithNameViewController *createWalletWithNameViewController = [[DBHCreateWalletWithNameViewController alloc] init];
                                    createWalletWithNameViewController.from = (int)weakSelf.inputPasswordPromptView.inputPsdType;
                                    createWalletWithNameViewController.walletType = 1;
                                    createWalletWithNameViewController.address = weakSelf.ethWallet.address;
                                    createWalletWithNameViewController.ethWallet = weakSelf.ethWallet;
                                    createWalletWithNameViewController.password = password;
                                    [weakSelf.navigationController pushViewController:createWalletWithNameViewController animated:YES];
                                }
                                
                            }
                        } else {
                            if (weakSelf.inputPasswordPromptView.inputPsdType == 0) { // 通过keystore转化钱包
                                [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Incorrect password", nil)];
                            } else {
                                [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Failed to import wallet", nil)];
                            }
                        }
                    });
                });
            }];
        }
         
    
    if (self.ethWalletModel) {
        _inputPasswordNamePromptView.name = self.ethWalletModel.name;
    }
    return _inputPasswordNamePromptView;
}
- (NSArray *)placeHolderArray {
    if (!_placeHolderArray) {
        _placeHolderArray = @[@"Copy and paste the content of the keystore file, or using the scanner at the right comer for the QR code",
                              @"Please use space to separate the mnemonic words",
                              @"Please input your private key",
                              @"Watch Wallet needs your wallet address only,serving as a way to manage and trade as a regular account, For security reasons, Cold Wallets among the others are recommended for large amount of assets."];
    }
    return _placeHolderArray;
}
- (NSMutableArray *)typeArray {
    if (!_typeArray) {
        _typeArray = [@[@"Keystore",
                       @"Mnemonic",
                       @"Private Key",
                       @"Watch2"] mutableCopy];
    }
    return _typeArray;
}

@end
