
//
//  DBHTransferWithETHViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTransferWithETHViewController.h"

#import "ScanVC.h"
#import "DBHTransferConfirmationViewController.h"
#import "DBHAddressBookViewController.h"

#import "DBHWalletManagerForNeoModelList.h"
#import "DBHWalletDetailTokenInfomationModelData.h"

@interface DBHTransferWithETHViewController ()<ScanVCDelegate>

@property (nonatomic, strong) UILabel *walletAddressLabel;
@property (nonatomic, strong) UITextField *walletAddressTextField;
@property (nonatomic, strong) UIButton *phoneBookButton;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UILabel *transferNumberLabel;
@property (nonatomic, strong) UITextField *transferNumberTextField;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UILabel *gasLabel;
@property (nonatomic, strong) UILabel *gasValueLabel;
@property (nonatomic, strong) UILabel *slowLabel;
@property (nonatomic, strong) UISlider *gasSlider;
@property (nonatomic, strong) UILabel *fastLabel;
@property (nonatomic, strong) UITextField *remarkTextField;
@property (nonatomic, strong) UIView *thirdLineView;
@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, copy) NSString *defaultGas;
@property (nonatomic, copy) NSString *nonce; // 交易次数

@end

@implementation DBHTransferWithETHViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Transfer", nil);
    
    [self setUI];
    
    [self getDefaultGas];
    [self loadWalletData];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"身份证扫描"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToScanQrCodeBarButtonItem)];
    
    [self.view addSubview:self.walletAddressLabel];
    [self.view addSubview:self.walletAddressTextField];
    [self.view addSubview:self.phoneBookButton];
    [self.view addSubview:self.firstLineView];
    [self.view addSubview:self.transferNumberLabel];
    [self.view addSubview:self.transferNumberTextField];
    [self.view addSubview:self.secondLineView];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.gasLabel];
    [self.view addSubview:self.gasValueLabel];
    [self.view addSubview:self.slowLabel];
    [self.view addSubview:self.gasSlider];
    [self.view addSubview:self.fastLabel];
    [self.view addSubview:self.remarkLabel];
    [self.view addSubview:self.remarkTextField];
    [self.view addSubview:self.thirdLineView];
    [self.view addSubview:self.commitButton];
    
    WEAKSELF
    [self.walletAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.walletAddressTextField);
        make.bottom.equalTo(weakSelf.walletAddressTextField.mas_top);
    }];
    [self.walletAddressTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.firstLineView);
        make.right.equalTo(weakSelf.phoneBookButton.mas_left);
        make.height.offset(AUTOLAYOUTSIZE(40));
        make.bottom.equalTo(weakSelf.firstLineView.mas_top);
    }];
    [self.phoneBookButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(36));
        make.right.equalTo(weakSelf.firstLineView);
        make.centerY.equalTo(weakSelf.walletAddressTextField);
    }];
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(57));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(85));
    }];
    [self.transferNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.transferNumberTextField);
        make.bottom.equalTo(weakSelf.transferNumberTextField.mas_top);
    }];
    [self.transferNumberTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.firstLineView);
        make.height.offset(AUTOLAYOUTSIZE(40));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.secondLineView.mas_top);
    }];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firstLineView);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.firstLineView.mas_bottom).offset(AUTOLAYOUTSIZE(85));
    }];
    [self.balanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.secondLineView);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom).offset(AUTOLAYOUTSIZE(5.5));
    }];
    [self.gasLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.transferNumberLabel);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom).offset(AUTOLAYOUTSIZE(63));
    }];
    [self.gasValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.firstLineView);
        make.centerY.equalTo(weakSelf.gasLabel);
    }];
    [self.slowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.transferNumberLabel);
        make.top.equalTo(weakSelf.gasLabel.mas_bottom).offset(AUTOLAYOUTSIZE(27));
    }];
    [self.gasSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(101));
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.slowLabel);
    }];
    [self.fastLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.firstLineView);
        make.centerY.equalTo(weakSelf.slowLabel);
    }];
    [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.firstLineView);
        make.bottom.equalTo(weakSelf.remarkTextField.mas_top);
    }];
    [self.remarkTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.transferNumberTextField);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.thirdLineView.mas_top);
    }];
    [self.thirdLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firstLineView);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom).offset(AUTOLAYOUTSIZE(232));
    }];
    [self.commitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(47.5));
    }];
}

#pragma mark ------ MailListDelegate ------
/**
 通讯录获取代理
 */
