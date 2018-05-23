//
//  DBHCommentReplyModel.h
//  FBG
//
//  Created by yy on 2018/4/7.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHCommentReplyModel : NSObject

@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger category_user_id;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, assign) BOOL down;
@property (nonatomic, assign) BOOL equal;
@property (nonatomic, assign) NSInteger replyId;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, assign) BOOL up;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, assign) NSInteger user_id;

@end
