//
//  ZJNWebHandle.m
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/8/1.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "CYLWebHandle.h"

@implementation CYLWebHandle
+ (instancetype)creatHandlerWithHandle:(handle)handler
{
    CYLWebHandle *webHandle = [[CYLWebHandle alloc] init];
    webHandle.msgHandle = handler;
    return webHandle;
}
@end
