//
//  UIView+Tool.h
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tool)

//不用再蛋疼的写某view.frame=CGRectMake(x,y,z,o)了。
- (CGFloat)left;
- (CGFloat)right;
- (CGSize)size;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGFloat)maxX;
- (CGFloat)maxY;
- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setSize:(CGSize)size;
- (void)setTop:(CGFloat)top;
- (void)setBottom:(CGFloat)bottom;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setOrigin:(CGPoint)point;
- (void)setAddTop:(CGFloat)top;
- (void)setAddLeft:(CGFloat)left;

//加载Xib
+ (instancetype)loadViewFromXIB;

//把View加在Window上
- (void) addToWindow;


#pragma mark -- 截图  

//View截图
- (UIImage*) screenshot;

//ScrollView截图 contentOffset
- (UIImage*) screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

//View按Rect截图
- (UIImage*) screenshotInFrame:(CGRect)frame;

#pragma mark -- 动画

//摇动
- (void) shakeAnimation;

//弹性
- (void) springingAnimation;

//180°旋转
- (void) trans180DegreeAnimation;

/** 这个方法通过响应者链条获取view所在的控制器 */
- (UIViewController *)parentController;

/** 这个方法通过响应者链条获取view所在的控制器 */
+ (UIViewController *)currentViewController;

@end
