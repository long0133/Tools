//
//  NSObject+Tool.m
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "NSObject+Tool.h"

@implementation NSObject (Tool)

+ (BOOL)isNulllWithObject:(id)object
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""] || [((NSString *)object) containsString:@"null"]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

@end
