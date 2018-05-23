//
//  YYRedPacketPackagingViewController.h
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

#define REDPACKET_PACKAGING_STORYBOARD_ID @"REDPACKET_PACKAGING"

typedef enum _package_type {
    PackageTypeCash = 0,
    PackageTypeRedPacket
}PackageType;

@interface YYRedPacketPackagingViewController : DBHBaseViewController

@property (nonatomic, assign) PackageType packageType; // 礼金打包还是红包创建

/**
 红包授权
 */
@property (nonatomic, strong) YYRedPacketEthTokenModel *tokenModel;
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *walletModel;
@property (nonatomic, copy) NSString *poundage;
@property (nonatomic, assign) NSInteger redbag_number; // 红包数量
@property (nonatomic, copy) NSString *redbag; // 红包金额

@end
