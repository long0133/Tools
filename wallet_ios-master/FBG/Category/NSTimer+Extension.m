//
//  NSTimer+Extension.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)

+ (NSTimer *)dbh_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *))block {
    if ([self respondsToSelector:@selector(timerWithTimeInterval:repeats:block:)]) {
        return [self timerWithTimeInterval:interval repeats:repeats block:block];
    }
    return [self timerWithTimeInterval:interval target:self selector:@selector(timerAction:) userInfo:block repeats:repeats];
}

+ (void)timerAction:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) block(timer);
}

@end
