//
//  DBHTokenSaleViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTokenSaleViewController.h"

#import "ScanVC.h"
#import "DBHTokenSaleConfirmationViewController.h"

@interface DBHTokenSaleViewController ()<ScanVCDelegate>

@property (nonatomic, strong) UILabel *walletAddressLabel;
@property (nonatomic, strong) UITextField *walletAddressTextField;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UILabel *transferNumberLabel;
@property (nonatomic, strong) UITextField *transferNumberTextField;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *poundageLabel;
@property (nonatomic, strong) UILabel *noPoundageLabel;
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation DBHTokenSaleViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Token Sale";
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"身份证扫描"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToScanQrCodeBarButtonItem)];
    
    [self.view addSubview:self.walletAddressLabel];
    [self.view addSubview:self.walletAddressTextField];
    [self.view addSubview:self.firstLineView];
    [self.view addSubview:self.transferNumberLabel];
    [self.view addSubview:self.transferNumberTextField];
    [self.view addSubview:self.secondLineView];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.poundageLabel];
    [self.view addSubview:self.noPoundageLabel];
    [self.view addSubview:self.commitButton];
    
    WEAKSELF
    [self.walletAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.walletAddressTextField);
        make.bottom.equalTo(weakSelf.walletAddressTextField.mas_top);
    }];
    [self.walletAddressTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.firstLineView);
        make.centerX.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(40));
        make.bottom.equalTo(weakSelf.firstLineView.mas_top);
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
    [self.poundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.firstLineView);
        make.top.equalTo(weakSelf.balanceLabel.mas_bottom).offset(AUTOLAYOUTSIZE(27.5));
    }];
    [self.noPoundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.poundageLabel.mas_right);
        make.centerY.equalTo(weakSelf.poundageLabel);
    }];
    [self.commitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(47.5));
    }];
    
    self.balanceLabel.text = @"（NEO可用数量：）";
    self.poundageLabel.text = [NSString stringWithFormat:@"%@：0.01 Gas", DBHGetStringWithKeyFromTable(@"Transaction Fee", nil)];
}

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
 提交
 */
- (void)respondsToCommitButton {
    DBHTokenSaleConfirmationViewController *tokenSaleConfirmationViewController = [[DBHTokenSaleConfirmationViewController alloc] init];
    [self.navigationController pushViewController:tokenSaleConfirmationViewController animated:YES];
}

#pragma mark ------ Getters And Setters ------
- (UILabel *)walletAddressLabel {
    if (!_walletAddressLabel) {
        _walletAddressLabel = [[UILabel alloc] init];
        _walletAddressLabel.font = FONT(13);
        _walletAddressLabel.text = [NSString stringWithFormat:@"%@:", DBHGetStringWithKeyFromTable(@"Intelligent Contract Address", nil)];
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
        _transferNumberLabel.text = [NSString stringWithFormat:@"NEO%@:", DBHGetStringWithKeyFromTable(@"Amount", nil)];
        _transferNumberLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _transferNumberLabel;
}
- (UITextField *)transferNumberTextField {
    if (!_transferNumberTextField) {
        _transferNumberTextField = [[UITextField alloc] init];
        _transferNumberTextField.font = FONT(13);
        _transferNumberTextField.textColor = COLORFROM16(0x000000, 1);
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
    }
    return _balanceLabel;
}
- (UILabel *)poundageLabel {
    if (!_poundageLabel) {
        _poundageLabel = [[UILabel alloc] init];
        _poundageLabel.font = FONT(13);
        _poundageLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _poundageLabel;
}
- (UILabel *)noPoundageLabel {
    if (!_noPoundageLabel) {
        _noPoundageLabel = [[UILabel alloc] init];
        _noPoundageLabel.font = FONT(11);
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

@end
