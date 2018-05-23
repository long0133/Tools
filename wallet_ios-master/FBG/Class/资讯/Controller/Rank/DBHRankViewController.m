//
//  DBHRankViewController.m
//  FBG
//
//  Created by yy on 2018/3/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHRankViewController.h"
#import "DBHSelectScrollView.h"
#import "JJStockView.h"
#import "DBHRankListHeaderView.h"
#import "DBHRankView.h"
#import "DBHRankMarketGainsModel.h"
#import "DBHRankTitleAndDataModel.h"
#import "DBHExchangeRankModel.h"
#import "DBHExchangeRankTypeModel.h"
#import "DBHDappRankModel.h"
#import "DBHInweProjectRankModel.h"
#import "DBHHotInfoRankModel.h"
#import "DBHInformationModelData.h"
#import "YYRankTotalMarketValueModel.h"

@interface DBHRankViewController ()

@property (nonatomic, strong) UIView *totalView;
@property (nonatomic, strong) UILabel *capLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
// view
@property (nonatomic, strong) DBHSelectScrollView *titleScrollView;
@property (nonatomic, strong) DBHRankView *currentRankView;

// array
@property (nonatomic, strong) NSMutableArray *titlesArr;

/**
 市值涨幅的titles(市值排名，交易量，当前价格，涨跌幅，市值)
 */
@property (nonatomic, strong) NSMutableArray *gainsTitlesArr;
@property (nonatomic, strong) NSMutableArray *gainsDatasArr;

/**
 装的市值涨幅，交易所，Dapp，Inwe项目排行，热门资讯
 */
@property (nonatomic, strong) NSMutableArray *datasArr;

/**
 交易所的titles(名称，交易量(24H),交易对，Transaction Type)
 */
@property (nonatomic, strong) NSMutableArray *exchangeTitlesArr;
@property (nonatomic, strong) NSMutableArray *exchangeDatasArr;

/**
 Dapp的titles
 */
@property (nonatomic, strong) NSMutableArray *dappTitlesArr;
@property (nonatomic, strong) NSMutableArray *dappDatasArr;

/**
 Inwe项目排行的titles
 */
@property (nonatomic, strong) NSMutableArray *inweProjectRankTitlesArr;
@property (nonatomic, strong) NSMutableArray *inweProjectRankDatasArr;


/**
 热门资讯的titles
 */
@property (nonatomic, strong) NSMutableArray *hotInfoTitlesArr;
@property (nonatomic, strong) NSMutableArray *hotInfoDatasArr;

@property (nonatomic, strong) YYRankTotalMarketValueModel *totalModel;

@end

@implementation DBHRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUI];
    [self showScrollViewByIndex:0]; // 默认显示第一个
    [self getDataByIndex:5];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -----Set UI -----
- (void)setUI {
     WEAKSELF
    [self.view addSubview:self.totalView];
    [self.totalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.centerX.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(25));
    }];
    
    [self.totalView addSubview:self.capLabel];
    [self.capLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(10));
        make.top.centerY.equalTo(weakSelf.totalView);
    }];
    
    [self.totalView addSubview:self.volumeLabel];
    [self.volumeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.capLabel.mas_right).offset(AUTOLAYOUTSIZE(8));
        make.centerY.height.equalTo(weakSelf.capLabel);
        make.right.lessThanOrEqualTo(weakSelf.totalView);
    }];
    
    [self.view addSubview:self.titleScrollView];
   
    [self.titleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.totalView.mas_bottom);
        make.height.offset(AUTOLAYOUTSIZE(54));
    }];
}

/**
 根据index显示表格view，若没添加则先创建添加
 */
- (void)showScrollViewByIndex:(NSInteger)index {
    self.currentRankView.hidden = YES; // 先隐藏其他的
    
    NSInteger tag = RANKVIEW_TAG_START + index;
    DBHRankView *rankView = [self.view viewWithTag:tag];
    if (rankView) { // 存在则只显示
        rankView.hidden = NO;
    } else { // 不存在则创建添加
        [self.view layoutIfNeeded];
        
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.titleScrollView.frame));
        
        DBHRankTitleAndDataModel *model = nil;
        if (index < self.datasArr.count) {
            model = self.datasArr[index];
        }
        rankView = [[DBHRankView alloc] initWithFrame:frame withModel:model]; // 先加载数据todo
        rankView.tag = tag;
        
        [self.view addSubview:rankView];
    }
    
    self.currentRankView = rankView;
    // 加载数据
    [self getDataByIndex:index];
}

