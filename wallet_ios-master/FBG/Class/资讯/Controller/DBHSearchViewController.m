//
//  DBHSearchViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSearchViewController.h"

#import "KKWebView.h"

#import "DBHProjectHomeViewController.h"
#import "DBHProjectHomeNoTradingViewController.h"

#import "DBHSearchTitleView.h"
#import "DBHSearchTypeView.h"

#import "DBHSearchProjectTableViewCell.h"
#import "DBHSearchInfomationTableViewCell.h"

#import "DBHProjectHomeNewsDataModels.h"
#import "DBHInformationDataModels.h"

static NSString *const kDBHSearchProjectTableViewCellIdentifier = @"kDBHSearchProjectTableViewCellIdentifier";
static NSString *const kDBHSearchInfomationTableViewCellIdentifier = @"kDBHSearchInfomationTableViewCellIdentifier";

@interface DBHSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBHSearchTitleView *searchTitleView;
@property (nonatomic, strong) DBHSearchTypeView *searchTypeView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger searchType; // 0:资讯 1:项目
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation DBHSearchViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.searchTitleView];
    [self.view addSubview:self.searchTypeView];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.searchTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(106));
        make.top.equalTo(weakSelf.searchTitleView.mas_bottom);
        make.centerX.equalTo(weakSelf.view);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchTitleView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.searchType) {
        DBHSearchInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHSearchInfomationTableViewCellIdentifier forIndexPath:indexPath];
        cell.model = self.datasource[indexPath.row];
        
        return cell;
    } else {
        DBHSearchProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHSearchProjectTableViewCellIdentifier forIndexPath:indexPath];
        cell.model = self.datasource[indexPath.row];
        
        return  cell;
    }
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.searchType) {
        DBHProjectHomeNewsModelData *model = self.datasource[indexPath.row];
        KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%ld", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD4 : TESTAPIEHEAD4, (NSInteger)model.dataIdentifier]];
        webView.title = model.title;
        webView.imageStr = model.img;
        webView.isHaveShare = YES;
        webView.infomationId = [NSString stringWithFormat:@"%ld", (NSInteger)model.dataIdentifier];
        [self.navigationController pushViewController:webView animated:YES];
    } else {
        DBHInformationModelData *projectModel = self.datasource[indexPath.row];
        
        if (projectModel.type == 1) {
            // 交易中项目
            DBHProjectHomeViewController *projectHomeViewController = [[DBHProjectHomeViewController alloc] init];
            projectHomeViewController.projectModel = projectModel;
            [self.navigationController pushViewController:projectHomeViewController animated:YES];
        } else {
            // 其他项目
            DBHProjectHomeNoTradingViewController *projectHomeNoTradingViewController = [[DBHProjectHomeNoTradingViewController alloc] init];
            projectHomeNoTradingViewController.projectModel = projectModel;
            [self.navigationController pushViewController:projectHomeNoTradingViewController animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !self.searchType ? AUTOLAYOUTSIZE(89) : AUTOLAYOUTSIZE(60);
}

#pragma mark ------ Data ------
/**
 搜索资讯

 @param searchString 搜索内容
 */
- (void)searchInfomtaionWithString:(NSString *)searchString {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"search/all?k=%@", searchString] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf.datasource removeAllObjects];
        
        for (NSDictionary *dic in responseCache[@"data"]) {
            DBHProjectHomeNewsModelData *model = [DBHProjectHomeNewsModelData modelObjectWithDictionary:dic];
            
            [weakSelf.datasource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } success:^(id responseObject) {
        [weakSelf.datasource removeAllObjects];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            DBHProjectHomeNewsModelData *model = [DBHProjectHomeNewsModelData modelObjectWithDictionary:dic];
            
            [weakSelf.datasource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    } specialBlock:nil];
}
/**
 搜索项目
 
 @param searchString 搜索内容
 */
- (void)searchProjectWithString:(NSString *)searchString {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"category?keyword=%@", searchString] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf.datasource removeAllObjects];
        
        for (NSDictionary *dic in responseCache[@"data"]) {
            DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.datasource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } success:^(id responseObject) {
        [weakSelf.datasource removeAllObjects];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            DBHInformationModelData *model = [DBHInformationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.datasource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    } specialBlock:nil];
}

#pragma mark ------ Getters And Setters ------
- (DBHSearchTitleView *)searchTitleView {
    if (!_searchTitleView) {
        _searchTitleView = [[DBHSearchTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, STATUS_HEIGHT + 44) isShowBtn:YES];
        _searchTitleView.searchType = 0;
        WEAKSELF
        [_searchTitleView searchBlock:^(NSInteger type, NSString *searchString) {
            switch (type) {
                case -1:
                    // 清空
                    weakSelf.tableView.hidden = YES;
                    break;
                case 0:
                    // 取消
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    break;
                    
                case 1:
                    // 搜索
                    if (searchString.length) {
                        weakSelf.tableView.hidden = NO;
                        if (!weakSelf.searchType) {
                            [weakSelf searchInfomtaionWithString:searchString];
                        } else {
                            [weakSelf searchProjectWithString:searchString];
                        }
                    }
                    break;
                    
                default:
                    break;
            }
        }];
    }
    return _searchTitleView;
}
- (DBHSearchTypeView *)searchTypeView {
    if (!_searchTypeView) {
        _searchTypeView = [[DBHSearchTypeView alloc] init];
        
        WEAKSELF
        [_searchTypeView selectedTypeBlock:^(NSInteger type) {
            // 搜索类型选择
            weakSelf.searchType = type;
            weakSelf.searchTitleView.searchType = type;
        }];
    }
    return _searchTypeView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.hidden = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHSearchProjectTableViewCell class] forCellReuseIdentifier:kDBHSearchProjectTableViewCellIdentifier];
        [_tableView registerClass:[DBHSearchInfomationTableViewCell class] forCellReuseIdentifier:kDBHSearchInfomationTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

@end
