//
//  DBHCreateWalletViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletManagerForNeoModelList;

@interface DBHCreateWalletViewController : DBHBaseViewController

/**
 NEO钱包Model
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;


/**
 NEO钱包
 */
@property (nonatomic, strong) NeomobileWallet *neoWallet;

@end
