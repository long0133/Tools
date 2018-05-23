//
//  YYRecommendScaleTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class YYEvaluateSynthesisModel;

#define RECOMMEND_SCALE_CELL_NAME @"RecommendScaleCell"
#define RECOMMEND_SCALE_CELL_ID @"RECOMMEND_SCALE_CELL"

@interface YYRecommendScaleTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) YYEvaluateSynthesisModel *model;

@end
