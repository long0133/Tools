//
//  DBHBaseTableViewCell.h
//  Trinity
//
//  Created by 邓毕华 on 2017/12/26.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHBaseTableViewCell : UITableViewCell

/**
 是否隐藏灰色分隔线
 */
@property (nonatomic, assign) BOOL isHideBottomLineView;

/**
 分隔线宽度 默认比屏宽小30
 */
@property (nonatomic, assign) CGFloat bottomLineWidth;

/**
 分隔线颜色 默认 F6F6F6
 */
@property (nonatomic, strong) UIColor *bottomLineViewColor;

@end
