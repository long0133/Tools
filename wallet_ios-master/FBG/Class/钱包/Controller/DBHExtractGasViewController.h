//
//  DBHExtractGasViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletDetailTokenInfomationModelData;

@interface DBHExtractGasViewController : DBHBaseViewController

/**
 钱包id
 */
@property (nonatomic, copy) NSString *wallectId;

/**
 neo代币Model
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *neoTokenModel;

/**
 gas代币Model
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *gasTokenModel;

@end
