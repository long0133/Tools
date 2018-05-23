//
//  DBHTradingMarketOCViewController.m
//  FBG
//
//  Created by yy on 2018/3/16.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTradingMarketOCViewController.h"
//#import "DBHTradingMarketCharTableViewCell.h"
#import "DBHTradingMarketTableViewCell.h"
#import "DBHTradingMarketModelData.h"
#import "DBHTradingMarketViewController.h"
#import "FBG-Swift.h"
#import "DBHProjectDetailInformationModelCategoryUser.h"
#import "DBHMarketDetailViewModel.h"

static NSString *const kDBHTradingMarketTableViewCell = @"kDBHTradingMarketTableViewCell";
//static NSString *const kDBHTradingMarketCharTableViewCell = @"kDBHTradingMarketCharTableViewCell";

@interface DBHTradingMarketOCViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DBHTradingMarketView *tradingMarketView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) DBHProjectDetailInformationModelData *detailModel;
@property (nonatomic, strong) DBHInformationModelData *model;

@end

@implementation DBHTradingMarketOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setDetailModel:(DBHProjectDetailInformationModelData *)detailModel model:(DBHInformationModelData *)model {
    _detailModel = detailModel;
    _model = model;
    
    self.title = detailModel.unit;
    
    self.tradingMarketView.yourOpinion = DBHGetStringWithKeyFromTable(@"Your Opinion", nil);
    self.tradingMarketView.chatRoomId = [NSString stringWithFormat:@"%ld", (NSInteger)detailModel.roomId];
    self.tradingMarketView.isMarketFollow = detailModel.categoryUser.isMarketFollow ? @"1" : @"0";
    self.tradingMarketView.max = detailModel.categoryUser.marketHige;
    self.tradingMarketView.min = detailModel.categoryUser.marketLost;
    self.tradingMarketView.titleStr = detailModel.unit;
    self.tradingMarketView.projectId = [NSString stringWithFormat:@"%ld", (NSInteger)model.dataIdentifier];
    
    [self.tradingMarketView refreshTitleStr];
    
    [self refreshChartData];
    [self getInfomation];
}

- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shishihangqing_shuaxin"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshChartData)];
   
    WEAKSELF
    
    CGFloat height = SCREEN_HEIGHT - STATUSBARHEIGHT - 44 - AUTOLAYOUTSIZE(220);
    [self.view addSubview:self.tradingMarketView];
    [self.tradingMarketView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.width.equalTo(weakSelf.view);
        make.height.equalTo(@(AUTOLAYOUTSIZE(height)));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tradingMarketView.mas_bottom);
        make.width.centerX.bottom.equalTo(weakSelf.view);
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self  setTimerNil];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count < 5 ? self.dataSource.count : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHTradingMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHTradingMarketTableViewCell forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return AUTOLAYOUTSIZE(63.5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(25);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(25))];
    view.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(AUTOLAYOUTSIZE(20), 0, AUTOLAYOUTSIZE(100), AUTOLAYOUTSIZE(25))];
    
    headerLabel.text = DBHGetStringWithKeyFromTable(@"Exchanges", nil);
    headerLabel.font = FONT(13);
    headerLabel.textColor = COLORFROM16(0xC5C5C5, 1);
    
    [view addSubview:headerLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return AUTOLAYOUTSIZE(63.5);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, AUTOLAYOUTSIZE(63.5))];
    view.backgroundColor = WHITE_COLOR;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:DBHGetStringWithKeyFromTable(@"More ", nil) forState:UIControlStateNormal];
    CGFloat width = AUTOLAYOUTSIZE([NSString getWidthtWithString:btn.currentTitle fontSize:14]);
    btn.frame = CGRectMake(CGRectGetMidX(view.frame) - width / 2, 0, width, AUTOLAYOUTSIZE(63.5));
    [btn setTitleColor:COLORFROM16(0xC5C5C5, 1) forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(14);
    [btn addTarget:self action:@selector(goTradingMarketVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    imgView.frame = CGRectMake(CGRectGetMaxX(btn.frame) + AUTOLAYOUTSIZE(6), 0, AUTOLAYOUTSIZE(5), AUTOLAYOUTSIZE(9.5));
    imgView.centerY = btn.centerY;
    
    [view addSubview:btn];
    [view addSubview:imgView];
    
    return view;
}

- (void)goTradingMarketVC {
    DBHTradingMarketViewController *tradingMarketViewController = [[DBHTradingMarketViewController alloc] init];
    tradingMarketViewController.title = self.detailModel.unit;
    tradingMarketViewController.chatRoomId = [NSString stringWithFormat:@"%ld", (NSInteger)self.detailModel.roomId];
    [self.navigationController pushViewController:tradingMarketViewController animated:YES];
}


#pragma mark ------ Data ------
/**
 获取TradingView数据
 */
- (void)getInfomation {
    WEAKSELF
    [PPNetworkHelper GET:[NSString stringWithFormat:@"ico/markets/%@/all", self.title] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if (weakSelf.dataSource.count) {
            return ;
        }
        
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseCache) {
            DBHTradingMarketModelData *model = [DBHTradingMarketModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } success:^(id responseObject) {
        [weakSelf.dataSource removeAllObjects];
        
        for (NSDictionary *dic in responseObject) {
            DBHTradingMarketModelData *model = [DBHTradingMarketModelData modelObjectWithDictionary:dic];
            
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSString *error) {
        
    } specialBlock:nil];
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < self.dataSource.count) {
        DBHTradingMarketModelData *data = self.dataSource[row];
       
        KKWebView *webView = [[KKWebView alloc] initWithUrl:data.url];
        webView.title = data.pair;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
//        [_tableView registerClass:[DBHTradingMarketCharTableViewCell class] forCellReuseIdentifier:kDBHTradingMarketCharTableViewCell];
        [_tableView registerClass:[DBHTradingMarketTableViewCell class] forCellReuseIdentifier:kDBHTradingMarketTableViewCell];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (DBHTradingMarketView *)tradingMarketView {
    if (!_tradingMarketView) {
        _tradingMarketView = [[DBHTradingMarketView alloc] init];
    }
    return _tradingMarketView;
}

- (void)refreshChartData {
    [self.tradingMarketView refreshKLineViewData];
}

- (void)setTimerNil {
    [self.tradingMarketView.marketDetailViewModel setTimernil];
}
@end
