//
//  DBHTradingMarketTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHTradingMarketModelData;

@interface DBHTradingMarketTableViewCell : DBHBaseTableViewCell

/**
 交易市场数据
 */
@property (nonatomic, strong) DBHTradingMarketModelData *model;

@end
