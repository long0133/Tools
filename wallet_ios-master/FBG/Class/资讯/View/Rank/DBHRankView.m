//
//  DBHRankView.m
//  FBG
//
//  Created by yy on 2018/3/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHRankView.h"
#import "JJStockView.h"
#import "DBHRankMarketGainsModel.h"
#import "DBHRankTitleAndDataModel.h"
#import "DBHRankListHeaderView.h"
#import "DBHRankDetailViewController.h"
#import "DBHExchangeRankModel.h"
#import "DBHExchangeRankTypeModel.h"
#import "DBHDappRankModel.h"
#import "DBHInweProjectRankModel.h"
#import "DBHProjectHomeViewController.h"
#import "DBHHotInfoRankModel.h"

#define HEADERVIEW_TAG_START 3000
#define HOTINFO_LIST_BUTTON_TAG_START 100

#define ROW_HEADER_VIEW_HEIGHT 40
#define CONTENT_VIEW_HEIGHT 60

#define DAPP_UNIT @"ETH"

@interface DBHRankView() <StockViewDelegate, StockViewDataSource>

/**
 第一行标题的title数组
 */
@property (nonatomic, strong) NSArray *rowHeaderTitlesArray;


@property (nonatomic, strong) JJStockView *stockView;

@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) NSDictionary *currentSelectedObj; // 当前选中的 （key : 当前selectedIndex  value:排序顺序）

@property (nonatomic, assign) CGFloat minWidth;

@end

@implementation DBHRankView

#pragma mark ----- Life Cycle -----
- (instancetype)initWithFrame:(CGRect)frame withModel:(DBHRankTitleAndDataModel *)model {
    if (self = [super initWithFrame:frame]) {
        _rowDatasArray = model.datasArr;
        _rowHeaderTitlesArray = model.titlesArr;
        _minWidth = model.minWidth;
        
        [self setUI];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) { // 销毁
        [self setDelegateToNil];
    }
}

- (void)layoutSubviews {
    NSInteger currentRankViewIndex = [self indexForRankView];
    switch (currentRankViewIndex) {
        case 0:
            self.currentSelectedIndex = 0;
            break;
            
        default:
            self.currentSelectedIndex = 1;
            break;
    }
}

#pragma mark ----- UI -----
- (void)setUI {
    [self addSubview:self.stockView];
}

- (void)setDelegateToNil {
    if (self.stockView) {
        if (self.stockView.delegate) {
            self.stockView.delegate = nil;
        }
        
        if (self.stockView.dataSource) {
            self.stockView.dataSource = nil;
        }
    }
}

#pragma mark ------ push vc -------
- (void)pushToInweProjectVC:(NSInteger)row {
    DBHProjectHomeViewController *projectHomeViewController = [[DBHProjectHomeViewController alloc] init];
    if (row < self.rowDatasArray.count) {
        DBHInweProjectRankModel *model = self.rowDatasArray[row];
        DBHInformationModelData *data = model.projectModel;
        projectHomeViewController.projectModel = data;
    }

    [[self parentController].navigationController pushViewController:projectHomeViewController animated:YES];
}

- (void)pushToRankDetailVC:(NSInteger)row {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:RANKDETAIL_STORYBOARD_NAME bundle:nil];
    DBHRankDetailViewController *vc = [sb instantiateViewControllerWithIdentifier:RANKDETAIL_STORYBOARD_ID];
    
    if (row < self.rowDatasArray.count) {
        DBHRankMarketGainsModel *model = self.rowDatasArray[row];
        vc.model = model;
    }
    [[self parentController].navigationController pushViewController:vc animated:YES];
}

- (void)pushToExchangeVC:(NSInteger)row {
    if (row < self.rowDatasArray.count) {
        DBHExchangeRankModel *model = self.rowDatasArray[row];
        
        KKWebView *webView = [[KKWebView alloc] initWithUrl:model.website];
        webView.title = model.name;
        [[self parentController].navigationController pushViewController:webView animated:YES];
    }
}

