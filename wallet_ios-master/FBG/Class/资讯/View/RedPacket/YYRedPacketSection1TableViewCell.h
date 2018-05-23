//
//  YYRedPacketSection1TableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

#define REDPACKET_SECTION1_CELL_HEIGHT 80
#define REDPACKET_SECTION1_CELL_ID @"REDPACKET_SECTION1_CELL"

typedef enum _cell_from {
    CellFromSentHistory = 0, // 发送记录
    CellFromOpenedHistory // 领取记录
}CellFrom;

@interface YYRedPacketSection1TableViewCell : DBHBaseTableViewCell

- (void)setModel:(id)model from:(CellFrom)from;

@end
