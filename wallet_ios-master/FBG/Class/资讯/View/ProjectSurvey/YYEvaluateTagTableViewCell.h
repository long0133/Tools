//
//  YYEvaluateTagTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
#import "D5FlowButtonView.h"
#import "YYEvaluateTagModel.h"
@class YYEvaluateTagsData;

#define TOP_DEFAULT_HEIGHT 89
#define CHART_BGVIEW_DEFAULT_HEIGHT 273

#define EVALUATE_TAG_CELL_ID @"EVALUATE_TAG_CELL"

typedef void(^ClickHideChartBlock)(BOOL isHide);
typedef void(^SelectedDayOrWeekBlock)(NSInteger index);
typedef void(^SelectedRecommendBlock)(NSString *startDate, NSInteger type); //type == 1 不推荐

@interface YYEvaluateTagTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) NSMutableArray *analysisArray;
@property (nonatomic, copy) ClickHideChartBlock clickBlock;
@property (nonatomic, copy) SelectedDayOrWeekBlock selectBlock;
@property (nonatomic, copy) SelectedRecommendBlock commentBlock; // 选中了哪天的评价

/**
 *  设置cell中的控件的值
 *
 *  @param tagsData 数据
 *  @param delegate 控件中按钮的点击事件的响应者
 */
- (void)setTagsData:(YYEvaluateTagsData *)tagsData withDelegate:(id<D5FlowButtonViewDelegate>)delegate;

@end
