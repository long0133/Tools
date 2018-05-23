//
//  YYEvaluateTableView.h
//  CSJF
//
//  Created by cqdingwei@163.com on 2017/5/18.
//  Copyright © 2017年 dingwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultstageScrollViewHeader.h"
#import "DBHProjectSurveyViewController.h"
#import "YYEvaluateTagsData.h"
#import "YYEvaluateTagTableViewCell.h"
@class DBHProjectCommentModel;
@class YYComentDetailListModel;

@class YYEvaluateSynthesisModel;
@class DBHProjectDetailInformationModelData;

typedef void(^SelectedTagViewBlock)(NSInteger index);
typedef void(^ShowHeaderBlock)(BOOL isShow);

@interface YYEvaluateTableView : UITableView

@property (nonatomic, assign) OffsetType offsetType;

@property (nonatomic, weak) DBHProjectSurveyViewController *mainVC;
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;
@property (nonatomic, strong) YYEvaluateSynthesisModel *model;
@property (nonatomic, strong) YYEvaluateTagsData *tagsData;
@property (nonatomic, strong) DBHProjectCommentModel *myCommentModel;
@property (nonatomic, strong) YYComentDetailListModel *commmentsModel;

@property (nonatomic, copy) SelectedTagViewBlock tagBlock;
@property (nonatomic, copy) ShowHeaderBlock showBlock;

@property (nonatomic, strong) NSArray *analysisArray;
@property (nonatomic, copy) SelectedDayOrWeekBlock selectBlock;
@property (nonatomic, copy) SelectedRecommendBlock commentBlock; // 选中了哪天的评价

@property (nonatomic, assign) NSInteger currentSelectedTagIndex;

@end
