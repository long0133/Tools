//
//  DBHTncTransferViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/12.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletManagerForNeoModelList;
@class DBHWalletDetailTokenInfomationModelData;

@interface DBHTncTransferViewController : DBHBaseViewController

/**
 Gas可用余额
 */
@property (nonatomic, copy) NSString *canUseGasBalance;

/**
 Neo钱包Model
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;

/**
 代币
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *tokenModel;

@end