- (void)pushToDappVC:(NSInteger)row {
    if (row < self.rowDatasArray.count) {
        DBHDappRankModel *model = self.rowDatasArray[row];
        
        KKWebView *webView = [[KKWebView alloc] initWithUrl:model.url];
        webView.title = model.title;
        [[self parentController].navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark ------ responds --------
- (void)respondsToHotInfoButton:(UIButton *)sender {
    NSInteger row = sender.tag - HOTINFO_LIST_BUTTON_TAG_START;
    if ((row < self.rowDatasArray.count)) {
        DBHHotInfoRankDataModel *model = self.rowDatasArray[row];
        KKWebView *webView = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD4 : TESTAPIEHEAD4, model.data_id]];
        webView.title = model.title;
        webView.imageStr = model.img;
        webView.isHaveShare = YES;
        webView.infomationId = [NSString stringWithFormat:@"%@", model.data_id];
        [[self parentController].navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark ----- StockView Delegate -----
// 总行数
- (NSUInteger)countForStockView:(JJStockView *)stockView {
    return self.rowDatasArray.count;
}

//列表头
- (UIView *)titleCellForStockView:(JJStockView *)stockView atRowPath:(NSUInteger)row {
    if (row < self.rowDatasArray.count) {
        CGFloat width = [self rowHeaderViewWidthByIndex:0];
        NSInteger currentRankViewIndex = [self indexForRankView];
        switch (currentRankViewIndex) {
            case 0: {
                DBHRankMarketGainsModel *model = self.rowDatasArray[row];
                DBHRankListHeaderView *listHeaderView = [[DBHRankListHeaderView alloc] initWithRank:model.rank icon:model.img first:model.symbol second:nil third:model.key];
                WEAKSELF
                [listHeaderView setClickBlock:^(UIButton *btn) {
                    [weakSelf pushToRankDetailVC:row];
                }];
                listHeaderView.frame = CGRectMake(0, 0, width, AUTOLAYOUTSIZE(CONTENT_VIEW_HEIGHT));
                return listHeaderView;
                break;
            }
            case 1: { // 交易所
                DBHExchangeRankModel *model = self.rowDatasArray[row];
                DBHRankListHeaderView *listHeaderView = [[DBHRankListHeaderView alloc] initWithRank:[NSString stringWithFormat:@"%.02d", (int)row + 1] icon:nil first:model.name second:nil third:nil];
                WEAKSELF
                [listHeaderView setClickBlock:^(UIButton *btn) {
                    [weakSelf pushToExchangeVC:row];
                }];
                listHeaderView.frame = CGRectMake(0, 0, width, AUTOLAYOUTSIZE(CONTENT_VIEW_HEIGHT));
                return listHeaderView;
                break;
            }
            case 2: { //DAPP
                DBHDappRankModel *model = self.rowDatasArray[row];
                DBHRankListHeaderView *listHeaderView = [[DBHRankListHeaderView alloc] initWithRank:[NSString stringWithFormat:@"%.02d", (int)row + 1] icon:nil first:model.title second:nil third:model.category];
                WEAKSELF
                [listHeaderView setClickBlock:^(UIButton *btn) {
                    [weakSelf pushToDappVC:row];
                }];
                listHeaderView.frame = CGRectMake(0, 0, width, AUTOLAYOUTSIZE(CONTENT_VIEW_HEIGHT));
                return listHeaderView;
                break;
            }
            case 3: { //inwe项目排行
                DBHInweProjectRankModel *model = self.rowDatasArray[row];
                DBHRankListHeaderView *listHeaderView = [[DBHRankListHeaderView alloc] initWithRank:[NSString stringWithFormat:@"%.02d", (int)row + 1] icon:model.img first:model.name second:model.long_name third:model.industry];
                WEAKSELF
                [listHeaderView setClickBlock:^(UIButton *btn) {
                    [weakSelf pushToInweProjectVC:row];
                }];
                listHeaderView.frame = CGRectMake(0, 0, width, AUTOLAYOUTSIZE(CONTENT_VIEW_HEIGHT));
                return listHeaderView;
                break;
            }
            case 4: { // 热门资讯
                DBHHotInfoRankDataModel *model = self.rowDatasArray[row];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 0, width, AUTOLAYOUTSIZE(CONTENT_VIEW_HEIGHT));
                [btn setTitleColor:COLORFROM16(0X8B8B8B, 1) forState:UIControlStateNormal];
                btn.titleLabel.font = FONT(14);
                btn.tag = HOTINFO_LIST_BUTTON_TAG_START + row;
                [btn addTarget:self action:@selector(respondsToHotInfoButton:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:model.title forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 10);
                return btn;
                break;
            }
        }
    }
    return nil;
}

// 内容cell
- (UIView *)contentCellForStockView:(JJStockView *)stockView atRowPath:(NSUInteger)row {
    CGFloat totalWidth = [self totalWidthForRowHeaderView];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, AUTOLAYOUTSIZE(CONTENT_VIEW_HEIGHT))];
    
    CGFloat fontSize = 14;
    for (int i = 1; i < self.rowHeaderTitlesArray.count; i ++) { //i是列索引 TODO
        UIView *lastView = nil;
        if (i > 1) {
            lastView = bg.subviews.lastObject;
        }
        
        UIView *view = [[UIView alloc] init];
        CGFloat width = [self rowHeaderViewWidthByIndex:i];
        
        CGFloat x = lastView ? CGRectGetMaxX(lastView.frame) : 0;
        view.frame = CGRectMake(x, 0, width, AUTOLAYOUTSIZE(CONTENT_VIEW_HEIGHT));
        [bg addSubview:view];
        UILabel *label = [[UILabel alloc] init];
        
        NSString *content = nil;
        UIColor *textColor = COLORFROM16(0x8B8B8B, 1);
        UIColor *backGroundColor = [UIColor clearColor];
        if (row < self.rowDatasArray.count) {
            id obj = self.rowDatasArray[row];
            if ([obj isKindOfClass:[DBHRankMarketGainsModel class]]) { // 市值涨幅
                DBHRankMarketGainsModel *model = obj;
                
                int decimal = [self isCny] ? 8 : 9;
                if (i == 1) { // 交易量
                    double value = [self isCny] ? model.volume_cny.doubleValue : model.volume.doubleValue;
                    
                    NSString *first = [NSString stringWithFormat:@"%@", @(value)];
                    NSString *second = [NSString stringWithFormat:@"%@", @(pow(10, decimal))];
                    NSString *result = [NSString DecimalFuncWithOperatorType:3 first:first secend:second value:8];
                    
                    content = [self isCny] ? [NSString stringWithFormat:@"￥%.02f亿", result.doubleValue] : [NSString stringWithFormat:@"$%.02fBillion", result.doubleValue];
                } else if (i == 2) { // 当前价格
                    content = [self isCny] ? [NSString stringWithFormat:@"￥%.02f", model.price_cny.doubleValue] : [NSString stringWithFormat:@"$%.02f", model.price.doubleValue];
                } else if (i == 3) { // 涨跌幅
                    CGFloat value = model.change.doubleValue;
                    if (value >= 0) {
                        content = [NSString stringWithFormat:@"+%.02f%%", value];
                        backGroundColor = COLORFROM16(0x3CA316, 1);
                    } else {
                        content = [NSString stringWithFormat:@"%.02f%%", value];
                        backGroundColor = MAIN_ORANGE_COLOR;
                    }
                    textColor = WHITE_COLOR;
                    label.layer.cornerRadius = 3;
                    label.layer.masksToBounds = YES;
                } else {    // 市值
                    double value = [self isCny] ? model.market_cny.doubleValue : model.market.doubleValue;
                    
                    NSString *first = [NSString stringWithFormat:@"%@", @(value)];
                    
                    NSString *second = [NSString stringWithFormat:@"%@", @(pow(10, decimal))];
                    NSString *result = [NSString DecimalFuncWithOperatorType:3 first:first secend:second value:8];
                    
                    content = [self isCny] ? [NSString stringWithFormat:@"￥%.02f亿", result.doubleValue] : [NSString stringWithFormat:@"$%.02fBillion", result.doubleValue];
                }
            } else if ([obj isKindOfClass:[DBHExchangeRankModel class]]) { // 交易所
                DBHExchangeRankModel *model = obj;
                if (i == 1) { // 交易量
                    double value = [self isCny] ? model.volume_cny.doubleValue : model.volume.doubleValue;
                    
                    NSString *first = [NSString stringWithFormat:@"%@", @(value)];
                    NSString *second = [NSString stringWithFormat:@"%@", @(pow(10, 8))];
                    NSString *result = [NSString DecimalFuncWithOperatorType:3 first:first secend:second value:8];
                    
                    content = [self isCny] ? [NSString stringWithFormat:@"￥%.02f亿", result.doubleValue] : [NSString stringWithFormat:@"$%.02fBillion", result.doubleValue];
                } else if (i == 2) { // 交易对
                    content = [NSString stringWithFormat:@"%@", @(model.trade_ratio.integerValue)];
                } else if (i == 3) { // Transaction Type
                    NSArray *types = [self isCny] ? model.type.zh : model.type.en;
                    NSString *result = @"";
                    if (types.count == 0) {
                        result = @"-";
                    } else {
                        for (int j = 0; j < types.count; j ++) {
                            result = [result stringByAppendingString:types[j]];
                            if (j != types.count - 1) {
                                result = [result stringByAppendingString:@"、"];
                            }
                        }
                    }
                    
                    content = result;
                }
            } else if ([obj isKindOfClass:[DBHDappRankModel class]]) { // DAPP
                DBHDappRankModel *model = obj;
                if (i == 1) { // Revenue Summary
                    content = [NSString getDealNumwithstring:model.balance];
                    content = [NSString stringWithFormat:@"%@%@", content, DAPP_UNIT];
                } else if (i == 2) { // Daily Live Users
                    content =  model.dauLastDay;
                } else if (i == 3) { // 交易量
                    content = [NSString getDealNumwithstring:model.volumeLastDay];
                    content = [NSString stringWithFormat:@"%@%@", content, DAPP_UNIT];
                } else { // tx量
                    content = model.txLastDay;
                }
            } else if ([obj isKindOfClass:[DBHInweProjectRankModel class]]) { // inwe项目排行
                DBHInweProjectRankModel *model = obj;
                if (i == 1) { // 项目评分
                    content = [NSString stringWithFormat:@"%.01f%@", model.score.doubleValue, DBHGetStringWithKeyFromTable(@"", nil)];
                } else if (i == 2) { // 关注热度
                    content = [NSString stringWithFormat:@"#%@", model.rank];
                }
            } else if ([obj isKindOfClass:[DBHHotInfoRankDataModel class]]) {
                DBHHotInfoRankDataModel *model = obj;
                content = [NSString stringWithFormat:@"%@", @(model.click_rate)];
            }
        }
        label.font = [UIFont systemFontOfSize:fontSize];
        label.text = content;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = textColor;
        label.backgroundColor = backGroundColor;
        CGFloat labelWidth = [NSString getWidthtWithString:content fontSize:fontSize] + 4;
        CGFloat labelHeight = [NSString getHeightWithString:content width:labelWidth lineSpacing:0 fontSize:fontSize] + 6;
        
        x = (width - labelWidth) / 2;
        CGFloat y = (CGRectGetHeight(view.frame) - labelHeight) / 2;
        label.frame = CGRectMake(x, y, labelWidth, labelHeight);
        
        [view addSubview:label];
    }
    return bg;
}

- (CGFloat)heightForCell:(JJStockView *)stockView atRowPath:(NSUInteger)row {
    return AUTOLAYOUTSIZE(CONTENT_VIEW_HEIGHT);
}

// 左上角标题cell
- (UIView *)headRegularTitle:(JJStockView *)stockView {
    if (self.rowHeaderTitlesArray.count > 0) {
        
        NSInteger currentRankViewIndex = [self indexForRankView];
        BOOL isCanClick = NO;
        if (currentRankViewIndex == 0) {
            isCanClick = YES;
        }
        
        CGFloat width = [self rowHeaderViewWidthByIndex:0];
        CGRect frame = CGRectMake(0, 0, width, AUTOLAYOUTSIZE(ROW_HEADER_VIEW_HEIGHT));
        BOOL isShowLine = YES;
        if (currentRankViewIndex == 4) {
            isShowLine = NO;
        }
        DBHRankRowHeaderView *headerView = [[DBHRankRowHeaderView alloc] initWithFrame:frame title:self.rowHeaderTitlesArray[0] isCanClick:isCanClick isShowLine:isShowLine index:currentRankViewIndex isFirst:YES];
        
        headerView.tag = HEADERVIEW_TAG_START;
        if (self.currentSelectedIndex == 0 && currentRankViewIndex == 0) {
            NSString *key = [NSString stringWithFormat:@"%@", @(0)];
            NSNumber *value = self.currentSelectedObj[key];
            
            NSInteger ordered = value.integerValue;
            [headerView setSelected:YES ordered:ordered];
        }
        
        WEAKSELF
        [headerView setClickBlock:^(UIButton *btn) {
            [weakSelf handleClickEvent:btn index:0];
        }];
        return headerView;
    }
    return nil;
}

// 行标题
- (UIView *)headTitle:(JJStockView *)stockView {
    CGFloat totalWidth = [self totalWidthForRowHeaderView];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, AUTOLAYOUTSIZE(40))];
    for (int i = 1; i < self.rowHeaderTitlesArray.count; i ++) {
        DBHRankRowHeaderView *lastView = nil;
        if (i > 1) {
            lastView = bg.subviews.lastObject;
        }
        
        CGFloat width = [self rowHeaderViewWidthByIndex:i];
        
        CGFloat x = lastView ? CGRectGetMaxX(lastView.frame) : 0;
        CGRect frame = CGRectMake(x, 0, width, AUTOLAYOUTSIZE(ROW_HEADER_VIEW_HEIGHT));
        BOOL isCanClick = YES;
        
        NSInteger currentRankViewIndex = [self indexForRankView];
        if (currentRankViewIndex == 1 || currentRankViewIndex == 4) {
            isCanClick = NO;
        }
        
        DBHRankRowHeaderView *headerView = [[DBHRankRowHeaderView alloc] initWithFrame:frame title:self.rowHeaderTitlesArray[i] isCanClick:isCanClick isShowLine:NO index:currentRankViewIndex isFirst:NO];
        
        headerView.tag = HEADERVIEW_TAG_START + i;
        
        if (self.currentSelectedIndex == i && (currentRankViewIndex != 1 && currentRankViewIndex != 4)) {
            NSString *key = [NSString stringWithFormat:@"%@", @(i)];
            NSNumber *value = self.currentSelectedObj[key];
            
            NSInteger ordered = value.integerValue;
            [headerView setSelected:YES ordered:ordered];
        }
       
        WEAKSELF
        [headerView setClickBlock:^(UIButton *btn) {
            [weakSelf handleClickEvent:btn index:i];
        }];
        [bg addSubview:headerView];
    }
    return bg;
}

