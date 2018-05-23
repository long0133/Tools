//
//  DBHICODistributionTableViewCell.h
//  FBG
//
//  Created by yy on 2018/3/21.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class DBHProjectDetailInformationModelData;

#define ICO_DISTRIBUTION_HEIGHT 25.0f

@interface DBHICODistributionTableViewCell : DBHBaseTableViewCell

/**
 项目信息
 */
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;

@end
