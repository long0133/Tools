//
//  NSMutableString+Tool.h
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableString (Tool)

//由于系统计算富文本的高度不正确，自己写了方法
- (CGFloat)heightWithContainWidth:(CGFloat)width;
- (float)heightForWidth:(float)width;

/**
 *  直接返回NSAttributedString
 *
 *  @param prefixString 前面的string
 *  @param prefixFont   字体大小
 *  @param prefixColor  字体颜色
 *  @param suffixString 后面拼接的string
 *  @param suffixFont   字体大小
 *  @param suffixColor  字体颜色
 *
 *  @return 直接返回NSAttributedString
 */
+ (NSAttributedString *)attributeStringWithPrefixString:(NSString *)prefixString
                                             prefixFont:(CGFloat)prefixFont
                                            prefixColor:(UIColor *)prefixColor
                                           suffixString:(NSString *)suffixString
                                             suffixFont:(CGFloat)suffixFont
                                            suffixColor:(UIColor *)suffixColor;

// string在前 图片在后

+ (NSMutableAttributedString *)attributeStringWithPrefixString:(NSString *)prefixString
                                              subffixImageName:(NSString *)subffixImageName;


//图片在前 string在后

+ (NSMutableAttributedString *)attributeStringWithSubffixString:(NSString *)subffixString
                                                prefixImageName:(NSString *)prefixImageName;

@end
