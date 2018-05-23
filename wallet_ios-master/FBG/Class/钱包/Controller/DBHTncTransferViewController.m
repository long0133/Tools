//
//  DBHTncTransferViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/12.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTncTransferViewController.h"

#import "ScanVC.h"
#import "DBHAddressBookViewController.h"
#import "DBHTransferConfirmationViewController.h"

#import "DBHWalletManagerForNeoModelList.h"
#import "DBHWalletDetailTokenInfomationModelData.h"

@interface DBHTncTransferViewController ()<ScanVCDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *walletAddressLabel;
@property (nonatomic, strong) UITextField *walletAddressTextField;
@property (nonatomic, strong) UIButton *phoneBookButton;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UILabel *transferNumberLabel;
@property (nonatomic, strong) UITextField *transferNumberTextField;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UITextField *remarkTextField;
@property (nonatomic, strong) UIView *thirdLineView;
@property (nonatomic, strong) UILabel *poundageLabel;
@property (nonatomic, strong) UILabel *noPoundageLabel;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UILabel *canUseGasNumberLabel;

@property (nonatomic, copy) NSString *poundage; // 手续费
@property (nonatomic, copy) NSString *realityPoundage; // 实际手续费

@end

@implementation DBHTncTransferViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Transfer", nil);
    
    [self setUI];
    [self checkGasCanUse];
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
    [self.view addSubview:self.remarkLabel];
    [self.view addSubview:self.remarkTextField];
    [self.view addSubview:self.thirdLineView];
    [self.view addSubview:self.poundageLabel];
    [self.view addSubview:self.noPoundageLabel];
    [self.view addSubview:self.commitButton];
    [self.view addSubview:self.canUseGasNumberLabel];
    
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
        make.top.equalTo(weakSelf.secondLineView.mas_bottom).offset(AUTOLAYOUTSIZE(105.5));
    }];
    [self.poundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.firstLineView);
        make.top.equalTo(weakSelf.thirdLineView.mas_bottom).offset(AUTOLAYOUTSIZE(27.5));
    }];
    [self.noPoundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.poundageLabel.mas_right);
        make.right.equalTo(weakSelf.firstLineView);
        make.top.equalTo(weakSelf.poundageLabel);
    }];
    [self.commitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(47.5));
    }];
    [self.canUseGasNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.commitButton.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
}

#pragma mark ------ MailListDelegate ------
///**
// 通讯录获取代理
// */
//- (void)choasePersonWithData:(id)data {
//    MailMdel *model = data;
//    self.walletAddressTextField.text = model.address;
//}

#pragma mark ------ ScanVCDelegate ------
/**
 扫一扫成功代理
 */
