//
//  UIColor+Tool.m
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "UIColor+Tool.h"

@implementation UIColor (Tool)

+ (instancetype)mainColor
{
    return [UIColor colorWithHexString:@"00D3AA"];
}

+ (instancetype)lineColor
{
    return [self colorWithHexString:@"ececec"];
}

+ (instancetype)backgroudColor
{
    return [UIColor colorWithHexString:@"ececec"];
}

+ (instancetype)titleTextColor
{
    return [UIColor colorWithHexString:@"f4f4f4"];
}

+ (instancetype)otherTitleTextColor
{
    return [UIColor colorWithHexString:@"f4f4f4"];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)highLightedColor:(UIColor*)color {
    const CGFloat *components1 = CGColorGetComponents(color.CGColor);
    CGFloat value = 0.2;
    
    CGFloat r = components1[0] * value;
    CGFloat g = components1[1] * value;
    CGFloat b = components1[2] * value;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:0.5];
}
@end
