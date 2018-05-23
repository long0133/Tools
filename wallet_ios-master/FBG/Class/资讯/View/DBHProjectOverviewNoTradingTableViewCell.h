//
//  DBHProjectOverviewNoTradingTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHProjectDetailInformationModelData;

@interface DBHProjectOverviewNoTradingTableViewCell : DBHBaseTableViewCell

/**
 项目信息
 */
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;

@end
