//
//  DBHSelectWalletTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@interface DBHSelectWalletTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelected;

@end
