//
//  YYRedPacketSection0TableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class YYRedPacketSentCountModel;

#define REDPACKET_SECTION0_CELL_HEIGHT 140
#define REDPACKET_SECTION0_CELL_ID @"REDPACKET_SECTION0_CELL"

@interface YYRedPacketSection0TableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) YYRedPacketSentCountModel *model;

@end
