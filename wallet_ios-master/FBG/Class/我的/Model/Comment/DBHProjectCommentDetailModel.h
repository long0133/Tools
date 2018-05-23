//
//  DBHProjectCommentDetailModel.h
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHProjectCommentUserClickCommentModel.h"

@class DBHProjectCommentUserModel;
@class DBHProjectCommentCategoryModel;

@interface DBHProjectCommentDetailModel : NSObject

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) BOOL is_favorite;

@property (nonatomic, assign) NSInteger commentId; //
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) BOOL is_market_follow;
@property (nonatomic, assign) BOOL is_favorite_dot;
@property (nonatomic, assign) BOOL is_top;
@property (nonatomic, assign) BOOL is_category_comment;
@property (nonatomic, assign) NSInteger category_comment_tag_id;
@property (nonatomic, copy) NSString *market_hige;
@property (nonatomic, copy) NSString *market_lost;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *category_comment_tag_name;
@property (nonatomic, copy) NSString *category_comment;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *category_comment_at;
@property (nonatomic, assign) NSInteger user_click_comment_up_count;
@property (nonatomic, assign) NSInteger user_click_comment_down_count;
@property (nonatomic, assign) NSInteger user_click_comment_equal_count;
@property (nonatomic, assign) NSInteger comment_count;

@property (nonatomic, strong) DBHProjectCommentCategoryModel *category;

@property (nonatomic, strong) DBHProjectCommentUserModel *user;
@property (nonatomic, strong) NSArray *user_click_comment;
@property (nonatomic, assign) BOOL category_comment_enable;

@property (nonatomic, assign) CGFloat height;

@end
