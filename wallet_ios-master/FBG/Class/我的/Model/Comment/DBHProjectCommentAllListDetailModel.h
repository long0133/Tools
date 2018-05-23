//
//  DBHProjectCommentAllListDetailModel.h
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMMENT_LIST_DEFAULT_HEIGHT 82

@class DBHProjectCommentUserModel;

@interface DBHProjectCommentAllListDetailModel : NSObject

@property (nonatomic, assign) NSInteger commentId; //
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger category_user_id;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, strong) DBHProjectCommentUserModel *user;

@property (nonatomic, assign) CGFloat height;

@end
