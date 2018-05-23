//
//  DBHDappRankModel.m
//  FBG
//
//  Created by yy on 2018/4/2.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHDappRankModel.h"

@implementation DBHDappRankModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"modelId" : @"id",
             @"desc" : @"description"
             };
}

@end
