//
//  DBHBaseProtocol.h
//  FBG
//
//  Created by yy on 2018/3/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHBaseProtocol : NSObject

/**
 将dic转成json字符串
 
 @param dic dic
 @return jsonstr
 */
- (NSString *)JSONString:(NSDictionary *)dic;

/**
 根据hostName获取主机IP
 
 @param hostName hostname
 @return ip
 */
+ (NSString *)getIPWithHostName:(const NSString *)hostName;

/**
 替换url为主机IP
 
 @param target url
 @return 替换后的
 
 备注： 如果要用，需先设置 DEFAULT_REPLACE_IP 的值
 */
- (NSString *)getReplacedUrlByUrl:(NSString *)target;

@end
