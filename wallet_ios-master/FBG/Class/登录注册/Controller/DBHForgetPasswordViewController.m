//
//  DBHForgetPasswordViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/22.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHForgetPasswordViewController.h"

@interface DBHForgetPasswordViewController () {
    dispatch_source_t _timer;
}

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *forgetPasswordLabel;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UIView *firsetLineView;
@property (nonatomic, strong) UITextField *verificationCodeTextField;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIButton *getVerificationCodeButton;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *showPasswordButton;
@property (nonatomic, strong) UIView *thirdLineView;
@property (nonatomic, strong) UITextField *surePasswordTextField;
@property (nonatomic, strong) UIView *fourthLineView;
@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, assign) NSInteger nowTimestamp;

@end

@implementation DBHForgetPasswordViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark ------ Touch ------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.forgetPasswordLabel];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.firsetLineView];
    [self.view addSubview:self.verificationCodeTextField];
    [self.view addSubview:self.grayView];
    [self.view addSubview:self.getVerificationCodeButton];
    [self.view addSubview:self.secondLineView];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.showPasswordButton];
    [self.view addSubview:self.thirdLineView];
    [self.view addSubview:self.surePasswordTextField];
    [self.view addSubview:self.fourthLineView];
    [self.view addSubview:self.commitButton];
    
    WEAKSELF
    [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(73.5));
        make.right.bottom.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(173));
    }];
    [self.forgetPasswordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(AUTOLAYOUTSIZE(2));
        make.left.offset(AUTOLAYOUTSIZE(35));
    }];
    [self.accountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(48));
        make.left.equalTo(weakSelf.firsetLineView);
        make.right.equalTo(weakSelf.showPasswordButton.mas_left);
        make.bottom.equalTo(weakSelf.firsetLineView);
    }];
    [self.firsetLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(70));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.secondLineView.mas_top).offset(- AUTOLAYOUTSIZE(61));
    }];
    [self.verificationCodeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.accountTextField);
        make.left.equalTo(weakSelf.accountTextField);
        make.right.equalTo(weakSelf.grayView.mas_left);
        make.bottom.equalTo(weakSelf.secondLineView);
    }];
    [self.grayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(2));
        make.height.offset(AUTOLAYOUTSIZE(14.5));
        make.centerY.equalTo(weakSelf.verificationCodeTextField);
        make.right.equalTo(weakSelf.getVerificationCodeButton.mas_left).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.getVerificationCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([NSString getWidthtWithString:DBHGetStringWithKeyFromTable(@"Get", nil) fontSize:AUTOLAYOUTSIZE(14)] + AUTOLAYOUTSIZE(20));
        make.right.equalTo(weakSelf.secondLineView);
        make.height.equalTo(weakSelf.verificationCodeTextField);
        make.centerY.equalTo(weakSelf.verificationCodeTextField);
    }];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firsetLineView);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.thirdLineView.mas_top).offset(- AUTOLAYOUTSIZE(61));
    }];
    [self.passwordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.firsetLineView);
        make.right.equalTo(weakSelf.showPasswordButton.mas_left);
        make.height.equalTo(weakSelf.accountTextField);
        make.bottom.equalTo(weakSelf.thirdLineView);
    }];
    [self.showPasswordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(34.5));
        make.height.equalTo(weakSelf.passwordTextField);
        make.right.offset(- AUTOLAYOUTSIZE(25));
        make.centerY.equalTo(weakSelf.passwordTextField);
    }];
    [self.thirdLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firsetLineView);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.fourthLineView.mas_top).offset(- AUTOLAYOUTSIZE(61));
    }];
    [self.surePasswordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.firsetLineView);
        make.height.equalTo(weakSelf.accountTextField);
        make.centerX.equalTo(weakSelf.firsetLineView);
        make.bottom.equalTo(weakSelf.fourthLineView);
    }];
    [self.fourthLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firsetLineView);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.commitButton.mas_top).offset(- AUTOLAYOUTSIZE(37));
    }];
    [self.commitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.firsetLineView);
        make.height.offset(AUTOLAYOUTSIZE(39));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(214.5));
    }];
}

