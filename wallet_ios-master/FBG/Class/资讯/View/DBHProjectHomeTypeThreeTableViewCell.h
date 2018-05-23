//
//  DBHProjectHomeTypeThreeTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/2/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHProjectHomeNewsModelData;

@interface DBHProjectHomeTypeThreeTableViewCell : DBHBaseTableViewCell

/**
 项目资讯数据
 */
@property (nonatomic, strong) DBHProjectHomeNewsModelData *model;

@end
