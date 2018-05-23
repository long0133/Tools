
//
//  DBHMyFavoriteViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyFavoriteViewController.h"

#import "DBHMyFavoriteTableViewCell.h"

#import "DBHInfomationDataModels.h"

static NSString *const kDBHMyFavoriteTableViewCellIdentifier = @"kDBHMyFavoriteTableViewCellIdentifier";

@interface DBHMyFavoriteViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page; // 分页
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHMyFavoriteViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"My Reserves", nil);
    self.view.backgroundColor = LIGHT_WHITE_BGCOLOR;
    
    [self setUI];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getFavoriteListWithMoreIsLoadMore:NO];
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
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHMyFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHMyFavoriteTableViewCellIdentifier forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    if (row < self.dataSource.count) {
        DBHInfomationModelData *data = self.dataSource[row];
        cell.isNoImage = (data.type == 1);
        cell.articleModel = data;
    }
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHInfomationModelData *model = self.dataSource[indexPath.row];
    KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%ld", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD4 : TESTAPIEHEAD4, (NSInteger)model.dataIdentifier]];
    webView.title = model.title;
    webView.imageStr = model.img;
    webView.isHaveShare = YES;
    webView.infomationId = [NSString stringWithFormat:@"%ld", (NSInteger)model.dataIdentifier];
    [self.navigationController pushViewController:webView animated:YES];
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消收藏
    WEAKSELF
    UITableViewRowAction *cancelColletAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:DBHGetStringWithKeyFromTable(@"Cancel Collection", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [weakSelf cancelColletWithRow:indexPath];
//        tableView.editing = NO;
    }];
    //删除按钮颜色
    
    cancelColletAction.backgroundColor = MAIN_ORANGE_COLOR;
    
    return @[cancelColletAction];
}

#pragma mark ------ Data ------
/**
 获取收藏列表
 */
- (void)getFavoriteListWithMoreIsLoadMore:(BOOL)isLoadMore {
    if (isLoadMore) {
        self.page += 1;
    } else {
        self.page = 0;
    }
    
    WEAKSELF
    [PPNetworkHelper GET:@"article?user_favorite" baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count) {
            return ;
        }
        
        NSArray *data = responseCache[@"data"];
        for (NSDictionary *dic in data) {
            DBHInfomationModelData *model = [DBHInfomationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        
        if (!isLoadMore) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        NSArray *data = responseObject[@"data"];
        if (data.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        for (NSDictionary *dic in data) {
            DBHInfomationModelData *model = [DBHInfomationModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];;
    } specialBlock:^{
        
    }];
}
/**
 取消收藏
 */
- (void)cancelColletWithRow:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < self.dataSource.count) {
        DBHInfomationModelData *projectModel = self.dataSource[row];
        NSDictionary *paramters = @{@"enable":[NSNumber numberWithBool:false]};
        
        WEAKSELF
        [PPNetworkHelper PUT:[NSString stringWithFormat:@"article/%ld/collect", (NSInteger)projectModel.dataIdentifier] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
            [weakSelf.dataSource removeObjectAtIndex:row];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    }
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getFavoriteListWithMoreIsLoadMore:NO];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getFavoriteListWithMoreIsLoadMore:YES];
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = AUTOLAYOUTSIZE(76);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHMyFavoriteTableViewCell class] forCellReuseIdentifier:kDBHMyFavoriteTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
