//
//  UIButton+Tool.h
//  FBG
//
//  Created by yy on 2018/3/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Tool)

/**
 * 设置btn不同状态下的背景颜色
 */
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

/**
 设置btn的边框，已设置圆角

 @param width 宽度
 @param color 颜色
 */
- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color;
- (void)setCorner:(CGFloat)radius;
@end