- (void)scanSucessWithObject:(id)object {
    if (![NSString isNEOAdress:[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter the correct wallet address", nil)];
        return;
    }
    
    self.walletAddressTextField.text = object;
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *changeAfterString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (changeAfterString.length && changeAfterString.doubleValue > 0) {
        [self getPoundageWithAcount:changeAfterString];
    } else {
        self.poundageLabel.text = [NSString stringWithFormat:@"%@：0.00 Gas", DBHGetStringWithKeyFromTable(@"Transaction Fee", nil)];
    }
    
    return YES;
}

#pragma mark ------ Data ------
/**
 获取转账所需手续费
 */
- (void)getPoundageWithAcount:(NSString *)Acount {
    NSDictionary *paramters = @{@"treaty_address":[self.tokenModel.address substringFromIndex:2],
                                @"from_address":NeomobileDecodeAddress(self.neoWalletModel.address, nil),
                                @"to_address":NeomobileDecodeAddress(self.neoWalletModel.address, nil),
                                @"amount":@"1"/*Acount*/}; //TODO amount固定=1?
    
    WEAKSELF
    [PPNetworkHelper POST:@"extend/getNeoGasCost" baseUrlType:1 parameters:paramters hudString:nil success:^(id responseObject) {
        weakSelf.poundage = [NSString stringWithFormat:@"%@", responseObject[@"gas_consumed"]];
        weakSelf.realityPoundage = weakSelf.poundage.doubleValue < 10 ? @"0" : weakSelf.poundage;
        if (weakSelf.transferNumberTextField.text.doubleValue == 0.0f) {
            weakSelf.poundageLabel.text = [NSString stringWithFormat:@"%@：0.00 Gas", DBHGetStringWithKeyFromTable(@"Transaction Fee", nil)];
        } else {
            weakSelf.poundageLabel.text = [NSString stringWithFormat:@"%@：%lf Gas", DBHGetStringWithKeyFromTable(@"Transaction Fee", nil), weakSelf.poundage.doubleValue];
        }
        [weakSelf checkGasCanUse];
    } failure:^(NSString *error) {
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
    if (![NSString isNEOAdress:[self.walletAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
    {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter the correct wallet address", nil)];
        return;
    }
    if (self.transferNumberTextField.text.length == 0)
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
    transferConfirmationViewController.poundage = self.poundage;
    transferConfirmationViewController.realityPoundage = self.realityPoundage;
    transferConfirmationViewController.address = self.walletAddressTextField.text;
    transferConfirmationViewController.remark = self.remarkTextField.text;
    
    NSLog(@"转账金额 ---- %@", numberStr);
    [self.navigationController pushViewController:transferConfirmationViewController animated:YES];
}

#pragma mark ------ Private Methods ------
/**
 检查Gas是否够使用
 */
- (void)checkGasCanUse {
    self.commitButton.userInteractionEnabled = self.canUseGasBalance.doubleValue && self.canUseGasBalance.doubleValue >= self.realityPoundage.doubleValue;
    self.commitButton.backgroundColor = !self.commitButton.userInteractionEnabled ? COLORFROM16(0xDADADA, 1) : MAIN_ORANGE_COLOR;
    [self.commitButton setTitle:DBHGetStringWithKeyFromTable(!self.commitButton.userInteractionEnabled ? @"The current wallet GAS balance is insufficient and cannot be submitted" : @"Submit", nil) forState:UIControlStateNormal];
}

#pragma mark ------ Getters And Setters ------
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
        _transferNumberTextField.delegate = self;
        _transferNumberTextField.keyboardType = UIKeyboardTypeDecimalPad;
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
- (UILabel *)poundageLabel {
    if (!_poundageLabel) {
        _poundageLabel = [[UILabel alloc] init];
        _poundageLabel.font = FONT(13);
        _poundageLabel.text = [NSString stringWithFormat:@"%@：0.00 Gas", DBHGetStringWithKeyFromTable(@"Transaction Fee", nil)];
        _poundageLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _poundageLabel;
}
- (UILabel *)noPoundageLabel {
    if (!_noPoundageLabel) {
        _noPoundageLabel = [[UILabel alloc] init];
        _noPoundageLabel.font = FONT(11);
        _noPoundageLabel.numberOfLines = 0;
        _noPoundageLabel.text = DBHGetStringWithKeyFromTable(@"（Free handling charge under 10Gas）", nil);
        _noPoundageLabel.textColor = COLORFROM16(0xA6A4A4, 1);
    }
    return _noPoundageLabel;
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
- (UILabel *)canUseGasNumberLabel {
    if (!_canUseGasNumberLabel) {
        _canUseGasNumberLabel = [[UILabel alloc] init];
        _canUseGasNumberLabel.font = FONT(11);
        _canUseGasNumberLabel.textColor = COLORFROM16(0xA6A4A4, 1);
        
        NSString *balance = [NSString stringWithFormat:@"%.4lf", self.canUseGasBalance.doubleValue];
        NSMutableAttributedString *balanceAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"（Gas %@：%@）", DBHGetStringWithKeyFromTable(@"Amount Available", nil), balance]];
        [balanceAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xF9480E, 1) range:NSMakeRange([NSString stringWithFormat:@"Gas %@", DBHGetStringWithKeyFromTable(@"Amount Available", nil)].length + 2, balance.length)];
        _canUseGasNumberLabel.attributedText = balanceAttributedString;
    }
    return _canUseGasNumberLabel;
}

@end
