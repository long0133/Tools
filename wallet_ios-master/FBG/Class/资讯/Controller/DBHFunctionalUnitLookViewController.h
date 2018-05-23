//
//  DBHFunctionalUnitLookViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@interface DBHFunctionalUnitLookViewController : DBHBaseViewController

/**
 聊天会话
 */
@property (nonatomic, strong) EMConversation *conversation;

@property (nonatomic, assign) NSInteger functionalUnitType; // 功能组件类型

@end
