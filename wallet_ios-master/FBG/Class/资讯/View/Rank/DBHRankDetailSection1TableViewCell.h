//
//  DBHRankDetailSection1TableViewCell.h
//  FBG
//
//  Created by yy on 2018/3/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class DBHRankDetailModel;

#define RANKDETAIL_SECTION1_CELL_ID @"RANKDETAIL_SECTION1_CELL"

@interface DBHRankDetailSection1TableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) DBHRankDetailModel *detailModel;

@end
