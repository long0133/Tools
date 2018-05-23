//
//  DBHProjectCommentDetailModel.m
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectCommentDetailModel.h"
#import "DBHProjectCommentUserModel.h"

@implementation DBHProjectCommentDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"commentId" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"user_click_comment" : [DBHProjectCommentUserClickCommentModel class]
             };
}

@end
