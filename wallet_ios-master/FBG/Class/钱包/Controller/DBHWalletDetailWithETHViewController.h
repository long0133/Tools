//
//  DBHWalletDetailWithETHViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/2/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHWalletManagerForNeoModelList;

@interface DBHWalletDetailWithETHViewController : DBHBaseViewController

/**
 ETH钱包Model
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *ethWalletModel;

@end
