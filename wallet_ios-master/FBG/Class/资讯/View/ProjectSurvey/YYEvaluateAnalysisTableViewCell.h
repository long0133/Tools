//
//  YYEvaluateAnalysisTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
#import "NSDate+Tool.h"
@class YYEvaluateDetailAnalysisModel;

#define EVALUATE_ANALYSIS_CELL_ID @"EVALUATE_ANALYSIS_CELL"

typedef void(^SelectedItemBlock) (NSInteger num, NSInteger type, NSString *dateStr);

@interface YYEvaluateAnalysisTableViewCell : DBHBaseTableViewCell

@property (nonatomic, copy) SelectedItemBlock selectedBlock;
- (void)setModel:(YYEvaluateDetailAnalysisModel *)model withMax:(NSInteger)max;

@end