#pragma mark ------ Data ------
/**
 获取验证码
 */
- (void)getVerificationCode {
    WEAKSELF
    NSDictionary *params = @{@"type" : @2};
    [PPNetworkHelper POST:[NSString stringWithFormat:@"send_code/%@", self.accountTextField.text] baseUrlType:3 parameters:params hudString:[NSString stringWithFormat:@"%@...", DBHGetStringWithKeyFromTable(@"Get", nil)] success:^(id responseObject) {
        [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"The verification code has been sent to your mailbox", nil)];
        [weakSelf keepTime];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 修改密码
 */
- (void)updatePassword {
    NSDictionary *paramters = @{@"email":self.accountTextField.text,
                                @"code":self.verificationCodeTextField.text,
                                @"password":self.passwordTextField.text,
                                @"password_confirmation":self.surePasswordTextField.text};
    
    WEAKSELF
    [PPNetworkHelper POST:@"forgot_password" baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Password reset successful", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 获取验证码
 */
- (void)respondsToGetVerificationCodeButton {
    if (!self.accountTextField.text.length) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Please input a email", nil)];
        return;
    }
    
    // 获取验证码
    [self getVerificationCode];
}
/**
 显示/隐藏密码
 */
- (void)respondsToShowPasswordButton:(UIButton *)button {
    button.selected = !button.selected;
    self.passwordTextField.secureTextEntry = !button.isSelected;
    self.surePasswordTextField.secureTextEntry = !button.isSelected;
}
/**
 提交
 */
- (void)respondsToCommitButton {
    if (!self.accountTextField.text.length) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Please input a email", nil)];
        return;
    }
    if (!self.verificationCodeTextField.text.length) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Please enter verification code", nil)];
        return;
    }
    if (!self.passwordTextField.text.length) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Please input a password", nil)];
        return;
    }
    if (!self.surePasswordTextField.text.length) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Please enter your password again", nil)];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.surePasswordTextField.text]) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The two passwords differ", nil)];
        return;
    }
    
    [self.view endEditing:YES];
    [self updatePassword];
}

#pragma mark ------ Private Methods ------
/**
 发送验证码计时
 */
- (void)keepTime {
    // 记录当前时间
    NSDate *currenDate = [NSDate date];
    self.nowTimestamp = (long)[currenDate timeIntervalSince1970];
    
    // 创建一个派发队列 优先级是默认
    WEAKSELF
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        NSDate *currenDate = [NSDate date];
        NSInteger timestamp = [currenDate timeIntervalSince1970];
        timestamp = 60 - timestamp + self.nowTimestamp;
        if (timestamp <= 0) { // 倒计时结束 关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置按钮的样式
                [weakSelf.getVerificationCodeButton setTitle:DBHGetStringWithKeyFromTable(@"Retrieves", nil) forState:UIControlStateNormal];
                [weakSelf.getVerificationCodeButton setTitleColor:COLORFROM16(0x008C55, 1) forState:UIControlStateNormal];
                weakSelf.getVerificationCodeButton.userInteractionEnabled = YES;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置按钮显示读秒效果
                [weakSelf.getVerificationCodeButton setTitle:[NSString stringWithFormat:@"(%lds)", timestamp] forState:UIControlStateNormal];
                [weakSelf.getVerificationCodeButton setTitleColor:COLORFROM16(0x999999, 1) forState:UIControlStateNormal];
                weakSelf.getVerificationCodeButton.userInteractionEnabled = NO;
            });
        }
    });
    dispatch_resume(_timer);
}

