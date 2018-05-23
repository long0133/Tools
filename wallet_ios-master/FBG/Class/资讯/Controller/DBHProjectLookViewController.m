//
//  DBHProjectLookViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectLookViewController.h"

#import "KKWebView.h"

#import "DBHHistoricalInformationViewController.h"

#import "DBHProjectLookForProjectInfomationTableViewCell.h"
#import "DBHProjectLookForProjectCommunityTableViewCell.h"
#import "DBHPersonalSettingForSwitchTableViewCell.h"

#import "DBHInformationDataModels.h"
#import "DBHProjectDetailInformationDataModels.h"

static NSString *const kDBHProjectLookForProjectInfomationTableViewCellIdentifier = @"kDBHProjectLookForProjectInfomationTableViewCellIdentifier";
static NSString *const kDBHProjectLookForProjectCommunityTableViewCellIdentifier = @"kDBHProjectLookForProjectCommunityTableViewCellIdentifier";
static NSString *const kDBHPersonalSettingForSwitchTableViewCellIdentifier = @"kDBHPersonalSettingForSwitchTableViewCellIdentifier";

@interface DBHProjectLookViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *collectBarButtonItem;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;

@end

@implementation DBHProjectLookViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.projectModel.unit;
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getProjectDetailInfomation];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = self.collectBarButtonItem;
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.projectDetailModel.categoryMedia.count;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            DBHProjectLookForProjectInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectLookForProjectInfomationTableViewCellIdentifier forIndexPath:indexPath];
            cell.projectDetailModel = self.projectDetailModel;
            WEAKSELF
            [cell clickTypeButtonBlock:^(NSInteger type) {
                if (!type) {
                    // 项目官网
                    KKWebView * vc = [[KKWebView alloc] initWithUrl:weakSelf.projectDetailModel.website];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    // 历史资讯
                    DBHHistoricalInformationViewController *historicalInformationViewController = [[DBHHistoricalInformationViewController alloc] init];
                    historicalInformationViewController.projevtId = [NSString stringWithFormat:@"%ld", (NSInteger)weakSelf.projectDetailModel.dataIdentifier];
                    [weakSelf.navigationController pushViewController:historicalInformationViewController animated:YES];
                }
            }];
            
            return cell;
            break;
        }
        case 1: {
            DBHProjectLookForProjectCommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHProjectLookForProjectCommunityTableViewCellIdentifier forIndexPath:indexPath];
            cell.model = self.projectDetailModel.categoryMedia[indexPath.row];
            
            return cell;
            break;
        }
        case 2: {
            DBHPersonalSettingForSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHPersonalSettingForSwitchTableViewCellIdentifier forIndexPath:indexPath];
            cell.title = @"Sticky on Top";
            cell.isStick = self.projectDetailModel.categoryUser.isTop;
            
            WEAKSELF
            [cell changeSwitchBlock:^(BOOL isOpen) {
                [weakSelf projectStickWithIsStick:isOpen];
            }];
            
            return cell;
            break;
        }
            
        default: {
            return nil;
            break;
        }
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        DBHProjectDetailInformationModelCategoryMedia *model = self.projectDetailModel.categoryMedia[indexPath.row];
        
        KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
        webView.title = model.name;
        webView.imageStr = model.img;
        [self.navigationController pushViewController:webView animated:YES];
    }
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 2 ? AUTOLAYOUTSIZE(37) : AUTOLAYOUTSIZE(0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !indexPath.section ? AUTOLAYOUTSIZE(324.5) + (self.projectDetailModel.categoryMedia.count ? 0 : - AUTOLAYOUTSIZE(37)) : AUTOLAYOUTSIZE(50.5);
}

#pragma mark ------ Data ------
/**
 获取项目详细信息
 */
- (void)getProjectDetailInfomation {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [PPNetworkHelper GET:[NSString stringWithFormat:@"category/%ld", (NSInteger)self.projectModel.dataIdentifier] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
            if (weakSelf.projectDetailModel) {
                return ;
            }
            
            weakSelf.projectDetailModel = [DBHProjectDetailInformationModelData modelObjectWithDictionary:responseCache];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        } success:^(id responseObject) {
            weakSelf.projectDetailModel = [DBHProjectDetailInformationModelData modelObjectWithDictionary:responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:weakSelf.projectDetailModel.categoryUser.isFavorite ? @"xiangmugaikuang_xing_s" : @"xiangmugaikuang_xing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCollectBarButtonItem)];
                weakSelf.navigationItem.rightBarButtonItem = self.collectBarButtonItem;
                
                [weakSelf.tableView reloadData];
            });
        } failure:^(NSString *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LCProgressHUD showFailure:error];
            });
        } specialBlock:^{
            if (![UserSignData share].user.isLogin) {
                return ;
            }
        }];
    });
}
/**
 项目收藏
 */
- (void)projectCollet {
    NSDictionary *paramters = @{@"enable":self.projectDetailModel.categoryUser.isFavorite ? [NSNumber numberWithBool:false] : [NSNumber numberWithBool:true]};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/collect", (NSInteger)self.projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        NSString *is_favorite = responseObject[@"is_favorite"];
        weakSelf.projectDetailModel.categoryUser.isFavorite = is_favorite.integerValue == 1;
        weakSelf.collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:weakSelf.projectDetailModel.categoryUser.isFavorite ? @"xiangmugaikuang_xing_s" : @"xiangmugaikuang_xing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCollectBarButtonItem)];
        weakSelf.navigationItem.rightBarButtonItem = self.collectBarButtonItem;
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}
/**
 项目置顶
 */
- (void)projectStickWithIsStick:(BOOL)isStick {
    NSDictionary *paramters = @{@"enable":[NSNumber numberWithBool:isStick]};
    
    WEAKSELF
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"category/%ld/set_top", (NSInteger)self.projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        NSString *isTop = responseObject[@"is_top"];
        weakSelf.projectDetailModel.categoryUser.isTop = isTop.integerValue == 1 ? YES : NO;
        //        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

#pragma mark ------ Event Responds ------
/**
 收藏
 */
- (void)respondsToCollectBarButtonItem {
    [self projectCollet];
}

#pragma mark ------ Getters And Setters ------
- (UIBarButtonItem *)collectBarButtonItem {
    if (!_collectBarButtonItem) {
        _collectBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:self.projectDetailModel.categoryUser.isFavorite ? @"xiangmugaikuang_xing_s" : @"xiangmugaikuang_xing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCollectBarButtonItem)];
    }
    return _collectBarButtonItem;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHProjectLookForProjectInfomationTableViewCell class] forCellReuseIdentifier:kDBHProjectLookForProjectInfomationTableViewCellIdentifier];
        [_tableView registerClass:[DBHProjectLookForProjectCommunityTableViewCell class] forCellReuseIdentifier:kDBHProjectLookForProjectCommunityTableViewCellIdentifier];
        [_tableView registerClass:[DBHPersonalSettingForSwitchTableViewCell class] forCellReuseIdentifier:kDBHPersonalSettingForSwitchTableViewCellIdentifier];
    }
    return _tableView;
}

@end
