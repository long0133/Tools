//
//  YYRedPacketChooseCashViewController.h
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"
@class YYRedPacketEthTokenModel;

#define CHOOSE_CASH_STORYBOARD_ID @"CHOOSE_CASH_ID"

typedef void(^SelectCashModelBlcok) (YYRedPacketEthTokenModel *model);

@interface YYRedPacketChooseCashViewController : DBHBaseViewController

@property (nonatomic, copy) SelectCashModelBlcok block;

@end
