//
//  DBHAddPropertyTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

#import "DBHAddPropertyModelList.h"

@interface DBHAddPropertyTableViewCell : DBHBaseTableViewCell

/**
 代币信息
 */
@property (nonatomic, strong) DBHAddPropertyModelList *model;

/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelected;

@end
