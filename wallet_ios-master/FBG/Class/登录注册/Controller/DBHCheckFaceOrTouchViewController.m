//
//  DBHCheckFaceOrTouchViewController.m
//  Trinity
//
//  Created by 邓毕华 on 2017/12/29.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHCheckFaceOrTouchViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>

#import "DBHInputPasswordPromptView.h"

@interface DBHCheckFaceOrTouchViewController ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIButton *enterPasswordButton;
@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;
@property (nonatomic, strong) LAContext *context;

@end

@implementation DBHCheckFaceOrTouchViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startCheck];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.typeImageView];
    [self.view addSubview:self.typeLabel];
    [self.view addSubview:self.enterPasswordButton];
    
    WEAKSELF
    [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(73.5));
        make.right.bottom.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(173));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(63));
    }];
    [self.typeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(93));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(126.5));
    }];
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.typeImageView.mas_bottom).offset(AUTOLAYOUTSIZE(32));
    }];
    [self.enterPasswordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(31));
    }];
}

#pragma mark ------ Data ------
/**
 登录
 */
- (void)loginWithPassword:(NSString *)password {
    NSDictionary *paramters = @{@"email":[UserSignData share].user.email,
                                @"password":password};
    
    [PPNetworkHelper POST:@"login" baseUrlType:3 parameters:paramters hudString:[NSString stringWithFormat:@"%@...", DBHGetStringWithKeyFromTable(@"Log in", nil)] success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate delegate] goToTabbar];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 点击图片开始检查
 */
- (void)respondsToTypeImageView {
    [self startCheck];
}
/**
 输入密码
 */
- (void)respondsToEnterPasswordButton {
    [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];

    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.inputPasswordPromptView animationShow];
    });
}

#pragma mark ------ Private Methods ------
/**
 开始检查
 */
- (void)startCheck {
    // Touch ID
    WEAKSELF
    @try {
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:DBHGetStringWithKeyFromTable(@"Check", nil) reply:^(BOOL success, NSError *error) {
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [[AppDelegate delegate] goToTabbar];
                }];
            } else {
                switch (error.code) {
                    case LAErrorSystemCancel: {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel: { //Face ID未能识别达到两次
                        NSLog(@"用户取消验证Touch ID");
                        break;
                    }
                    case LAErrorAuthenticationFailed: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Check Failed", nil)];
                        }];
                        break;
                    }
                    case LAErrorPasscodeNotSet: {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorTouchIDNotAvailable: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Face ID unauthorized", nil)];
                        }];
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Face ID unavailable", nil)];
                        }];
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback: {
                        NSLog(@"输入密码");
                        break;
                    }
                    case LAErrorTouchIDLockout: {
                        // 指纹错误超过3次
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [weakSelf passwordCheck];
                        }];
                        break;
                    }
                    default: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Face ID unavailable", nil)];
        }];
        NSLog(@"FaceId启用失败  exception = %@", exception);
    }
}
/**
 密码检查
 */
- (void)passwordCheck {
    WEAKSELF
    [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:DBHGetStringWithKeyFromTable(@"Check", nil) reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }];
        } else {
            NSLog(@"%@", error.description);
        }
    }];
}

#pragma mark ------ Getters And Setters ------
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglu_bg"]];
    }
    return _backImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(30);
        _titleLabel.text = [NSString stringWithFormat:@"%@***%@", [[UserSignData share].user.email substringToIndex:2], [[UserSignData share].user.email substringFromIndex:[UserSignData share].user.email.length - 2]];
        _titleLabel.textColor = MAIN_ORANGE_COLOR;
    }
    return _titleLabel;
}
- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[UserSignData share].user.canUseUnlockType == DBHCanUseUnlockTypeTouchID ? @"denglu_zhiwen" : @"faceid"]];
        _typeImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTypeImageView)];
        [_typeImageView addGestureRecognizer:tapGR];
    }
    return _typeImageView;
}
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = BOLDFONT(15);
        _typeLabel.text = [UserSignData share].user.canUseUnlockType == DBHCanUseUnlockTypeTouchID ? @"Touch ID" : @"Face ID";
        _typeLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _typeLabel;
}
- (UIButton *)enterPasswordButton {
    if (!_enterPasswordButton) {
        _enterPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterPasswordButton.titleLabel.font = FONT(11);
        [_enterPasswordButton setTitle:DBHGetStringWithKeyFromTable(@"use password to sign in", nil) forState:UIControlStateNormal];
        [_enterPasswordButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [_enterPasswordButton addTarget:self action:@selector(respondsToEnterPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterPasswordButton;
}
- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            [weakSelf loginWithPassword:password];
        }];
    }
    return _inputPasswordPromptView;
}
- (LAContext *)context {
    if (!_context) {
        _context = [[LAContext alloc] init];
        _context.localizedFallbackTitle = DBHGetStringWithKeyFromTable(@"Password", nil);
    }
    return _context;
}

@end