- (CGFloat)heightForHeadTitle:(JJStockView*)stockView{
    return AUTOLAYOUTSIZE(ROW_HEADER_VIEW_HEIGHT);
}

#pragma mark ------- handle data ---------
- (void)handleClickEvent:(UIButton *)sender index:(NSInteger)index {
    if (self.rowDatasArray.count == 0) {
        return;
    }
    
    NSInteger currentRankViewIndex = [self indexForRankView];
    if (index == self.currentSelectedIndex) { //正倒序
        NSString *key = [NSString stringWithFormat:@"%@", @(self.currentSelectedIndex)];
        NSNumber *value = self.currentSelectedObj[key];
        
        NSInteger ordered = 1;
        if (value.integerValue == 1) { // 之前正序 则倒序
            ordered = -1;
        }
        
        [sender setImage:[UIImage imageNamed:ordered == 1 ? @"paixu_icon_as" : @"paixu_icon_des"] forState:UIControlStateSelected];
        
        if (currentRankViewIndex == 0) {
            [self sortedGainDatasArrayByIndex:index ordered:ordered];
        } else if (currentRankViewIndex == 2) {
            [self sortedDappDatasArrayByIndex:index ordered:ordered];
        } else if (currentRankViewIndex == 3) {
            [self sortedInweDatasArrayByIndex:index ordered:ordered];
        }
        
        self.currentSelectedObj = @{key : @(ordered)};
    } else {
        DBHRankRowHeaderView *lastSelectedHeaderView = [self viewWithTag:HEADERVIEW_TAG_START + self.currentSelectedIndex];
        [lastSelectedHeaderView setSelected:NO ordered:0];
        
        sender.selected = YES;
        self.currentSelectedIndex = index;
        
        NSString *key = [NSString stringWithFormat:@"%@", @(self.currentSelectedIndex)];
        self.currentSelectedObj = @{key : @1};
        
        [sender setImage:[UIImage imageNamed:@"paixu_icon_as"] forState:UIControlStateSelected];
        
        if (index < self.rowHeaderTitlesArray.count) {
            if (currentRankViewIndex == 0) {
                [self sortedGainDatasArrayByIndex:index ordered:1];
            } else if (currentRankViewIndex == 2) {
                [self sortedDappDatasArrayByIndex:index ordered:1];
            } else if (currentRankViewIndex == 3) {
                [self sortedInweDatasArrayByIndex:index ordered:1];
            }
        }
    }
}


