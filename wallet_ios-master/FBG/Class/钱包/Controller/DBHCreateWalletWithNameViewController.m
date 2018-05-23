//
//  DBHCreateWalletWithNameViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCreateWalletWithNameViewController.h"
#import "DBHWalletManagerForNeoModelList.h"

#import "DBHWalletDetailViewController.h"
#import "DBHWalletDetailWithETHViewController.h"


#import "AddWalletSucessVC.h"

@interface DBHCreateWalletWithNameViewController ()

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation DBHCreateWalletWithNameViewController

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
    [self.commitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(73));
    }];
}

#pragma mark ------ Data ------


#pragma mark ------ Event Responds ------
/**
 提交
 */
- (void)respondsToCommitButton {
    if (!self.nameTextField.text.length) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Input Wallet Name", nil)];
        return;
    }
    
    if (self.walletType == 1) { //eth
        switch (self.from) {
            case CreateWalletFromKeyStore: {
                [self uploadWallet];
                break;
            }
            case CreateWalletFromZhuJiCi: {
                [self importWalletETH];
                break;
            }
            case CreateWalletFromSiYao: {//todo}
                
                // 导入钱包
                [self importWalletETH];
                break;
            }
            default: {
                [self uploadWallet];
                break;
            }
        }
    } else { // NEO
        switch (self.from) {
            case CreateWalletFromKeyStore: {
                [self uploadWallet];
                break;
            }
            case CreateWalletFromZhuJiCi: {
                [self importWallet];
                break;
            }
            case CreateWalletFromSiYao: {
                
                // 导入钱包
                [self importWallet];
                break;
            }
            default: {
                [self uploadWallet];
                break;
            }
        }
    }
}
#pragma mark ------ Private Methods ------
- (void)importWalletETH {
    NSError *error;
    NSString *data = [self.ethWallet toKeyStore:self.password error:&error];
//    NSString * address = self.ethWallet.address;
    [PDKeyChain save:KEYCHAIN_KEY(self.address) data:data];
    
    [self uploadWalletETH];
}

