//
//  DBHLanguageSetViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHLanguageSetViewController.h"

#import "DBHMonetaryUnitTableViewCell.h"
#import "ZFTabBarViewController.h"

static NSString *const kDBHMonetaryUnitTableViewCellIdentifier = @"kDBHMonetaryUnitTableViewCellIdentifier";

@interface DBHLanguageSetViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentSelectedRow;
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHLanguageSetViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Languages", nil);
    self.view.backgroundColor = LIGHT_WHITE_BGCOLOR;
    self.currentSelectedRow = [CURRENT_APP_LANGUAGE isEqualToString:EN] ? 1 : 0;
    
    [self setUI];
    
    if ([[DBHLanguageTool sharedInstance].language isEqualToString:CNS]) {
        self.currentSelectedRow = 0;
    } else {
        self.currentSelectedRow = 1;
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Confirm", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToSureBarButtonItem)];
    
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
    DBHMonetaryUnitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMonetaryUnitTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
   
    cell.isSelected = self.currentSelectedRow == indexPath.row;
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelectedRow = indexPath.row;
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(11.5);
}

#pragma mark ------ Event Responds ------
/**
 确定
 */
- (void)respondsToSureBarButtonItem {
    
//    UserModel *user = [UserSignData share].user;
    // 货币单位跟随语言
//    user.walletUnitType = self.currentSelectedRow ? 2 : 1;
//    [[UserSignData share] storageData:user];
    
//    [self.navigationController popViewControllerAnimated:YES];
    NSString *newLan = (self.currentSelectedRow == 0) ? CNS : EN;
    if ([[DBHLanguageTool sharedInstance].language isEqualToString:newLan]) {
        return;
    }
    
    NSDictionary *params = @{
                             @"lang" : [newLan isEqualToString:CNS] ? @"zh" : EN
                             };
    
    [PPNetworkHelper PUT:@"user/lang" baseUrlType:3 parameters:params hudString:DBHGetStringWithKeyFromTable(@"Setting...", nil) success:^(id responseObject) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Successfully set", nil)];
        UserModel *user = [UserSignData share].user;
        user.language = [newLan isEqualToString:CNS] ? @"zh" : EN;
        user.walletUnitType = [user.language isEqualToString:@"zh"] ? 1 : 2;
        [[UserSignData share] storageData:user];
        
        ZFTabBarViewController * tab = [[ZFTabBarViewController alloc] init];
        tab.customTabBar.selectedIndex = 2;
        tab.selectedIndex = 2; //必须放在tab.customTabBar.selectedIndex = 2;的下一行
        UIWindow *window = [AppDelegate delegate].window;
        window.rootViewController = tab;
        [window makeKeyAndVisible];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
    
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
        
        [_tableView registerClass:[DBHMonetaryUnitTableViewCell class] forCellReuseIdentifier:kDBHMonetaryUnitTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"简体中文", @"English(U.S.)"];
    }
    return _titleArray;
}

@end