#pragma mark ------ Getters And Setters ------
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglu_bg"]];
    }
    return _backImageView;
}
- (UILabel *)forgetPasswordLabel {
    if (!_forgetPasswordLabel) {
        _forgetPasswordLabel = [[UILabel alloc] init];
        _forgetPasswordLabel.font = BOLDFONT(25);
        _forgetPasswordLabel.text = DBHGetStringWithKeyFromTable(@"Forget Password", nil);
        _forgetPasswordLabel.textColor = MAIN_ORANGE_COLOR;
    }
    return _forgetPasswordLabel;
}
- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        _accountTextField.font = FONT(14);
        _accountTextField.textColor = COLORFROM16(0x333333, 1);
        _accountTextField.placeholder = DBHGetStringWithKeyFromTable(@"Email", nil);
    }
    return _accountTextField;
}
- (UIView *)firsetLineView {
    if (!_firsetLineView) {
        _firsetLineView = [[UIView alloc] init];
        _firsetLineView.backgroundColor = COLORFROM16(0xECECEC, 1);
    }
    return _firsetLineView;
}
- (UITextField *)verificationCodeTextField {
    if (!_verificationCodeTextField) {
        _verificationCodeTextField = [[UITextField alloc] init];
        _verificationCodeTextField.font = FONT(14);
        _verificationCodeTextField.textColor = COLORFROM16(0x333333, 1);
        _verificationCodeTextField.placeholder = DBHGetStringWithKeyFromTable(@"Please enter verification code", nil);
    }
    return _verificationCodeTextField;
}
- (UIView *)grayView {
    if (!_grayView) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = COLORFROM16(0xECECEC, 1);
    }
    return _grayView;
}
- (UIButton *)getVerificationCodeButton {
    if (!_getVerificationCodeButton) {
        _getVerificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _getVerificationCodeButton.titleLabel.font = FONT(14);
        [_getVerificationCodeButton setTitle:DBHGetStringWithKeyFromTable(@"Get", nil) forState:UIControlStateNormal];
        [_getVerificationCodeButton setTitleColor:COLORFROM16(0x008C55, 1) forState:UIControlStateNormal];
        [_getVerificationCodeButton addTarget:self action:@selector(respondsToGetVerificationCodeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getVerificationCodeButton;
}
- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = COLORFROM16(0xECECEC, 1);
    }
    return _secondLineView;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.font = FONT(14);
        _passwordTextField.textColor = COLORFROM16(0x333333, 1);
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = DBHGetStringWithKeyFromTable(@"New Password", nil);
    }
    return _passwordTextField;
}
- (UIButton *)showPasswordButton {
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPasswordButton setImage:[UIImage imageNamed:@"denglu_eyes_close"] forState:UIControlStateNormal];
        [_showPasswordButton setImage:[UIImage imageNamed:@"denglu_eyes_open"] forState:UIControlStateSelected];
        [_showPasswordButton addTarget:self action:@selector(respondsToShowPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}
- (UIView *)thirdLineView {
    if (!_thirdLineView) {
        _thirdLineView = [[UIView alloc] init];
        _thirdLineView.backgroundColor = COLORFROM16(0xECECEC, 1);
    }
    return _thirdLineView;
}
- (UITextField *)surePasswordTextField {
    if (!_surePasswordTextField) {
        _surePasswordTextField = [[UITextField alloc] init];
        _surePasswordTextField.font = FONT(14);
        _surePasswordTextField.textColor = COLORFROM16(0x333333, 1);
        _surePasswordTextField.secureTextEntry = YES;
        _surePasswordTextField.placeholder = DBHGetStringWithKeyFromTable(@"Confirm Password", nil);
    }
    return _surePasswordTextField;
}
- (UIView *)fourthLineView {
    if (!_fourthLineView) {
        _fourthLineView = [[UIView alloc] init];
        _fourthLineView.backgroundColor = COLORFROM16(0xECECEC, 1);
    }
    return _fourthLineView;
}
- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.backgroundColor = MAIN_ORANGE_COLOR;
        _commitButton.titleLabel.font = BOLDFONT(14);
        _commitButton.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        _commitButton.clipsToBounds = YES;
        
        [_commitButton setTitle:DBHGetStringWithKeyFromTable(@"Submit", nil) forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(respondsToCommitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

@end
