//
//  NSDate+Tool.m
//  FBG
//
//  Created by yy on 2018/4/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)

+ (NSString *)dateStrFromStr:(NSString *)str formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:formatter];
    
    NSString *resultDateStr = [dateFormatter stringFromDate:date];
    return resultDateStr;
}

@end
