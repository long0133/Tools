//
//  DBHRankDetailSection2TableViewCell.h
//  FBG
//
//  Created by yy on 2018/3/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class DBHTradingMarketModelData;

#define RANKDETAIL_SECTION2_CELL_ID @"RANKDETAIL_SECTION2_CELL"

@interface DBHRankDetailSection2TableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) DBHTradingMarketModelData *model;

@end
