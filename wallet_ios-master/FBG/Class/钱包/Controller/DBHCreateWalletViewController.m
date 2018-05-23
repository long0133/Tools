//
//  DBHCreateWalletViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCreateWalletViewController.h"

#import "AddWalletSucessVC.h"
#import "DBHWalletDetailViewController.h"

#import "DBHWalletManagerForNeoModelList.h"

@interface DBHCreateWalletViewController ()

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *showPasswordButton;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UITextField *surePasswordTextField;
@property (nonatomic, strong) UIView *thirdLineView;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UILabel *passTipLabel;

@property (nonatomic, copy) NSString * mnemonic; // 助记词

@end

@implementation DBHCreateWalletViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Create Wallet", nil);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.firstLineView];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.showPasswordButton];
    [self.view addSubview:self.secondLineView];
    [self.view addSubview:self.passTipLabel];
    [self.view addSubview:self.surePasswordTextField];
    [self.view addSubview:self.thirdLineView];
    [self.view addSubview:self.commitButton];
    
    WEAKSELF
    [self.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.firstLineView);
        make.height.offset(AUTOLAYOUTSIZE(38));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.firstLineView);
    }];
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(39));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(73));
    }];
    [self.passwordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.firstLineView);
        make.right.equalTo(weakSelf.showPasswordButton.mas_left);
        make.height.equalTo(weakSelf.nameTextField);
        make.bottom.equalTo(weakSelf.secondLineView);
    }];
    [self.showPasswordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(38));
        make.height.equalTo(weakSelf.passwordTextField);
        make.right.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(9.5));
        make.centerY.equalTo(weakSelf.passwordTextField);
    }];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firstLineView);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.firstLineView.mas_bottom).offset(AUTOLAYOUTSIZE(73));
    }];
    [self.passTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.secondLineView);
        make.width.lessThanOrEqualTo(weakSelf.secondLineView);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom).offset(AUTOLAYOUTSIZE(4));
    }];
    [self.surePasswordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.nameTextField);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.thirdLineView);
    }];
    [self.thirdLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.firstLineView);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.passTipLabel.mas_bottom).offset(AUTOLAYOUTSIZE(73));
    }];
    [self.commitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(73));
    }];
}

#pragma mark ------ Data ------
/**
 钱包上传
 */
- (void)uploadWallet {
    NSError *error;
    NSString *address_hash160 = NeomobileDecodeAddress(self.neoWallet.address, &error);
    
    if (error) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The wallet address is not correct.", nil)];
        
        return;
    }
    
    NSDictionary *paramters = @{@"category_id":@"2",
                                NAME:self.nameTextField.text,
                                @"address":self.neoWallet.address,
                                @"address_hash160":address_hash160};
    
    WEAKSELF
    [PPNetworkHelper POST:@"wallet" baseUrlType:1 parameters:paramters hudString:DBHGetStringWithKeyFromTable(@"Creating...", nil) success:^(id responseObject) {
        DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:[responseObject objectForKey:RECORD]];
        AddWalletSucessVC *addWalletSucessVC = [[AddWalletSucessVC alloc] init];
        addWalletSucessVC.neoWalletModel = model;
        addWalletSucessVC.mnemonic = weakSelf.mnemonic;
        addWalletSucessVC.backIndex = 1;
        [weakSelf.navigationController pushViewController:addWalletSucessVC animated:YES];
    } failure:^(NSString *error) {
         [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 隐藏/显示密码
 */
- (void)respondsToShowPasswordButton {
    self.showPasswordButton.selected = !self.showPasswordButton.selected;
    self.passwordTextField.secureTextEntry = !self.showPasswordButton.isSelected;
    self.surePasswordTextField.secureTextEntry = !self.showPasswordButton.isSelected;
}
/**
 提交
 */
- (void)respondsToCommitButton {
    if (!self.nameTextField.text.length) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Input Wallet Name", nil)];
        return;
    }

    if (![NSString isPassword:self.passwordTextField.text]) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter a password that has at least one uppercase, one lowercase, and no less than 8 digits", nil)];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.surePasswordTextField.text]) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"The two passwords differ", nil)];
        return;
    }
    
    if (self.neoWallet) {
        // 导入钱包
        [self importWallet];
    } else {
        // 生成新钱包
        [self createNewWallet];
    }
}

