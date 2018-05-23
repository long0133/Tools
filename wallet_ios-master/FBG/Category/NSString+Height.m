//
//  NSString+Height.m
//  TouZiPingTai
//
//  Created by DBH on 17/7/18.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "NSString+Height.h"

@implementation NSString (Height)

/**
 根据传入的字符串计算出所占高度

 @param string 传入的字符串
 @param width 最大宽度
 @param lineSpacing 行间距
 @param fontSize 字体大小
 @return 应占高度
 */
+ (CGFloat)getHeightWithString:(NSString *)string
                         width:(CGFloat)width
                   lineSpacing:(CGFloat)lineSpacing
                      fontSize:(CGFloat)fontSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    return [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
}

/**
 根据传入的字符串计算出所占宽度
 
 @param string 传入的字符串
 @param fontSize 字体大小
 @return 应占高度
 */
+ (CGFloat)getWidthtWithString:(NSString *)string
                      fontSize:(CGFloat)fontSize {
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width + AUTOLAYOUTSIZE(2);
}

@end
