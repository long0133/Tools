//
//  DBHProjectCommentModel.h
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHProjectCommentUserModel.h"
#import "DBHProjectCommentCategoryModel.h"

@interface DBHProjectCommentModel : NSObject

@property (nonatomic, strong) DBHProjectCommentCategoryModel *category;
@property (nonatomic, copy) NSString *category_comment;
@property (nonatomic, copy) NSString *category_comment_at;
@property (nonatomic, assign) BOOL category_comment_enable;
@property (nonatomic, assign) NSInteger category_comment_tag_id;
@property (nonatomic, copy) NSString *category_comment_tag_name;
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) BOOL is_category_comment; // 是否参投过
@property (nonatomic, assign) BOOL is_favorite;
@property (nonatomic, assign) BOOL is_favorite_dot;
@property (nonatomic, assign) BOOL is_market_follow;
@property (nonatomic, assign) BOOL is_top;
@property (nonatomic, copy) NSString *market_hige;
@property (nonatomic, copy) NSString *market_lost;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, strong) DBHProjectCommentUserModel *user;
@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, assign) CGFloat height;

@end
