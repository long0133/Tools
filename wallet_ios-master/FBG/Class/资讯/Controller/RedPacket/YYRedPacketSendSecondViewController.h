//
//  YYRedPacketSendSecondViewController.h
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

#define REDPACKET_SEND_SECOND_STORYBOARD_ID @"REDPACKET_SEND_SECOND_ID" 

@interface YYRedPacketSendSecondViewController : DBHBaseViewController

@property (nonatomic, strong) YYRedPacketEthTokenModel *tokenModel;
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *walletModel;
@property (nonatomic, assign) NSInteger redbag_number; // 红包个数

@end
