//
//  DBHAddPropertyViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHAddPropertyViewController.h"

#import "DBHAddPropertyTableViewCell.h"

#import "DBHWalletManagerForNeoModelList.h"
#import "DBHAddPropertyDataModels.h"
#import "DBHSearchTitleView.h"

static NSString *const kDBHAddPropertyTableViewCellIdentifier = @"kDBHAddPropertyTableViewCellIdentifier";

@interface DBHAddPropertyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectedTokenIdArray;
@property (nonatomic, strong) DBHSearchTitleView *searchView;

@property (nonatomic, strong) NSMutableArray *showDataSource;


@end

@implementation DBHAddPropertyViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(self.walletModel.categoryId == 1 ? @"Add Token" : @"Add Nep-5 asset", nil);
    
    [self setUI];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getTokenList];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Confirm", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToFinishBarButtonItem)];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
    }];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAddPropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHAddPropertyTableViewCellIdentifier forIndexPath:indexPath];
    DBHAddPropertyModelList *model = self.showDataSource[indexPath.row];
    cell.model = model;
    cell.isSelected = [self.selectedTokenIdArray containsObject:@(model.listIdentifier)];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAddPropertyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DBHAddPropertyModelList *model = self.showDataSource[indexPath.row];
    if (cell.isSelected) {
        [self.selectedTokenIdArray removeObject:@(model.listIdentifier)];
    } else {
        [self.selectedTokenIdArray addObject:@(model.listIdentifier)];
    }
    cell.isSelected = [self.selectedTokenIdArray containsObject:@(model.listIdentifier)];
}

#pragma mark ------ Data ------
/**
 获取代币列表
 */
- (void)getTokenList {
    NSDictionary *paramters = @{@"wallet_category_id":@(self.walletModel.categoryId),
                                @"wallet_id":@(self.walletModel.listIdentifier)};
    
    WEAKSELF
    [PPNetworkHelper GET:@"gnt-category" baseUrlType:1 parameters:paramters hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) responseCache:^(id responseCache) {
        [weakSelf endRefresh];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.selectedTokenIdArray removeAllObjects];
        
        for (NSDictionary *dic in responseCache[LIST]) {
            DBHAddPropertyModelList *model = [DBHAddPropertyModelList modelObjectWithDictionary:dic];
            [weakSelf.dataSource addObject:model];
        }
        
        weakSelf.showDataSource = weakSelf.dataSource;
        [weakSelf.tableView reloadData];
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.selectedTokenIdArray removeAllObjects];
        
        for (NSDictionary *dic in responseObject[LIST]) {
            DBHAddPropertyModelList *model = [DBHAddPropertyModelList modelObjectWithDictionary:dic];
            [weakSelf.dataSource addObject:model];
        }
        
        weakSelf.showDataSource = weakSelf.dataSource;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [weakSelf endRefresh];
        [LCProgressHUD showFailure:error];
    } specialBlock:^{
        if (![UserSignData share].user.isLogin) {
            return ;
        }
    }];
}
/**
 添加代币
 */
- (void)addToken {
    NSDictionary *paramters = @{@"wallet_id":@(self.walletModel.listIdentifier), @"gnt_category_ids":[self.selectedTokenIdArray toJSONStringForArray]};
    
    WEAKSELF
    [PPNetworkHelper POST:@"user-gnt" baseUrlType:1 parameters:paramters hudString:DBHGetStringWithKeyFromTable(@"Adding...", nil) success:^(id responseObject) {
         [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
         [LCProgressHUD showFailure:error];
     }];
}

#pragma mark ------ Event Responds ------
/**
 完成
 */
- (void)respondsToFinishBarButtonItem {
    if (!self.selectedTokenIdArray.count) {
        [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Please select a token", nil)];
        
        return;
    }
    
    [self addToken];
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getTokenList];
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
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(55);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHAddPropertyTableViewCell class] forCellReuseIdentifier:kDBHAddPropertyTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)showDataSource {
    if (!_showDataSource) {
        _showDataSource = [NSMutableArray array];
    }
    return _showDataSource;
}

- (NSMutableArray *)selectedTokenIdArray {
    if (!_selectedTokenIdArray) {
        _selectedTokenIdArray = [NSMutableArray array];
    }
    return _selectedTokenIdArray;
}

- (DBHSearchTitleView *)searchView {
    if (!_searchView) {
        _searchView = [[DBHSearchTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, STATUS_HEIGHT + 44) isShowBtn:NO];
        WEAKSELF
        [_searchView searchBlock:^(NSInteger type, NSString *searchString) {
            switch (type) {
                case -1: { // 清空
                    weakSelf.showDataSource = weakSelf.dataSource;
                    [weakSelf.tableView reloadData];
                }
                    break;
                    
                case 1:
                    // 搜索
                    if (searchString.length) {
                        [weakSelf searchDBFromDatasource:searchString];
                    }
                    break;
                case 2:
                    if (searchString.length) {
                        [weakSelf searchDBFromDatasource:searchString];
                    }
                    break;
                    
                default:
                    break;
            }
        }];
    }
    return _searchView;
}

- (void)searchDBFromDatasource:(NSString *)searchStr {
    __block BOOL isSearch = NO;
    __block NSString *desStr = [[searchStr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    __block NSMutableArray *resultArr = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DBHAddPropertyModelList *model = (DBHAddPropertyModelList *)obj;
        NSString *dbName = model.name;
        
        if ([dbName containsString:desStr] ||
            [dbName containsString:[desStr lowercaseString]] ||
            [dbName containsString:[desStr uppercaseString]]) {
            
            [resultArr addObject:model];
        
            isSearch = YES;
//            *stop = YES;
        }
    }];
    
    self.showDataSource = resultArr;
    [self.tableView reloadData];
    
//    if (!isSearch) {
//        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Not Found", nil)];
//        self.searchView.searchTextField.text = searchStr;
//        [self.view endEditing:YES];
//    }
}

@end
