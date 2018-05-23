//
//  YYRedPacketDetailViewController.h
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

#define REDPACKET_DETAIL_STORYBOARD_ID @"REDPACKET_DETAIL"

@interface YYRedPacketDetailViewController : UITableViewController

@property (nonatomic, strong) YYRedPacketMySentListModel *model;
@property (nonatomic, strong) NSMutableArray *ethWalletsArr;

@end
