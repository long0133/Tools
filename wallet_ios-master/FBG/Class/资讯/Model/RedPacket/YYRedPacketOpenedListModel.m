//
//  YYRedPacketOpenedListModel.m
//  FBG
//
//  Created by yy on 2018/5/1.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketOpenedListModel.h"
@class YYRedPacketOpenedModel;

@implementation YYRedPacketOpenedListModel

MJCodingImplementation
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : [YYRedPacketOpenedModel class]
             };
}

@end
