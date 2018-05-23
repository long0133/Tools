//
//  DBHIotificationTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHProjectHomeNewsModelData;

@interface DBHIotificationTableViewCell : DBHBaseTableViewCell

/**
 公告信息
 */
@property (nonatomic, strong) DBHProjectHomeNewsModelData *model;

/**
 聊天消息
 */
@property (nonatomic, strong) EMMessage *message;

@end
