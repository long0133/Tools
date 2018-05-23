//
//  DBHTransferDetailViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletDetailTokenInfomationModelData;
@class DBHTransferListModelList;
@class YYTransferListETHModel;

@interface DBHTransferDetailViewController : DBHBaseViewController

/**
 代币
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *tokenModel;

/**
 转账记录
 */
@property (nonatomic, strong) DBHTransferListModelList *model;

@property (nonatomic, strong) EMMessage *message;

@end
