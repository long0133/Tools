//
//  DBHHotInfoRankModel.m
//  FBG
//
//  Created by yy on 2018/4/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHHotInfoRankModel.h"

@implementation DBHHotInfoRankModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : [DBHHotInfoRankDataModel class]
             };
}

@end
