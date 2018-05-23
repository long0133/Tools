//
//  DBHMonetaryUnitTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@interface DBHMonetaryUnitTableViewCell : DBHBaseTableViewCell

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelected;

@end
