//
//  YYSurveyWebTableView.h
//  ToolsDemoByYangBo
//
//  Created by cqdingwei@163.com on 17/3/8.
//  Copyright © 2017年 yangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultstageScrollViewHeader.h"
#import "DBHProjectSurveyViewController.h"
@class DBHProjectDetailInformationModelData;

@interface YYSurveyWebTableView : UITableView

@property (nonatomic, assign) OffsetType offsetType;

@property (nonatomic, weak) DBHProjectSurveyViewController *mainVC;
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;

@end
