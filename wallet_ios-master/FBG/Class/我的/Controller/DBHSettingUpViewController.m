
//
//  DBHSettingUpViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSettingUpViewController.h"

#import "DBHMonetaryUnitViewController.h"
#import "DBHNetworkSwitcherViewController.h"
#import "DBHLanguageSetViewController.h"

#import "DBHSettingUpTableViewCell.h"

static NSString *const kDBHSettingUpTableViewCellIdentifier = @"kDBHSettingUpTableViewCellIdentifier";

@interface DBHSettingUpViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation DBHSettingUpViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Settings", nil);
    self.view.backgroundColor = LIGHT_WHITE_BGCOLOR;
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
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
    DBHSettingUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHSettingUpTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            // 货币单位
            DBHMonetaryUnitViewController *monetaryUnitViewController = [[DBHMonetaryUnitViewController alloc] init];
            [self.navigationController pushViewController:monetaryUnitViewController animated:YES];
            break;
        }
        case 1: {
            // 网络切换
            DBHNetworkSwitcherViewController *networkSwitcherViewController = [[DBHNetworkSwitcherViewController alloc] init];
            [self.navigationController pushViewController:networkSwitcherViewController animated:YES];
            break;
        }
        case 2: {
            // 语言设置
            if (![UserSignData share].user.isLogin) {
                [[AppDelegate delegate] goToLoginVC:self];
            }  else {
                DBHLanguageSetViewController *languageSetViewController = [[DBHLanguageSetViewController alloc] init];
                [self.navigationController pushViewController:languageSetViewController animated:YES];
            }
            break;
        }
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(11.5);
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
        
        [_tableView registerClass:[DBHSettingUpTableViewCell class] forCellReuseIdentifier:kDBHSettingUpTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"Currency Unit", @"Network Settings", @"Languages"];
    }
    return _titleArray;
}

@end
