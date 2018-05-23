//
//  YYRedPacketDetailModel.m
//  FBG
//
//  Created by yy on 2018/5/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailModel.h"

@implementation YYRedPacketDetailModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"modelId" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"draws" : [YYRedPacketDrawModel class]
             };
}

@end
