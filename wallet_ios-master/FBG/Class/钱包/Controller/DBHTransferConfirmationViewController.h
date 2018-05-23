//
//  DBHTransferConfirmationViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletDetailTokenInfomationModelData;
@class DBHWalletManagerForNeoModelList;

@interface DBHTransferConfirmationViewController : DBHBaseViewController

/**
 代币
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *tokenModel;

/**
 Neo钱包Model
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;

/**
 转账数量
 */
@property (nonatomic, copy) NSString *transferNumber;

/**
 手续费
 */
@property (nonatomic, copy) NSString *poundage;

/**
 实际手续费
 */
@property (nonatomic, copy) NSString *realityPoundage;

/**
 转账地址
 */
@property (nonatomic, copy) NSString *address;

/**
 备注
 */
@property (nonatomic, copy) NSString *remark;

/**
 交易次数
 */
@property (nonatomic, copy) NSString *nonce;

@end
