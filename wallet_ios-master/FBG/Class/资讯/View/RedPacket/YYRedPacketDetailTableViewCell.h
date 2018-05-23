//
//  YYRedPacketDetailTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

#define REDPACKET_DETAIL_CELL_ID @"REDPACKET_DETAIL_CELL"
#define REDPACKET_DETAIL_CELL_HEIGHT 64

@interface YYRedPacketDetailTableViewCell : DBHBaseTableViewCell

@property (nonatomic, assign) BOOL isLastCellInSection;

- (void)setModel:(YYRedPacketDetailModel *)model section:(NSInteger)section;

@end
