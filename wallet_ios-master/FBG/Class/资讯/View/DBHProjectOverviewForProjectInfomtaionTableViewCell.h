//
//  DBHProjectOverviewForProjectInfomtaionTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class YYEvaluateSynthesisModel;

@class DBHProjectDetailInformationModelData;

@interface DBHProjectOverviewForProjectInfomtaionTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;
@property (nonatomic, strong) YYEvaluateSynthesisModel *model;

@end
