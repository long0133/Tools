//
//  DBHNetWork.h
//  FBG
//
//  Created by yy on 2018/3/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
// 网络工具类

#import <Foundation/Foundation.h>

@interface DBHNetWork : NSObject

/**
 判断网络是否可用

 @return result
 */
+ (BOOL) isConnectionAvailable;

@end
