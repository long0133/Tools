//
//  YYProjectSurveySection1TableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/6.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
#import "YYSurveyInfoTableView.h"
#import "YYEvaluateTableView.h"
#import "DBHProjectDetailInformationDataModels.h"
#import "YYSurveyWebTableView.h"

@class DBHProjectSurveyViewController;

@interface YYProjectSurveySection1TableViewCell : DBHBaseTableViewCell
   
@property (nonatomic, strong, readonly) UIScrollView *subScrollView;
@property (nonatomic, weak) DBHProjectSurveyViewController *mainVC;
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;
@property (nonatomic, strong, readonly) YYEvaluateTableView *evaluateTableView;
@property (nonatomic, strong, readonly) YYSurveyInfoTableView *infoTableView;
@property (nonatomic, strong, readonly) YYSurveyWebTableView *webView;

@end
