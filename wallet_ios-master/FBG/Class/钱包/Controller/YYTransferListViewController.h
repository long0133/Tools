//
//  YYTransferListViewController.h
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletManagerForNeoModelList;
@class DBHWalletDetailTokenInfomationModelData;

@interface YYTransferListViewController : DBHBaseViewController

/**
 Neo钱包Model
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;

/**
 代币
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *tokenModel;

@end
