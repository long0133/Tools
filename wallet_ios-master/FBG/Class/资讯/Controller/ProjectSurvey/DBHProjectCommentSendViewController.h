//
//  DBHProjectCommentSendViewController.h
//  FBG
//
//  Created by yy on 2018/4/6.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"
@class DBHProjectDetailInformationModelData;

#define COMMENTSEND_STORYBOARD_NAME @"CommentSend"
#define COMMENTSEND_STORYBOARD_ID @"COMMENTSEND_STORYBOARD_ID"

@interface DBHProjectCommentSendViewController : DBHBaseViewController

/**
 项目详细信息
 */
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;

@end
