//
//  DBHQrCodeViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletManagerForNeoModelList;

@interface DBHQrCodeViewController : DBHBaseViewController

/**
 钱包Model
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *walletModel;

@end
