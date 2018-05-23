//
//  YYRedPacketChooseCashTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class YYRedPacketEthTokenModel;

#define CHOOSE_CASH_CELL_ID @"CHOOSE_CASH_CELL"

@interface YYRedPacketChooseCashTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) YYRedPacketEthTokenModel *model;

@end
