//
//  UIViewController+Tool.m
//  纽扣影视2.0
//
//  Created by mac on 2017/4/18.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "UIViewController+Tool.h"

@implementation UIViewController (Tool)

+ (void)load {   static dispatch_once_t onceToken;  dispatch_once(&onceToken, ^{
    Class class = [self class];
    Swizzle(class, NSSelectorFromString(@"viewDidAppear:"), @selector(myDealloc));
});
}

- (void)myDealloc
{
#ifdef DEBUG
    NSLog(@"⭐️⭐️⭐️⭐️当前页面类名  %@ ⭐️⭐️⭐️⭐️", [self class]);
#endif
    [self myDealloc];
    
}

@end
