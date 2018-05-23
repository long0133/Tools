//
//  DBHCandyBowlHistoricalInformationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCandyBowlHistoricalInformationViewController.h"

#import "DBHCandyBowlDetailViewController.h"

#import "DBHMyFavoriteTableViewCell.h"

#import "DBHCandyBowlDataModels.h"

static NSString *const kDBHMyFavoriteTableViewCellIdentifier = @"kDBHMyFavoriteTableViewCellIdentifier";

@interface DBHCandyBowlHistoricalInformationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHCandyBowlHistoricalInformationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"History", nil);
    
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getCandyBowl];
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
    cell.candyBowlModel = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHCandyBowlDetailViewController *candyBowlDetailViewController = [[DBHCandyBowlDetailViewController alloc] init];
    candyBowlDetailViewController.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:candyBowlDetailViewController animated:YES];
}

#pragma mark ------ Data ------
/**
 获取CandyBowl
 */
- (void)getCandyBowl {
    WEAKSELF
    [PPNetworkHelper GET:@"candy_bow" baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseCache[LIST][@"data"]) {
            DBHCandyBowlModelData *model = [DBHCandyBowlModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject[LIST][@"data"]) {
            DBHCandyBowlModelData *model = [DBHCandyBowlModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    } specialBlock:nil];
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
