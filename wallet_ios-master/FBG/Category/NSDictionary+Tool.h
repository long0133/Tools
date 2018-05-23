//
//  NSDictionary+Tool.h
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Tool)

//url 参数转换字典
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

/**
 *  字段转成json的字符串
 *
 *  @return json 字符串
 */
- (NSString *)toJSONStringForDictionary;
//json格式字符串转字典;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