- (void)uploadWalletETH {
    NSDictionary *paramters = @{@"category_id":@"1",
                                @"name":self.nameTextField.text,
                                @"address":self.ethWallet.address};
    
    WEAKSELF
    [PPNetworkHelper POST:@"wallet" baseUrlType:1 parameters:paramters hudString:DBHGetStringWithKeyFromTable(@"Creating...", nil) success:^(id responseObject) {
        DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:[responseObject objectForKey:@"record"]];
        model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]];
        
        NSInteger count = weakSelf.navigationController.viewControllers.count;
        if (weakSelf.walletType == 1) {
            // ETH
            model.category.categoryIdentifier = 1;
            model.category.name = @"ETH";
            DBHWalletDetailWithETHViewController *walletDetailWithETHViewController = [[DBHWalletDetailWithETHViewController alloc] init];
            walletDetailWithETHViewController.ethWalletModel = model;
            
            walletDetailWithETHViewController.backIndex = (count == 4) ? 2 : 1;
            [weakSelf.navigationController pushViewController:walletDetailWithETHViewController animated:YES];
        } else {
            // NEO
            DBHWalletDetailViewController *walletDetailViewController = [[DBHWalletDetailViewController alloc] init];
            walletDetailViewController.neoWalletModel = model;
            walletDetailViewController.backIndex = (count == 4) ? 2 : 1;
            [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
        }
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 导入钱包
 */
- (void)importWallet {
    NSError *error;
    NSString *data = [self.neoWallet toKeyStore:self.password error:&error];
    NSString * address = [self.neoWallet address];
    [PDKeyChain save:KEYCHAIN_KEY(address) data:data];
    
    [self uploadWallet1];
}

/**
 钱包上传
 */
- (void)uploadWallet {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:@(self.walletType) forKey:@"category_id"];
    [paramters setObject:self.nameTextField.text forKey:NAME];
    [paramters setObject:self.walletType == 1 ? @"ETH" : @"NEO" forKey:@"category_name"];
    [paramters setObject:self.address forKey:@"address"];
    
    if (self.walletType == 2) {
        NSError *error;
        NSString *address_hash160 = NeomobileDecodeAddress(self.address, &error);
        
        if (!error) {
            [paramters setObject:address_hash160 forKey:@"address_hash160"];
        } else {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The wallet address is not correct.", nil)];
            return;
        }
    }
    
    WEAKSELF
    [PPNetworkHelper POST:@"wallet" baseUrlType:1 parameters:paramters hudString:DBHGetStringWithKeyFromTable(@"Creating...", nil) success:^(id responseObject) {
        DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:[responseObject objectForKey:RECORD]];
        NSString *modelAddr = [PDKeyChain load:KEYCHAIN_KEY(model.address)];
        NSLog(@"是否观察钱包  ---- adr = %@", modelAddr);
        model.isLookWallet = (modelAddr == nil || [modelAddr isEqual:[NSNull null]] || [modelAddr isEqualToString:@""]);
        
        NSInteger count = weakSelf.navigationController.viewControllers.count;
        if (weakSelf.walletType == 1) {
            // ETH
            model.category.categoryIdentifier = 1;
            model.category.name = @"ETH";
            DBHWalletDetailWithETHViewController *walletDetailWithETHViewController = [[DBHWalletDetailWithETHViewController alloc] init];
            walletDetailWithETHViewController.ethWalletModel = model;
            
            walletDetailWithETHViewController.backIndex = (count == 4) ? 2 : 1;
            [weakSelf.navigationController pushViewController:walletDetailWithETHViewController animated:YES];
        } else {
            // NEO
            DBHWalletDetailViewController *walletDetailViewController = [[DBHWalletDetailViewController alloc] init];
            walletDetailViewController.neoWalletModel = model;
            walletDetailViewController.backIndex = (count == 4) ? 2 : 1;
            [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
        }
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

/**
 钱包上传
 */
- (void)uploadWallet1 {
    NSError *error;
    NSString *address_hash160 = NeomobileDecodeAddress(self.neoWallet.address, &error);
    
    if (error) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The wallet address is not correct.", nil)];
        return;
    }
    
    NSString *name = self.nameTextField.text;
    if ([NSObject isNulllWithObject:name]) {
        name = @"";
    }
    
    
    NSDictionary *paramters = @{@"category_id":@"2",
                                @"name": name,
                                @"address": self.address,
                                @"address_hash160":address_hash160};
    
    WEAKSELF
    [PPNetworkHelper POST:@"wallet" baseUrlType:1 parameters:paramters hudString:DBHGetStringWithKeyFromTable(@"Creating...", nil)  success:^(id responseObject) {
        DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:[responseObject objectForKey:RECORD]];
        model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]];
        
        NSInteger count = weakSelf.navigationController.viewControllers.count;
        if (weakSelf.walletType == 1) {
            // ETH
            model.category.categoryIdentifier = 1;
            model.category.name = @"ETH";
            DBHWalletDetailWithETHViewController *walletDetailWithETHViewController = [[DBHWalletDetailWithETHViewController alloc] init];
            walletDetailWithETHViewController.ethWalletModel = model;
            
            walletDetailWithETHViewController.backIndex = (count == 4) ? 2 : 1;
            [weakSelf.navigationController pushViewController:walletDetailWithETHViewController animated:YES];
        } else {
            // NEO
            DBHWalletDetailViewController *walletDetailViewController = [[DBHWalletDetailViewController alloc] init];
            walletDetailViewController.neoWalletModel = model;
            walletDetailViewController.backIndex = (count == 4) ? 2 : 1;
            [weakSelf.navigationController pushViewController:walletDetailViewController animated:YES];
        }
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
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

@end