- (void)choasePersonWithData:(id)data {
    //    MailMdel *model = data;
    //    self.walletAddressTextField.text = model.address;
}

#pragma mark ------ ScanVCDelegate ------
/**
 扫一扫成功代理
 */
- (void)scanSucessWithObject:(id)object {
    if (![NSString isAdress:[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter the correct wallet address", nil)];
        return;
    }
    
    self.walletAddressTextField.text = object;
}

#pragma mark ------ Data ------
/**
 获取默认Gas费用
 */
- (void)getDefaultGas {
    WEAKSELF
    [PPNetworkHelper GET:@"extend/getGasPrice" baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        NSString *defautlGas = [NSString stringWithFormat:@"%@", responseCache[@"gasPrice"]];
        defautlGas = [NSString numberHexString:defautlGas];
        defautlGas = [NSString DecimalFuncWithOperatorType:2 first:defautlGas secend:@"90000" value:8];
        weakSelf.defaultGas = [NSString DecimalFuncWithOperatorType:3 first:defautlGas secend:@"1000000000000000000" value:8];
        if (weakSelf.defaultGas.doubleValue < weakSelf.gasSlider.minimumValue) {
            weakSelf.gasValueLabel.text = [NSString stringWithFormat:@"%.8lf", weakSelf.gasSlider.minimumValue];
            weakSelf.gasSlider.value = weakSelf.gasSlider.minimumValue;
        } else if (weakSelf.defaultGas.doubleValue > weakSelf.gasSlider.maximumValue) {
            weakSelf.gasValueLabel.text = [NSString stringWithFormat:@"%.8lf", weakSelf.gasSlider.maximumValue];
            weakSelf.gasSlider.value = weakSelf.gasSlider.maximumValue;
        } else {
            weakSelf.gasValueLabel.text = [NSString stringWithFormat:@"%.8lf", weakSelf.defaultGas.doubleValue];
            weakSelf.gasSlider.value = weakSelf.defaultGas.doubleValue;
        }
    } success:^(id responseObject) {
        NSString *defautlGas = [NSString stringWithFormat:@"%@", responseObject[@"gasPrice"]];
        defautlGas = [NSString numberHexString:defautlGas];
        defautlGas = [NSString DecimalFuncWithOperatorType:2 first:defautlGas secend:@"90000" value:8];
        weakSelf.defaultGas = [NSString DecimalFuncWithOperatorType:3 first:defautlGas secend:@"1000000000000000000" value:8];
        if (weakSelf.defaultGas.doubleValue < weakSelf.gasSlider.minimumValue) {
            weakSelf.gasValueLabel.text = [NSString stringWithFormat:@"%.8lf", weakSelf.gasSlider.minimumValue];
            weakSelf.gasSlider.value = weakSelf.gasSlider.minimumValue;
        } else if (weakSelf.defaultGas.doubleValue > weakSelf.gasSlider.maximumValue) {
            weakSelf.gasValueLabel.text = [NSString stringWithFormat:@"%.8lf", weakSelf.gasSlider.maximumValue];
            weakSelf.gasSlider.value = weakSelf.gasSlider.maximumValue;
        } else {
            weakSelf.gasValueLabel.text = [NSString stringWithFormat:@"%.8lf", weakSelf.defaultGas.doubleValue];
            weakSelf.gasSlider.value = weakSelf.defaultGas.doubleValue;
        }
    } failure:^(NSString *error) {
        
    } specialBlock:nil];
}
- (void)loadWalletData {
    //获取交易次数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.tokenModel.address forKey:@"address"];
    
    [PPNetworkHelper POST:@"extend/getTransactionCount" baseUrlType:1 parameters:dic hudString:nil success:^(id responseObject)
     {
         // nonce 参数
         if (![NSString isNulllWithObject:[responseObject objectForKey:@"count"]])
         {
             self.nonce = [responseObject objectForKey:@"count"];
         }
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

#pragma mark ------ Event Responds ------
/**
 扫描二维码
 */
- (void)respondsToScanQrCodeBarButtonItem {
    ScanVC * vc = [[ScanVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 电话薄
 */
- (void)respondsToPhoneBookButton {
    DBHAddressBookViewController *addressBookViewController = [[DBHAddressBookViewController alloc] init];
    addressBookViewController.isSelected = YES;
    
    WEAKSELF
    [addressBookViewController selectedAddressBlock:^(NSString *address) {
        weakSelf.walletAddressTextField.text = address;
    }];
    
    [self.navigationController pushViewController:addressBookViewController animated:YES];
}
/**
 提交
 */
- (void)respondsToCommitButton {
    if (![NSString isAdress:[self.walletAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
    {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter the correct wallet address", nil)];
        return;
    }
    if (self.nonce.length == 0)
    {
        [LCProgressHUD showMessage:@"暂未获取到交易次数。请稍后再试"];
        return;
    }
    if (self.transferNumberTextField.text.doubleValue == 0)
    {
        [LCProgressHUD showMessage:@"请输入价格"];
        return;
    }
    if (self.tokenModel.balance.doubleValue < self.transferNumberTextField.text.doubleValue)
    {
        [LCProgressHUD showMessage:@"钱包余额不足"];
        return;
    }
    
    NSString *numberStr = [NSString stringWithFormat:@"%@", @(self.transferNumberTextField.text.doubleValue)];
    
    DBHTransferConfirmationViewController *transferConfirmationViewController = [[DBHTransferConfirmationViewController alloc] init];
    transferConfirmationViewController.tokenModel = self.tokenModel;
    transferConfirmationViewController.neoWalletModel = self.neoWalletModel;
    transferConfirmationViewController.transferNumber = numberStr;
    transferConfirmationViewController.poundage = [NSString stringWithFormat:@"%lf", self.gasSlider.value];
    transferConfirmationViewController.address = self.walletAddressTextField.text;
    transferConfirmationViewController.remark = self.remarkTextField.text;
    transferConfirmationViewController.nonce = self.nonce;
    [self.navigationController pushViewController:transferConfirmationViewController animated:YES];
}
- (void)respondsToGasSlider {
    self.gasValueLabel.text = [NSString stringWithFormat:@"%.8lf", self.gasSlider.value];
}

#pragma mark ------ Getters And Setters ------
- (void)setTokenModel:(DBHWalletDetailTokenInfomationModelData *)tokenModel {
    _tokenModel = tokenModel;
    
    NSString *minValue = [NSString DecimalFuncWithOperatorType:2 first:@"25200000000000" secend:[_tokenModel.flag isEqualToString:@"ETH"] ? @"90000" : _tokenModel.gas value:8];
    minValue = [NSString DecimalFuncWithOperatorType:3 first:minValue secend:@"21000" value:8];
    minValue = [NSString DecimalFuncWithOperatorType:3 first:minValue secend:@"1000000000000000000" value:8];
    
    NSString *maxValue = [NSString DecimalFuncWithOperatorType:2 first:@"2520120000000000" secend:[_tokenModel.flag isEqualToString:@"ETH"] ? @"90000" : _tokenModel.gas value:8];
    maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"21000"  value:8];
    maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"1000000000000000000" value:8];
    
    self.gasValueLabel.text = [NSString stringWithFormat:@"%.8lf", minValue.doubleValue];
    self.gasSlider.minimumValue = minValue.doubleValue;
    self.gasSlider.maximumValue = maxValue.doubleValue;
}

- (UILabel *)walletAddressLabel {
    if (!_walletAddressLabel) {
        _walletAddressLabel = [[UILabel alloc] init];
        _walletAddressLabel.font = FONT(13);
        _walletAddressLabel.text = [NSString stringWithFormat:@"%@:", DBHGetStringWithKeyFromTable(@"Wallet Address", nil)];
        _walletAddressLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _walletAddressLabel;
}
- (UITextField *)walletAddressTextField {
    if (!_walletAddressTextField) {
        _walletAddressTextField = [[UITextField alloc] init];
        _walletAddressTextField.font = FONT(13);
        _walletAddressTextField.textColor = COLORFROM16(0x000000, 1);
    }
    return _walletAddressTextField;
}
- (UIButton *)phoneBookButton {
    if (!_phoneBookButton) {
        _phoneBookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBookButton setImage:[UIImage imageNamed:@"通讯录"] forState:UIControlStateNormal];
        [_phoneBookButton addTarget:self action:@selector(respondsToPhoneBookButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBookButton;
}
- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = COLORFROM16(0xEAEAEA, 1);
    }
    return _firstLineView;
}
- (UILabel *)transferNumberLabel {
    if (!_transferNumberLabel) {
        _transferNumberLabel = [[UILabel alloc] init];
        _transferNumberLabel.font = FONT(13);
        _transferNumberLabel.text = [NSString stringWithFormat:@"%@:", DBHGetStringWithKeyFromTable(@"Amount", nil)];
        _transferNumberLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _transferNumberLabel;
}
- (UITextField *)transferNumberTextField {
    if (!_transferNumberTextField) {
        _transferNumberTextField = [[UITextField alloc] init];
        _transferNumberTextField.font = FONT(13);
        _transferNumberTextField.textColor = COLORFROM16(0x000000, 1);
        _transferNumberTextField.keyboardType = [self.tokenModel.flag isEqualToString:@"NEO"] ? UIKeyboardTypeNumberPad : UIKeyboardTypeDecimalPad;
    }
    return _transferNumberTextField;
}
- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = COLORFROM16(0xEAEAEA, 1);
    }
    return _secondLineView;
}
- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.font = FONT(11);
        _balanceLabel.textColor = COLORFROM16(0xA6A4A4, 1);
        
        NSString *balance = [NSString stringWithFormat:@"%.8lf", self.tokenModel.balance.doubleValue];
        NSMutableAttributedString *balanceAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"（%@ %@：%@）", self.tokenModel.flag, DBHGetStringWithKeyFromTable(@"Amount Available", nil), balance]];
        [balanceAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xF9480E, 1) range:NSMakeRange([NSString stringWithFormat:@"%@ %@", self.tokenModel.flag, DBHGetStringWithKeyFromTable(@"Amount Available", nil)].length + 2, balance.length)];
        _balanceLabel.attributedText = balanceAttributedString;
    }
    return _balanceLabel;
}
- (UILabel *)gasLabel {
    if (!_gasLabel) {
        _gasLabel = [[UILabel alloc] init];
        _gasLabel.font = FONT(13);
        _gasLabel.text = DBHGetStringWithKeyFromTable(@"Pitman Cost", nil);
        _gasLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _gasLabel;
}
- (UILabel *)gasValueLabel {
    if (!_gasValueLabel) {
        _gasValueLabel = [[UILabel alloc] init];
        _gasValueLabel.font = FONT(13);
        _gasValueLabel.text = @"0.00000000";
        _gasValueLabel.textColor = MAIN_ORANGE_COLOR;
    }
    return _gasValueLabel;
}
- (UILabel *)slowLabel {
    if (!_slowLabel) {
        _slowLabel = [[UILabel alloc] init];
        _slowLabel.font = FONT(11);
        _slowLabel.text = DBHGetStringWithKeyFromTable(@"Slow", nil);
        _slowLabel.textColor = COLORFROM16(0xC5C5C5, 1);
    }
    return _slowLabel;
}
- (UISlider *)gasSlider {
    if (!_gasSlider) {
        _gasSlider = [[UISlider alloc] init];
        _gasSlider.minimumTrackTintColor = MAIN_ORANGE_COLOR;
        _gasSlider.maximumTrackTintColor = COLORFROM16(0x0A9234, 1);
        _gasSlider.thumbTintColor = MAIN_ORANGE_COLOR;
        [_gasSlider addTarget:self action:@selector(respondsToGasSlider) forControlEvents:UIControlEventValueChanged];
    }
    return _gasSlider;
}
- (UILabel *)fastLabel {
    if (!_fastLabel) {
        _fastLabel = [[UILabel alloc] init];
        _fastLabel.font = FONT(11);
        _fastLabel.text = DBHGetStringWithKeyFromTable(@"Fast", nil);
        _fastLabel.textColor = COLORFROM16(0xC5C5C5, 1);
    }
    return _fastLabel;
}
- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font = FONT(13);
        _remarkLabel.text = [NSString stringWithFormat:@"%@:", DBHGetStringWithKeyFromTable(@"Memo", nil)];
        _remarkLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _remarkLabel;
}
- (UITextField *)remarkTextField {
    if (!_remarkTextField) {
        _remarkTextField = [[UITextField alloc] init];
        _remarkTextField.font = FONT(13);
        _remarkTextField.textColor = COLORFROM16(0x000000, 1);
    }
    return _remarkTextField;
}
- (UIView *)thirdLineView {
    if (!_thirdLineView) {
        _thirdLineView = [[UIView alloc] init];
        _thirdLineView.backgroundColor = COLORFROM16(0xEAEAEA, 1);
    }
    return _thirdLineView;
}
- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.backgroundColor = MAIN_ORANGE_COLOR;
        _commitButton.titleLabel.font = FONT(14);
        [_commitButton setTitle:DBHGetStringWithKeyFromTable(@"Submit", nil) forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(respondsToCommitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

@end
