//
//  DBHProjectHomeMenuView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSInteger index);

@interface DBHProjectHomeMenuView : UIView

/**
 列
 */
@property (nonatomic, assign) NSInteger line;

/**
 最大列
 */
@property (nonatomic, assign) NSInteger maxLine;

/**
 数据源
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 动画显示
 */
- (void)animationShow;

/**
 动画隐藏
 */
- (void)animationHide;

/**
 选择回调
 */
- (void)selectedBlock:(SelectedBlock)selectedBlock;

@end