/**
 根据点击的行标题index来给市值排名datas排序
 
 @param index 当前点击的index
 @param ordered 排序的顺序：从大到小 -- 1  从小到大 --- -1
 */
- (void)sortedGainDatasArrayByIndex:(NSInteger)index ordered:(NSInteger)ordered {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        NSComparator finderSort = ^(DBHRankMarketGainsModel *model1, DBHRankMarketGainsModel *model2) {
            NSComparisonResult result = NSOrderedSame;
            switch (index) {
                case 0: { // 按市值排名排序
                    result = [weakSelf compareResultByString:model2.rank withString:model1.rank ordered:ordered];
                    break;
                }
                case 1: { // 按交易量排序
                    if ([weakSelf isCny]) {
                        result = [weakSelf compareResultByString:model1.volume_cny withString:model2.volume_cny ordered:ordered];
                    } else {
                        result = [weakSelf compareResultByString:model1.volume withString:model2.volume ordered:ordered];
                    }
                    break;
                }
                case 2: { // 按当前价格排序
                    if ([weakSelf isCny]) {
                        result = [weakSelf compareResultByString:model1.price_cny withString:model2.price_cny ordered:ordered];
                    } else {
                        result = [weakSelf compareResultByString:model1.price withString:model2.price ordered:ordered];
                    }
                    break;
                }
                case 3: { // 按涨跌幅排序
                    result = [weakSelf compareResultByString:model1.change withString:model2.change ordered:ordered];
                    break;
                }
                default: { // 按市值排序
                    if ([weakSelf isCny]) {
                        result = [weakSelf compareResultByString:model1.market_cny withString:model2.market_cny ordered:ordered];
                    } else {
                        result = [weakSelf compareResultByString:model1.market withString:model2.market ordered:ordered];
                    }
                    break;
                }
            }
            return result;
        };
        
        NSArray *resultArray = [self.rowDatasArray sortedArrayUsingComparator:finderSort];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rowDatasArray = [NSMutableArray arrayWithArray:resultArray];
        });
    });
}

