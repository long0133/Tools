//
//  YYRedPacketMySentListModel.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketMySentListModel.h"

@implementation YYRedPacketMySentListModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"redPacketId" : @"id"
             };
}

@end
