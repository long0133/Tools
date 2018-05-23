//
//  DBHRankDetailSection0TableViewCell.h
//  FBG
//
//  Created by yy on 2018/3/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class DBHRankDetailModel;

#define RANKDETAIL_SECTION0_CELL_ID @"RANKDETAIL_SECTION0_CELL"

@interface DBHRankDetailSection0TableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) DBHRankDetailModel *detailModel;

@end
