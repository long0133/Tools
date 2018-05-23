//
//  YYComentDetailListModel.m
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYComentDetailListModel.h"

@implementation YYComentDetailListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : [DBHProjectCommentDetailModel class]
             };
}

@end
