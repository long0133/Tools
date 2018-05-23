//
//  DBHCommentSendSuccessViewController.h
//  FBG
//
//  Created by yy on 2018/4/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"
@class DBHProjectCommentModel;

#define COMMENTSENDSUCCESS_STORYBOARD_NAME @"CommentSendSuccess"
#define COMMENTSENDSUCCESS_STORYBOARD_ID @"COMMENTSENDSUCCESS_STORYBOARD_ID"

@interface DBHCommentSendSuccessViewController : DBHBaseViewController

@property (nonatomic, strong) DBHProjectCommentModel *model;

@end
