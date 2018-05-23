//
//  UIColor+Tool.h
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tool)

/**
 *  主题色
 */
+ (instancetype)mainColor;
/**
 *  背景浅灰色
 */
+ (instancetype)backgroudColor;

/// 分割线颜色
+ (instancetype)lineColor;

//标题颜色
+ (instancetype)titleTextColor;

//副标题字体颜色
+ (instancetype)otherTitleTextColor;

//
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)highLightedColor:(UIColor*)color;
@end