#pragma mark ------ Private Methods ------
/**
 导入钱包
 */
- (void)importWallet {
    NSError *error;
    NSString *data = [self.neoWallet toKeyStore:self.passwordTextField.text error:&error];
    NSString * address = [self.neoWallet address];
    [PDKeyChain save:KEYCHAIN_KEY(address) data:data];
    
    [self uploadWallet];
}
/**
 生成新钱包
 */
- (void)createNewWallet {
    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"Creating...", nil)];

    NSError * error;
    self.neoWallet = NeomobileNew(&error);

    if (!error) {
        NSError *error;
        self.mnemonic = [self.neoWallet mnemonic:[[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh_CN" : @"en_US" error:&error];

        if (!error) {
            NSError * error;
            NSString *data = [self.neoWallet toKeyStore:self.passwordTextField.text error:&error];

            if (!error) {
                // 获取钱包地址
                NSString * address = [self.neoWallet address];
                // 存入keyChain
                [PDKeyChain save:KEYCHAIN_KEY(address) data:data];

                [self uploadWallet];
            } else {
                [LCProgressHUD showFailure:@"钱包加密失败，请稍后重试"];
            }
        } else {
            [LCProgressHUD showFailure:@"助记词生成失败，请稍后重试"];
        }
    } else {
        [LCProgressHUD showFailure:@"暂时无法创建钱包，请稍后重试"];
    }
}

#pragma mark ------ Getters And Setters ------
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.font = FONT(13);
        _nameTextField.textColor = COLORFROM16(0x333333, 1);
        _nameTextField.placeholder = DBHGetStringWithKeyFromTable(@"Wallet Name", nil);
    }
    return _nameTextField;
}
- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = COLORFROM16(0xF5F5F5, 1);
    }
    return _firstLineView;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.font = FONT(13);
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.textColor = COLORFROM16(0x333333, 1);
        _passwordTextField.placeholder = DBHGetStringWithKeyFromTable(@"Password ", nil);
    }
    return _passwordTextField;
}
- (UIButton *)showPasswordButton {
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPasswordButton setImage:[UIImage imageNamed:@"睁眼1"] forState:UIControlStateNormal];
        [_showPasswordButton setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateSelected];
        [_showPasswordButton addTarget:self action:@selector(respondsToShowPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}
- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = COLORFROM16(0xF5F5F5, 1);
    }
    return _secondLineView;
}
- (UITextField *)surePasswordTextField {
    if (!_surePasswordTextField) {
        _surePasswordTextField = [[UITextField alloc] init];
        _surePasswordTextField.font = FONT(13);
        _surePasswordTextField.secureTextEntry = YES;
        _surePasswordTextField.textColor = COLORFROM16(0x333333, 1);
        _surePasswordTextField.placeholder = DBHGetStringWithKeyFromTable(@"Confirm Password", nil);
    }
    return _surePasswordTextField;
}
- (UIView *)thirdLineView {
    if (!_thirdLineView) {
        _thirdLineView = [[UIView alloc] init];
        _thirdLineView.backgroundColor = COLORFROM16(0xF5F5F5, 1);
    }
    return _thirdLineView;
}
- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.backgroundColor = MAIN_ORANGE_COLOR;
        _commitButton.titleLabel.font = BOLDFONT(14);
        _commitButton.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        [_commitButton setTitle:DBHGetStringWithKeyFromTable(@"Submit", nil) forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(respondsToCommitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (UILabel *)passTipLabel {
    if (!_passTipLabel) {
        _passTipLabel = [[UILabel alloc] init];
        _passTipLabel.text = DBHGetStringWithKeyFromTable(@"The password needs to contain at least 8 characters, with upper case, lower case and digits mixed. ", nil);
        _passTipLabel.textColor = COLORFROM16(0xC1BEBE, 1);
        _passTipLabel.font = FONT(10);
        _passTipLabel.numberOfLines = 0;
    }
    return _passTipLabel;
}

// 

@end