/**
 根据点击的行标题index来给dapp datas排序
 
 @param index 当前点击的index
 @param ordered 排序的顺序：从大到小 -- 1  从小到大 --- -1
 */
- (void)sortedDappDatasArrayByIndex:(NSInteger)index ordered:(NSInteger)ordered {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        NSComparator finderSort = ^(DBHDappRankModel *model1, DBHDappRankModel *model2) {
            NSComparisonResult result = NSOrderedSame;
            switch (index) {
                case 1: { // Revenue Summary
                    result = [weakSelf compareResultByString:model1.balance withString:model2.balance ordered:ordered];
                    break;
                }
                case 2: { // Daily Live Users
                    result = [weakSelf compareResultByString:model1.dauLastDay withString:model2.dauLastDay ordered:ordered];
                    break;
                }
                case 3: { // 交易量
                    result = [weakSelf compareResultByString:model1.volumeLastDay withString:model2.volumeLastDay ordered:ordered];
                    break;
                }
                case 4: { // 按tx
                    if ([weakSelf isCny]) {
                        result = [weakSelf compareResultByString:model1.txLastDay withString:model2.txLastDay ordered:ordered];
                        break;
                    }
                }
            }
            return result;
        };
            
        NSArray *resultArray = [self.rowDatasArray sortedArrayUsingComparator:finderSort];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rowDatasArray = [NSMutableArray arrayWithArray:resultArray];
        });
    });
}

