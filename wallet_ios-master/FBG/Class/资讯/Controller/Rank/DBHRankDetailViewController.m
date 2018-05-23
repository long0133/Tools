//
//  DBHRankDetailViewController.m
//  FBG
//
//  Created by yy on 2018/3/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHRankDetailViewController.h"

#import "DBHRankDetailSection0TableViewCell.h"
#import "DBHRankDetailSection1TableViewCell.h"
#import "DBHRankDetailSection2TableViewCell.h"
#import "DBHTradingMarketModelData.h"
#import "DBHRankMarketGainsModel.h"
#import "DBHRankDetailModel.h"
#import "DBHProjectHomeViewController.h"

@interface DBHRankDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) DBHRankDetailModel *detailModel;

@end

@implementation DBHRankDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getData];
}

- (void)setUI {
    self.view.backgroundColor = COLORFROM16(0xF8F8F8, 1);
    self.title = DBHGetStringWithKeyFromTable(@"Detail", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Follow-up", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToTrendsButtonItem)];
    
    self.tableView.tableFooterView = nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
}

- (void)respondsToTrendsButtonItem {
    DBHInformationModelData *model = self.detailModel.projectModel;
    if ([NSObject isNulllWithObject:model]) {
        return;
    }
    DBHProjectHomeViewController *projectHomeViewController = [[DBHProjectHomeViewController alloc] init];
    projectHomeViewController.projectModel = model;
    [self.navigationController pushViewController:projectHomeViewController animated:YES];
}

#pragma mark ------ get data ------
- (void)getData {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [self getDetailData];
        [self getTradingViewData];
    });
}

- (void)getDetailData {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"token_rank/market_cap/%@", self.model.key] baseUrlType:3 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) responseCache:^(id responseCache) {
        [weakSelf handleDetailReponse:responseCache];
    } success:^(id responseObject) {
        [weakSelf handleDetailReponse:responseObject];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    } specialBlock:^{
        if (![UserSignData share].user.isLogin) {
            return ;
        }
    }];
}

- (void)handleDetailReponse:(id)response {
    if ([NSObject isNulllWithObject:response]) {
        return;
    }
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = (NSDictionary *)response;
        DBHRankDetailModel *detailModel = [DBHRankDetailModel mj_objectWithKeyValues:data];
        
        NSDictionary *category = response[CATEGORY];
        if (![NSObject isNulllWithObject:category]) {
            detailModel.projectModel = [DBHInformationModelData modelObjectWithDictionary:category];
        }
        self.detailModel = detailModel;
    }
}

- (void)getTradingViewData {
        WEAKSELF
        [PPNetworkHelper GET:[NSString stringWithFormat:@"ico/markets/%@/all", self.model.symbol] baseUrlType:3 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) responseCache:^(id responseCache) {
            [weakSelf handleReponseObj:responseCache];
        } success:^(id responseObject) {
            [weakSelf handleReponseObj:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        } specialBlock:^{
            if (![UserSignData share].user.isLogin) {
                return ;
            }
        }];
}

- (void)handleReponseObj:(id)response {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in response) {
        DBHTradingMarketModelData *model = [DBHTradingMarketModelData modelObjectWithDictionary:dic];
        [tempArr addObject:model];
    }
    self.dataSource = tempArr;
    [self.tableView reloadData];
}

#pragma mark - tableView -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return self.dataSource.count;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return AUTOLAYOUTSIZE(111);
            break;
        case 1:
            return AUTOLAYOUTSIZE(128);
            break;
        case 2:
            return AUTOLAYOUTSIZE(66);
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0: {
            DBHRankDetailSection0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RANKDETAIL_SECTION0_CELL_ID forIndexPath:indexPath];
            cell.detailModel = self.detailModel;
            return cell;
            break;
        }
        case 1: {
            DBHRankDetailSection1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RANKDETAIL_SECTION1_CELL_ID forIndexPath:indexPath];
            cell.detailModel = self.detailModel;
            return cell;
            break;
        }
        case 2: {
            DBHRankDetailSection2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RANKDETAIL_SECTION2_CELL_ID forIndexPath:indexPath];
            if (row < self.dataSource.count) {
                cell.model = self.dataSource[row];
            }
            return cell;
            break;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 2) {
        NSInteger row = indexPath.row;
        if (row < self.dataSource.count) {
            DBHTradingMarketModelData *data = self.dataSource[row];
            
            KKWebView *webView = [[KKWebView alloc] initWithUrl:data.url];
            webView.title = data.pair;
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    NSString *text = @"";
    switch (section) {
        case 1:
            text = @"Information ";
            break;
        case 2:
            text = @"Exchanges";
            break;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(25))];
    view.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(AUTOLAYOUTSIZE(22), 0, AUTOLAYOUTSIZE(100), AUTOLAYOUTSIZE(25))];
    
    headerLabel.text = DBHGetStringWithKeyFromTable(text, nil);
    headerLabel.font = FONT(13);
    headerLabel.textColor = COLORFROM16(0xC5C5C5, 1);
    
    [view addSubview:headerLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
            
        default:
            return AUTOLAYOUTSIZE(25);
            break;
    }
    
    return 0;
}

#pragma mark ----- getters and setters ----
- (void)setDetailModel:(DBHRankDetailModel *)detailModel {
    _detailModel = detailModel;
    
    [self.tableView reloadData];
    
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
