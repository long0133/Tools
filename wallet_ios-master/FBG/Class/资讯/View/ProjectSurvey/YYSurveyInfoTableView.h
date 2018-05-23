//
//  YYSurveyInfoTableView.h
//  CSJF
//
//  Created by cqdingwei@163.com on 2017/5/18.
//  Copyright © 2017年 dingwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultstageScrollViewHeader.h"
#import "DBHProjectSurveyViewController.h"
@class DBHProjectDetailInformationModelData;

@interface YYSurveyInfoTableView : UITableView

@property (nonatomic, assign) OffsetType offsetType;

@property (nonatomic, weak) DBHProjectSurveyViewController *mainVC;
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;

@end
