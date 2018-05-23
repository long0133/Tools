//
//  DBHProjectSurveyScrollTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class DBHProjectDetailInformationModelData;

@interface DBHProjectSurveyScrollTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;
@property (nonatomic, assign) NSInteger currentSelectedIndex;

@end
