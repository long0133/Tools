//
//  DBHChangePasswordViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHChangePasswordViewController.h"

#import "DBHChangePasswordTableViewCell.h"

static NSString *const kDBHChangePasswordTableViewCellIdentifier = @"kDBHChangePasswordTableViewCellIdentifier";

@interface DBHChangePasswordViewController ()<UITableViewDataSource, UITableViewDelegate> {
    dispatch_source_t _timer;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger isShow;
@property (nonatomic, assign) NSInteger nowTimestamp;
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHChangePasswordViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Change Password", nil);
    self.view.backgroundColor = LIGHT_WHITE_BGCOLOR;
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToSaveBarButtonItem)];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHChangePasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHChangePasswordTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.valueTextField.secureTextEntry = !self.isShow;
    
    WEAKSELF
    [cell getVerificationCodeBlock:^(BOOL isShow) {
        weakSelf.isShow = isShow;
        [weakSelf.tableView reloadData];
    }];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(11.5);
}

#pragma mark ------ Data ------
/**
 修改密码
 */
- (void)updatePassword {
    DBHChangePasswordTableViewCell *verificationCodeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    DBHChangePasswordTableViewCell *newPasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    DBHChangePasswordTableViewCell *surePasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSDictionary *paramters = @{@"password_old":verificationCodeCell.valueTextField.text,
                                @"password":newPasswordCell.valueTextField.text,
                                @"password_confirmation":surePasswordCell.valueTextField.text};
    
    [PPNetworkHelper PUT:@"user/reset_password" baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        
        [[EMClient sharedClient].options setIsAutoLogin:NO];
        
        [[UserSignData share] storageData:nil];
        
        UserModel *user = [UserSignData share].user;
        // 货币单位跟随语言
        user.walletUnitType = [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? 1 : 2;
        [[UserSignData share] storageData:user];
        
        EMError *error = [[EMClient sharedClient] logout:YES];
        //        [[AppDelegate delegate] showLoginController];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_LOGIN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Password Update Success", nil)];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 保存
 */
- (void)respondsToSaveBarButtonItem {
    DBHChangePasswordTableViewCell *verificationCodeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    DBHChangePasswordTableViewCell *newPasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    DBHChangePasswordTableViewCell *surePasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (!verificationCodeCell.valueTextField.text.length) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Please input your old password", nil)];
        return;
    }
    if (!newPasswordCell.valueTextField.text.length) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Please input a password", nil)];
        return;
    }
    if (!surePasswordCell.valueTextField.text.length) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Please enter your password again", nil)];
        return;
    }
    if (![newPasswordCell.valueTextField.text isEqualToString:surePasswordCell.valueTextField.text]) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The two passwords differ", nil)];
        return;
    }
    
    [self updatePassword];
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(51);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHChangePasswordTableViewCell class] forCellReuseIdentifier:kDBHChangePasswordTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"Old Password", @"New Password", @"Confirm Password"];
    }
    return _titleArray;
}

@end
