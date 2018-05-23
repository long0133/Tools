//
//  DBHTransferListViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletManagerForNeoModelList;
@class DBHWalletDetailTokenInfomationModelData;

@interface DBHTransferListViewController : DBHBaseViewController

/**
 Neo钱包Model
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;

/**
 代币
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *tokenModel;

@end
