//
//  DBHAddOrEditAddressViewController.m
//  Trinity
//
//  Created by 邓毕华 on 2017/12/28.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHAddOrEditAddressViewController.h"

#import "ScanVC.h"

#import "DBHAddOrEditAddressTableViewCell.h"
#import "DBHAddressBookViewController.h"

#import "DBHAddressBookDataModels.h"

static NSString *const kDBHAddOrEditAddressTableViewCellIdentifier = @"kDBHAddOrEditAddressTableViewCellIdentifier";

@interface DBHAddOrEditAddressViewController ()<UITableViewDataSource, ScanVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation DBHAddOrEditAddressViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(self.addressViewControllerType == DBHAddressViewControllerAddType ? @"Add Contact" : @"Edit Contact", nil);
    
    [self setUI];
}

- (void)setAddAddressVC:(NSInteger)index {
    UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    if ([vc isKindOfClass:[DBHAddressBookViewController class]]) {
        DBHAddressBookViewController *detailVC = (DBHAddressBookViewController *)vc;
        detailVC.currentSelectedItem = index;
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(self.addressViewControllerType == DBHAddressViewControllerAddType ? @"Submit" : @"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToRightBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sureButton];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
    [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(47.5));
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAddOrEditAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHAddOrEditAddressTableViewCellIdentifier forIndexPath:indexPath];
    cell.nameTextField.text = self.model.name;
    cell.addressTextField.text = self.model.address;
    
    WEAKSELF
    [cell scanQrCodeBlock:^{
        ScanVC * vc = [[ScanVC alloc] init];
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    return cell;
}

#pragma mark ------ ScanVCDelegate ------
/**
 扫一扫成功代理
 */
- (void)scanSucessWithObject:(id)object {
    if ([self.icoId isEqualToString:@"1"]) {
        if (![NSString isAdress:[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter the correct wallet address", nil)];
            return;
        }
    } else {
        if (![NSString isNEOAdress:[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter the correct wallet address", nil)];
            return;
        }
    }
    
    DBHAddOrEditAddressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.addressTextField.text = object;
}

#pragma mark ------ Data ------
/**
 添加联系人
 */
- (void)addContact {
    DBHAddOrEditAddressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDictionary *paramters = @{@"category_id":self.icoId,
                                NAME:cell.nameTextField.text,
                                @"address":cell.addressTextField.text};
    
    WEAKSELF
    [PPNetworkHelper POST:@"contact" baseUrlType:1 parameters:paramters hudString:DBHGetStringWithKeyFromTable(@"Saving...", nil) success:^(id responseObject) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Saved successfully", nil)];
        [weakSelf setAddAddressVC:self.icoId.intValue - 1];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 编辑联系人
 */
- (void)updateContact {
    DBHAddOrEditAddressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDictionary *paramters = @{@"category_id":self.icoId,
                                NAME:cell.nameTextField.text,
                                @"address":cell.addressTextField.text};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"contact/%ld", (NSInteger)self.model.listIdentifier] baseUrlType:1 parameters:paramters hudString:DBHGetStringWithKeyFromTable(@"Modifying...", nil) success:^(id responseObject) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Successfully modified", nil)]; 
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
- (void)respondsToSureButton {
    [PPNetworkHelper DELETE:[NSString stringWithFormat:@"contact/%ld", (NSInteger)self.model.listIdentifier] baseUrlType:1 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Deleting...", nil) success:^(id responseObject)
     {
         [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Delete successfully", nil)];
         [self.navigationController popViewControllerAnimated:YES];
         
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}
/**
 保存/提交
 */
- (void)respondsToRightBarButtonItem {
    DBHAddOrEditAddressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (!cell.nameTextField.text.length) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter wallet name", nil)];
        return;
    }
    if (!cell.addressTextField.text.length) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter wallet address", nil)];
        return;
    }
    if ([self.icoId isEqualToString:@"1"]) {
        // ETH
        if (![NSString isAdress:[cell.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
        {
            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter the correct wallet address", nil)];
            return;
        }
    } else {
        // NEO
        if (![NSString isNEOAdress:[cell.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
        {
            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Please enter the correct wallet address", nil)];
            return;
        }
    }
    
    if (self.addressViewControllerType == DBHAddressViewControllerAddType) {
        // 保存
        [self addContact];
    } else {
        // 提交
        [self updateContact];
    }
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(162);
        
        _tableView.dataSource = self;
        
        [_tableView registerClass:[DBHAddOrEditAddressTableViewCell class] forCellReuseIdentifier:kDBHAddOrEditAddressTableViewCellIdentifier];
    }
    return _tableView;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = MAIN_ORANGE_COLOR;
        _sureButton.titleLabel.font = FONT(14);
        [_sureButton setTitle:DBHGetStringWithKeyFromTable(@"Delete", nil) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:UIControlEventTouchUpInside];
        
        _sureButton.hidden = (self.addressViewControllerType == DBHAddressViewControllerAddType);
    }
    return _sureButton;
}

@end
