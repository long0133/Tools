//
//  DBHProjectCommentAllListModel.m
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectCommentAllListModel.h"

@implementation DBHProjectCommentAllListModel


+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : [DBHProjectCommentAllListDetailModel class]
             };
}

@end
