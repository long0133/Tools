//
//  DBHExchangeNoticeHistoricalInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHExchangeNoticeHistoricalInformationViewController.h"

#import "DBHMyFavoriteTableViewCell.h"

#import "DBHExchangeNoticeDataModels.h"

static NSString *const kDBHMyFavoriteTableViewCellIdentifier = @"kDBHMyFavoriteTableViewCellIdentifier";

@interface DBHExchangeNoticeHistoricalInformationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage; // 当前页
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHExchangeNoticeHistoricalInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"History", nil);
    
    [self setUI];
    [self addRefresh];
    
    self.currentPage = 1;
    [self getExchangeNotice];
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
    cell.isNoImage = YES;
    cell.exchangeNoticeModel = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHExchangeNoticeModelData *model = self.dataSource[indexPath.row];
    KKWebView *webView = [[KKWebView alloc] initWithUrl:model.sourceUrl];
    webView.title = model.desc;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark ------ Data ------
/**
 获取交易所公告
 */
- (void)getExchangeNotice {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"exchange_notice?per_page=20&page=%ld", self.currentPage] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count) {
            return ;
        }
        
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseCache[@"data"]) {
            DBHExchangeNoticeModelData *model = [DBHExchangeNoticeModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf scrollViewToBottom:NO];
        });
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        
        if (weakSelf.currentPage == 1) {
            [weakSelf.dataSource removeAllObjects];
        }
        
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *array = responseObject[@"data"];
        for (NSInteger i = array.count - 1; i >= 0; i--) {
            DBHExchangeNoticeModelData *model = [DBHExchangeNoticeModelData modelObjectWithDictionary:array[i]];
            
            [dataArray addObject:model];
        }
        
        if (weakSelf.currentPage == 1) {
            [weakSelf.dataSource addObjectsFromArray:dataArray];
        } else if (dataArray.count) {
            [weakSelf.dataSource insertObjects:dataArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dataArray.count)]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            
            if (weakSelf.currentPage == 1) {
                if (weakSelf.dataSource.count > 2) {
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            } else if (dataArray.count) {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dataArray.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    } specialBlock:nil];
}

#pragma mark ------ Private Methods ------
/**
 滑动到底部
 */
- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.dataSource.count < weakSelf.currentPage * 5) {
            [weakSelf endRefresh];
            
            return ;
        }
        
        weakSelf.currentPage += 1;
        [weakSelf getExchangeNotice];
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(75.5);
        
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
