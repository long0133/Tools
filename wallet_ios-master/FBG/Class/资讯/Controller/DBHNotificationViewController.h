//
//  DBHIotificationViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@interface DBHNotificationViewController : DBHBaseViewController

/**
 功能组件类型
 */
@property (nonatomic, assign) NSInteger functionalUnitType;

/**
 聊天会话
 */
@property (nonatomic, strong) EMConversation *conversation;

@end