#pragma mark ----- Get Data -------
- (void)getDataByIndex:(NSInteger)index {
    NSString *urlStr = @"token_rank/";
    switch (index) {
        case 0:
            urlStr = [urlStr stringByAppendingString:@"market_cap"];
            break;
        case 1:
            urlStr = [urlStr stringByAppendingString:@"exchanges"];
            break;
        case 2:
            urlStr = [urlStr stringByAppendingString:@"dapp"];
            break;
        case 3:
            urlStr = [urlStr stringByAppendingString:@"category"];
            break;
        case 5:
            urlStr = @"ico/total_market_value";
            break;
        default:
            urlStr = @"article?sort_desc=click_rate&per_page=50";
            break;
    }
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) responseCache:^(id responseCache) {
            [weakSelf handleReponseData:responseCache withIndex:index];
        } success:^(id responseObject) {
            [weakSelf handleReponseData:responseObject withIndex:index];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        } specialBlock:nil];
    });
}

- (void)handleReponseData:(id)responseData withIndex:(NSInteger)index {
    if ([NSObject isNulllWithObject:responseData]) {
        return;
    }
    
    if ([responseData isKindOfClass:[NSArray class]]) {
        NSArray *datas = (NSArray *)responseData;
        
        if (datas.count == 0) {
            return;
        }
        
        if ([self currentRankViewIndex] != index) {
            return;
        }
        
        switch (index) {
            case 0: { // 市值排行
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dict in datas) {
                    @autoreleasepool {
                        DBHRankMarketGainsModel *model = [DBHRankMarketGainsModel mj_objectWithKeyValues:dict];
                        [tempArr addObject:model];
                    }
                }
                
                self.gainsDatasArr = tempArr;
                break;
            }
            case 1: { // 交易所
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dict in datas) {
                    @autoreleasepool {
                        DBHExchangeRankModel *model = [DBHExchangeRankModel mj_objectWithKeyValues:dict];
                        [tempArr addObject:model];
                    }
                }
                
                self.exchangeDatasArr = tempArr;
                break;
            }
                
            case 2: { // dapp
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dict in datas) {
                    @autoreleasepool {
                        DBHDappRankModel *model = [DBHDappRankModel mj_objectWithKeyValues:dict];
                        [tempArr addObject:model];
                    }
                }
                
                self.dappDatasArr = tempArr;
                break;
            }
                
            case 3: { // inwe项目排行
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dict in datas) {
                    @autoreleasepool {
                        DBHInweProjectRankModel *model = [DBHInweProjectRankModel mj_objectWithKeyValues:dict];
                        
                        NSDictionary *category = dict[CATEGORY];
                        if (![NSObject isNulllWithObject:category]) {
                            model.projectModel = [DBHInformationModelData modelObjectWithDictionary:category];
                        }
                        [tempArr addObject:model];
                    }
                }
                
                self.inweProjectRankDatasArr = tempArr;
                break;
            }
                
            default:
                break;
        }
    } else if ([responseData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = responseData;
        
        switch (index) {
            case 4: { // 热门资讯
                DBHHotInfoRankModel *model = [DBHHotInfoRankModel mj_objectWithKeyValues:dict];
                NSMutableArray *tempArr = [NSMutableArray array];
                for (DBHHotInfoRankDataModel *dataModel in model.data) {
                    [tempArr addObject:dataModel];
                }
                
                self.hotInfoDatasArr = tempArr;
                break;
            }
                
            case 5: { // 项目总市值
                YYRankTotalMarketValueModel *model = [YYRankTotalMarketValueModel mj_objectWithKeyValues:dict];
                self.totalModel = model;
                break;
            }
        }
    }
    
}

- (NSInteger)currentRankViewIndex {
    return self.currentRankView.tag - RANKVIEW_TAG_START;
}

