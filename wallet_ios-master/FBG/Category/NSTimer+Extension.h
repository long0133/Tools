//
//  NSTimer+Extension.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)

+ (NSTimer *)dbh_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *))block;

@end