/**
 根据点击的行标题index来给inwe datas排序
 
 @param index 当前点击的index
 @param ordered 排序的顺序：从大到小 -- 1  从小到大 --- -1
 */
- (void)sortedInweDatasArrayByIndex:(NSInteger)index ordered:(NSInteger)ordered {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        NSComparator finderSort = ^(DBHInweProjectRankModel *model1, DBHInweProjectRankModel *model2) {
            NSComparisonResult result = NSOrderedSame;
            switch (index) {
                case 1: { // 项目评分
                    result = [weakSelf compareResultByString:model1.score withString:model2.score ordered:ordered];
                    break;
                }
                case 2: { // 关注热度
                    result = [weakSelf compareResultByString:model1.rank withString:model2.rank ordered:ordered];
                    break;
                }
            }
            return result;
        };
        
        NSArray *resultArray = [self.rowDatasArray sortedArrayUsingComparator:finderSort];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rowDatasArray = [NSMutableArray arrayWithArray:resultArray];
        });
    });
}

/**
从大到小排序

 @param str1 str1
 @param str2 str2
 @param ordered 排序的顺序：从大到小 -- 1  从小到大 --- -1
 @return 排序结果
 */
- (NSComparisonResult)compareResultByString:(NSString *)str1 withString:(NSString *)str2 ordered:(NSInteger)ordered {
    NSComparisonResult result = NSOrderedSame;
    if (str1.doubleValue < str2.doubleValue) {
        if (ordered == 1) {
            result = (NSComparisonResult)NSOrderedDescending;
        } else if (ordered == -1) {
            result = (NSComparisonResult)NSOrderedAscending;
        }
    } else if (str1.doubleValue > str2.doubleValue){
        if (ordered == 1) {
            result = (NSComparisonResult)NSOrderedAscending;
        } else if (ordered == -1) {
            result = (NSComparisonResult)NSOrderedDescending;
        }
    } else {
        result = (NSComparisonResult)NSOrderedSame;
    }
    return result;
}