#pragma mark ----- Getters and Setters -----
- (void)setTotalModel:(YYRankTotalMarketValueModel *)totalModel {
    _totalModel = totalModel;
    
    self.capLabel.text = [NSString stringWithFormat:@"%@:$%.0f", DBHGetStringWithKeyFromTable(@"Market Cap", nil), totalModel.total_market_cap_by_available_supply_usd];
    self.volumeLabel.text = [NSString stringWithFormat:@"%@:$%.0f", DBHGetStringWithKeyFromTable(@"Volume (24h)", nil), totalModel.total_volume_usd];
}

- (void)setGainsDatasArr:(NSMutableArray *)gainsDatasArr {
    _gainsDatasArr = gainsDatasArr;
    
    if (self.datasArr.count > 0) {
        DBHRankTitleAndDataModel *model = self.datasArr[0];
        model.datasArr = gainsDatasArr;
    }
    
    self.currentRankView.rowDatasArray = gainsDatasArr;
}

- (void)setExchangeDatasArr:(NSMutableArray *)exchangeDatasArr {
    _exchangeDatasArr = exchangeDatasArr;
    
    if (self.datasArr.count > 1) {
        DBHRankTitleAndDataModel *model = self.datasArr[1];
        model.datasArr = exchangeDatasArr;
    }
    
    self.currentRankView.rowDatasArray = exchangeDatasArr;
}

- (void)setDappDatasArr:(NSMutableArray *)dappDatasArr {
    _dappDatasArr = dappDatasArr;
    
    if (self.datasArr.count > 2) {
        DBHRankTitleAndDataModel *model = self.datasArr[2];
        model.datasArr = dappDatasArr;
    }
    self.currentRankView.rowDatasArray = dappDatasArr;
}

- (void)setInweProjectRankDatasArr:(NSMutableArray *)inweProjectRankDatasArr {
    _inweProjectRankDatasArr = inweProjectRankDatasArr;
    
    if (self.datasArr.count > 3) {
        DBHRankTitleAndDataModel *model = self.datasArr[3];
        model.datasArr = inweProjectRankDatasArr;
    }
    self.currentRankView.rowDatasArray = inweProjectRankDatasArr;
}

- (void)setHotInfoDatasArr:(NSMutableArray *)hotInfoDatasArr {
    _hotInfoDatasArr = hotInfoDatasArr;
    
    if (self.datasArr.count > 4) {
        DBHRankTitleAndDataModel *model = self.datasArr[4];
        model.datasArr = hotInfoDatasArr;
    }
    self.currentRankView.rowDatasArray = hotInfoDatasArr;
}

- (DBHSelectScrollView *)titleScrollView  {
    if (!_titleScrollView) {
        _titleScrollView = [[DBHSelectScrollView alloc] initWithTitles:self.titlesArr currentSelectedIndex:0];
    
        WEAKSELF
        [_titleScrollView setSelectedBlock:^(int index) {
            [weakSelf showScrollViewByIndex:index];
        }];
    }
    return _titleScrollView;
}

- (NSMutableArray *)titlesArr {
    if (!_titlesArr) {
        NSMutableArray *titles = [NSMutableArray arrayWithObjects:
                                  DBHGetStringWithKeyFromTable(@" Market Cap", nil),
                                  DBHGetStringWithKeyFromTable(@" Exchange", nil),
                                  DBHGetStringWithKeyFromTable(@"Dapp", nil),
                                  DBHGetStringWithKeyFromTable(@"InWe Project Ranking", nil),
                                  DBHGetStringWithKeyFromTable(@"Hot", nil), nil];
        
        _titlesArr = titles;
    }
    return _titlesArr;
}

- (NSMutableArray *)gainsTitlesArr {
    if (!_gainsTitlesArr) {
        NSMutableArray *titles = [NSMutableArray arrayWithObjects:
                                  @"Rank",
                                  @"Volume (24h) ",
                                  @"Current Price",
                                  @"Change (24H)",
                                  @"Market Cap", nil];
        
        _gainsTitlesArr = titles;
    }
    return _gainsTitlesArr;
}

