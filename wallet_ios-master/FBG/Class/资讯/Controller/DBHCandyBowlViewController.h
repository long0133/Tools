//
//  DBHCandyBowlViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@interface DBHCandyBowlViewController : DBHBaseViewController

@property (nonatomic, assign) NSInteger functionalUnitType; // 功能组件类型

/**
 聊天会话
 */
@property (nonatomic, strong) EMConversation *conversation;

@end
