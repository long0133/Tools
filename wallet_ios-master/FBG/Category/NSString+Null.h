//
//  NSString+Null.h
//  FBG
//
//  Created by 邓毕华 on 2017/12/6.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Null)

/**
 根据输入值进行判断返回 为空返回NaN 否则原样返回
 */
+ (NSString *)getValueWithString:(NSString *)string;

@end
