//
//  YYRedPacketModels.h
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

typedef enum _redbag_status {
    RedBagStatusDone = 1,
    RedBagStatusCashPackaging = 2,
    RedBagStatusCreating = 3,
    RedBagStatusOpening = 4,
    RedBagStatusCashPackageFailed = -2,
    RedBagStatusCreateFailed = -3
}RedBagStatus;

#import "PPNetworkCache.h"
#import "YYRedPacketMySentListModel.h"
#import "YYRedPacketSentCountModel.h"
#import "YYRedPacketEthTokenModel.h"
#import "YYRedPacketMySentModel.h"
#import "YYRedPacketOpenedListModel.h"
#import "YYRedPacketOpenedModel.h"
#import "YYRedPacketOpenedRedBagModel.h"
#import "YYRedPacketOpenedRedBagGntCategoryModel.h"
#import "YYRedPacketWalletTokenModel.h"
#import "YYRedPacketDrawModel.h"
#import "YYRedPacketRedBagInfoModel.h"
#import "YYRedPacketDetailModel.h"

#define HAS_EMPTY(str) [NSString stringWithFormat:@"  %@  ", str]
