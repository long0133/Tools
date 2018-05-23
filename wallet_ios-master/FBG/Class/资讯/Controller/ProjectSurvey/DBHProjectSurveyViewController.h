//
//  DBHProjectSurveyViewController.h
//  FBG
//
//  Created by yy on 2018/4/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"
#import "MultstageScrollViewHeader.h"

#define PROJECTSURVEY_STORYBOARD_NAME @"ProjectSurvey"

@class DBHProjectDetailInformationModelData;

@interface DBHProjectSurveyViewController : DBHBaseViewController

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) OffsetType offsetType;
/**
 项目详细信息
 */
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;

@end
