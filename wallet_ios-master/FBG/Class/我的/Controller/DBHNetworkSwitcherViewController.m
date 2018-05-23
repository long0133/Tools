//
//  DBHNetworkSwitcherViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "ZFTabBarViewController.h"
#import "DBHNetworkSwitcherViewController.h"

#import "DBHMonetaryUnitTableViewCell.h"

static NSString *const kDBHMonetaryUnitTableViewCellIdentifier = @"kDBHMonetaryUnitTableViewCellIdentifier";

@interface DBHNetworkSwitcherViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentSelectedRow;
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHNetworkSwitcherViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Network Settings", nil);
    self.view.backgroundColor = LIGHT_WHITE_BGCOLOR;
    self.currentSelectedRow = [APP_APIEHEAD isEqualToString:APIEHEAD1] ? 0 : 1;
    
    [self setUI];
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
    if (self.currentSelectedRow == ([APP_APIEHEAD isEqualToString:APIEHEAD1] ? 0 : 1)) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[EMClient sharedClient].options setIsAutoLogin:NO];
        
        [[UserSignData share] storageData:nil];
        
        UserModel *user = [UserSignData share].user;
        // 货币单位跟随语言
        user.walletUnitType = [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? 1 : 2;
        [[UserSignData share] storageData:user];
        
        [[NSUserDefaults standardUserDefaults] setObject:!self.currentSelectedRow ? APIEHEAD1 : TESTAPIEHEAD1 forKey:APP_NETWORK_API_KEY];
        EMError *error = [[EMClient sharedClient] logout:YES];
        [[AppDelegate delegate] emregister];
//        [[AppDelegate delegate] showLoginController];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_LOGIN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
        ZFTabBarViewController * tab = [[ZFTabBarViewController alloc] init];
        UIWindow *window = [AppDelegate delegate].window;
        window.rootViewController = tab;
        [window makeKeyAndVisible];
        
    }
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
        _titleArray = @[@"MainNet", @"TestNet"];
    }
    return _titleArray;
}

@end
