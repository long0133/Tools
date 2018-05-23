//
//  DBHCandyBowlTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHCandyBowlModelData;

@interface DBHCandyBowlTableViewCell : DBHBaseTableViewCell

/**
 空投信息
 */
@property (nonatomic, strong) DBHCandyBowlModelData *model;

@end
