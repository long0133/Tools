//
//  DBHLookWalletInfoViewController.m
//  FBG
//
//  Created by yy on 2018/3/14.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHLookWalletInfoViewController.h"
#import "DBHLookWalletInfoTableViewCell.h"
#import "DBHInformationModelData.h"
#import "DBHProjectHomeViewController.h"
#import "DBHProjectHomeNoTradingViewController.h"

static NSString *const kDBHLookWalletInfoTableViewCellIdentifier = @"kDBHLookWalletInfoTableViewCellIdentifier";

@interface DBHLookWalletInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *tempDataSource;

@end

@implementation DBHLookWalletInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Project Information", nil);
    [self addRefresh];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getProjectInfo];
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getProjectInfo];
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

#pragma mark - 设置UI
- (void)setUI {
    self.view.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(10));
        make.width.centerX.bottom.equalTo(weakSelf.view);
    }];
}

- (void)removeTempAllObjects {
    if (self.tempDataSource.count) {
        [self.tempDataSource removeAllObjects];
    }
}

#pragma mark - 获取数据
- (void)getProjectInfo {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
//        NSDictionary *param = @{@"units" : self.unitsArr};
        NSString *param = @"units=[";
        if (self.unitsArr.count > 0) {
            for (int i = 0; i < self.unitsArr.count; i ++) {
                NSString *unit = self.unitsArr[i];
                param = [param stringByAppendingFormat:@"\"%@\"", unit];
                
                if (i != self.unitsArr.count - 1) {
                    param = [param stringByAppendingString:@","];
                } else {
                    param = [param stringByAppendingString:@"]"];
                }
            }
        }
        
        WEAKSELF
        [PPNetworkHelper GET:[NSString stringWithFormat:@"category?%@", param] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
            NSArray *datas = responseCache[@"data"];
            [weakSelf handleData:datas];
        } success:^(id responseObject) {
            NSArray *datas = responseObject[@"data"];
            [weakSelf handleData:datas];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        } specialBlock:^{
            
        }];
    });
}

- (void)handleData:(NSArray *)datas {
    [self removeTempAllObjects]; //清除缓存数据，获取最新数据
    [self endRefresh];
    if (datas.count > 0) {
        for (NSDictionary *dict in datas) {
            DBHInformationModelData *data = [DBHInformationModelData modelObjectWithDictionary:dict];
            [self.tempDataSource addObject:data];
        }
    } else { // 没有数据
    }
    
    self.dataSource = [NSMutableArray arrayWithArray:self.tempDataSource];
    [self.tableView reloadData];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHLookWalletInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHLookWalletInfoTableViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        DBHInformationModelData *projectModel = self.dataSource[indexPath.row];
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

#pragma mark - Getter and Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(55);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHLookWalletInfoTableViewCell class] forCellReuseIdentifier:kDBHLookWalletInfoTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)tempDataSource {
    if (!_tempDataSource) {
        _tempDataSource = [NSMutableArray array];
    }
    return _tempDataSource;
}
@end