- (NSMutableArray *)exchangeTitlesArr {
    if (!_exchangeTitlesArr) {
        NSMutableArray *titles = [NSMutableArray arrayWithObjects:
                                  @"Name",
                                  @"Volume (24h) ",
                                  @"Transaction Pair",
                                  @"Transaction Type",
                                  nil];
        
        _exchangeTitlesArr = titles;
    }
    return _exchangeTitlesArr;
}

- (NSMutableArray *)dappTitlesArr {
    if (!_dappTitlesArr) {
        NSMutableArray *titles = [NSMutableArray arrayWithObjects:
                                  @"Platform",
                                  @"Revenue Summary",
                                  @"Daily Live Users",
                                  @"Volume (24h) ",
                                  @"Tx Volume(24H)",
                                  nil];
        
        _dappTitlesArr = titles;
    }
    return _dappTitlesArr;
}

- (NSMutableArray *)inweProjectRankTitlesArr {
    if (!_inweProjectRankTitlesArr) {
        NSMutableArray *titles = [NSMutableArray arrayWithObjects:
                                  @"Project ",
                                  @"Rating",
                                  @"Popular",
                                  nil];
        
        _inweProjectRankTitlesArr = titles;
    }
    return _inweProjectRankTitlesArr;
}

- (NSMutableArray *)hotInfoTitlesArr {
    if (!_hotInfoTitlesArr) {
        NSMutableArray *titles = [NSMutableArray arrayWithObjects:
                                  @"Inwe Hot",
                                  @"Popularity",
                                  nil];
        
        _hotInfoTitlesArr = titles;
    }
    return _hotInfoTitlesArr;
}

- (NSMutableArray *)datasArr {
    if (!_datasArr) {
        NSMutableArray *datas = [NSMutableArray array];
        
        DBHRankTitleAndDataModel *gainsModel = [[DBHRankTitleAndDataModel alloc] init];
        gainsModel.titlesArr = self.gainsTitlesArr;
        gainsModel.datasArr = self.gainsDatasArr;
        gainsModel.minWidth = LIST_MIN_WIDTH;
        [datas addObject:gainsModel];
        
        DBHRankTitleAndDataModel *exchangeModel = [[DBHRankTitleAndDataModel alloc] init];
        exchangeModel.titlesArr = self.exchangeTitlesArr;
        exchangeModel.datasArr = self.exchangeDatasArr;
        
        [datas addObject:exchangeModel];
        
        DBHRankTitleAndDataModel *dappModel = [[DBHRankTitleAndDataModel alloc] init];
        dappModel.titlesArr = self.dappTitlesArr;
        dappModel.datasArr = self.dappDatasArr;
        dappModel.minWidth = LIST_MIN_WIDTH;
        [datas addObject:dappModel];
        
        DBHRankTitleAndDataModel *inweProjectRankModel = [[DBHRankTitleAndDataModel alloc] init];
        inweProjectRankModel.titlesArr = self.inweProjectRankTitlesArr;
        inweProjectRankModel.datasArr = self.inweProjectRankDatasArr;
        inweProjectRankModel.minWidth = LIST_MIN_WIDTH;
        [datas addObject:inweProjectRankModel];
        
        DBHRankTitleAndDataModel *hotInfoModel = [[DBHRankTitleAndDataModel alloc] init];
        hotInfoModel.titlesArr = self.hotInfoTitlesArr;
        hotInfoModel.datasArr = self.hotInfoDatasArr;
        
        [datas addObject:hotInfoModel];
        
        _datasArr = datas;
    }
    return _datasArr;
}

- (UIView *)totalView {
    if (!_totalView) {
        _totalView = [[UIView alloc] init];
    }
    return _totalView;
}

- (UILabel *)capLabel {
    if (!_capLabel) {
        _capLabel = [UILabel new];
        _capLabel.textColor = COLORFROM16(0x666666, 1);
        _capLabel.font = FONT(12);
    }
    return _capLabel;
}

- (UILabel *)volumeLabel {
    if (!_volumeLabel) {
        _volumeLabel = [UILabel new];
        _volumeLabel.textColor = COLORFROM16(0x666666, 1);
        _volumeLabel.font = FONT(12);
    }
    return _volumeLabel;
}
@end
