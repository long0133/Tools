//
//  AddWalletSucessVC.h
//  FBG
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBHBaseViewController.h"

@class DBHWalletManagerForNeoModelList;

@interface AddWalletSucessVC : DBHBaseViewController

@property (nonatomic, copy) NSString * mnemonic; // 助记词
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;

@end
