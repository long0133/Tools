//
//  DBHProjectCommentUserClickCommentModel.h
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHProjectCommentUserClickCommentModel : NSObject

@property (nonatomic, assign) NSInteger category_user_id;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, assign) BOOL up; //赞
@property (nonatomic, assign) BOOL down; // 踩
@property (nonatomic, assign) BOOL equal; // 笑脸

@end
