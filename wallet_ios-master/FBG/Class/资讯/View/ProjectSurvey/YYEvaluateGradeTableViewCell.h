//
//  YYEvaluateGradeTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class YYEvaluateSynthesisModel;

@class DBHProjectCommentModel;

#define CELL_HIDE_HEIGHT 237
#define MYGRADEBG_HEIGHT 70

#define EVALUATE_GRADE_CELL_NAME    @"EvaluateGradeCell"
#define EVALUATE_GRADE_CELL_ID      @"EVALUATE_GRADE_CELL"

@interface YYEvaluateGradeTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) YYEvaluateSynthesisModel *model;

@property (nonatomic, strong) DBHProjectCommentModel *myCommentModel;

@end
