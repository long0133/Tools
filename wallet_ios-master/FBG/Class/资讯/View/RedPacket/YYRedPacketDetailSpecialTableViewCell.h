//
//  YYRedPacketDetailSpecialTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

#define REDPACKET_DETAIL_SPECIAL_CELL_ID @"REDPACKET_DETAIL_SPECIAL_CELL"
#define REDPACKET_DETAIL_SPECIAL_CELL_HEIGHT 399

typedef void(^LookClickBlock) (RedBagStatus status);

@interface YYRedPacketDetailSpecialTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) YYRedPacketDetailModel *model;
@property (nonatomic, copy) LookClickBlock block;

@end
