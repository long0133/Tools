//
//  YYRedPacketChooseCashViewController.m
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketChooseCashViewController.h"
#import "YYRedPacketChooseCashTableViewCell.h"
#import "YYRedPacketChoosePayStyleView.h"


@interface YYRedPacketChooseCashViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YYRedPacketChooseCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Choose Cash", nil);
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ---- data -----
- (void)getData {
    NSString *urlStr = [NSString stringWithFormat:@"offline_wallet/extend/getGntCategory/%d", 1];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) responseCache:^(id responseCache) {
            [weakSelf handleResponse:responseCache];
        } success:^(id responseObject) {
            [weakSelf handleResponse:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        } specialBlock:nil];
    });
}

- (void)handleResponse:(id)responseObj {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSMutableArray *tempArr = nil;
        if ([NSObject isNulllWithObject:responseObj]) {
            return;
        }
        
        if ([responseObj isKindOfClass:[NSArray class]]) {
            tempArr = [NSMutableArray array];
            for (NSDictionary *dict in responseObj) {
                YYRedPacketEthTokenModel *model = [YYRedPacketEthTokenModel mj_objectWithKeyValues:dict];
                if (![NSObject isNulllWithObject:model]) {
                    [tempArr addObject:model];
                }
            }
        }
        
        self.dataSource = tempArr;
    });
}


#pragma mark ----- UITableView ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYRedPacketChooseCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHOOSE_CASH_CELL_ID forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (row < self.dataSource.count) {
        cell.model = self.dataSource[row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < self.dataSource.count) {
        YYRedPacketEthTokenModel *model = self.dataSource[row];
        if (self.block) {
            self.block(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

#pragma mark ----- Setters And Getters ---------
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
