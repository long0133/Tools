//
//  DBHCommentReplyModel.m
//  FBG
//
//  Created by yy on 2018/4/7.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCommentReplyModel.h"

@implementation DBHCommentReplyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"replyId" : @"id"
             };
}

@end
