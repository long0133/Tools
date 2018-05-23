//
//  YYRedPacketMySentModel.m
//  FBG
//
//  Created by yy on 2018/5/1.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketMySentModel.h"
#import "YYRedPacketMySentListModel.h"

@implementation YYRedPacketMySentModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : [YYRedPacketMySentListModel class]
             };
}

@end