#pragma mark ------- Private method ---------
/**
 货币单位是否是人民币

 @return 是否是人民币
 */
- (BOOL)isCny {
    return [UserSignData share].user.walletUnitType == 1;
}

- (NSInteger)indexForRankView {
    return self.tag - RANKVIEW_TAG_START;
}

/**
 获取index列的宽度

 @param index 列
 @return 宽度
 */
- (CGFloat)rowHeaderViewWidthByIndex:(NSInteger)index {
    CGFloat width = 0;
    if (index < self.rowHeaderTitlesArray.count) {
        NSInteger currentRankViewIndex = [self indexForRankView];
        if (currentRankViewIndex == 4) {
            if (index == 0) {
                width = CGRectGetWidth(self.frame) * 0.8;
            } else {
                width = CGRectGetWidth(self.frame) * 0.2;
            }
        } else {
            width = [NSString getWidthtWithString:self.rowHeaderTitlesArray[index] fontSize:BUTTON_FONT_SIZE] + 20;
            if (index == 0) {
                width = AUTOLAYOUTSIZE(MAX(width, (self.minWidth == 0 ? kHeaderViewWidth : self.minWidth)));
            } else {
                width = AUTOLAYOUTSIZE(MAX(width, kHeaderViewWidth));
            }
            
            width = AUTOLAYOUTSIZE(width);
        }
    }
    return width;
}

/**
 从第二列开始到最后一列的总宽度

 @return 总宽度
 */
- (CGFloat)totalWidthForRowHeaderView {
    CGFloat width = 0;
    for (int i = 1; i < self.rowHeaderTitlesArray.count; i ++) {
        CGFloat singleWidth = [self rowHeaderViewWidthByIndex:i];
        width += singleWidth;
    }
    return width;
}

#pragma mark ------ Getters And Setters --------
- (void)setRowDatasArray:(NSArray *)rowDatasArray {
    _rowDatasArray = rowDatasArray;
    
    [self.stockView reloadStockView];
}

- (JJStockView *)stockView {
    if (!_stockView) {
        _stockView = [[JJStockView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _stockView.delegate = self;
        _stockView.dataSource = self;
    }
    return _stockView;
}

- (NSDictionary *)currentSelectedObj {
    if (!_currentSelectedObj) {
        _currentSelectedObj = @{[NSString stringWithFormat:@"%@", @(self.currentSelectedIndex)] : @(1)};
    }
    return _currentSelectedObj;
}
@end
