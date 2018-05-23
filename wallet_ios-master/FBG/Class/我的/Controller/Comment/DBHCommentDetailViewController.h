//
//  DBHCommentDetailViewController.h
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

#define COMMENTS_STORYBOARD_NAME @"Comments"
#define COMMENTDETAIL_STORYBOARD_ID @"COMMENTDETAIL_STORYBOARD_ID"
@class DBHProjectCommentModel;
@class DBHProjectCommentDetailModel;

@interface DBHCommentDetailViewController : DBHBaseViewController

@property (nonatomic, strong) DBHProjectCommentModel *model;
@property (nonatomic, strong) DBHProjectCommentDetailModel *detailModel;

@end
