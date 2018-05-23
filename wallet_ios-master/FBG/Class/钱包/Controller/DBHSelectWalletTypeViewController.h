//
//  DBHSelectWalletTypeViewController.h
//  FBG
//
//  Created by yy on 2018/3/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"
#import "DBHSelectWalletTypeViewController.h"
#import "DBHWalletManagerTableViewCell.h"
#import "DBHImportWalletViewController.h"
#import "DBHImportWalletWithETHViewController.h"
#import "DBHSelectHotCodeWalletViewController.h"
#import "DBHShowAddWalletViewController.h"

typedef enum new_wallet_type {
    NewWalletTypeAdd = 0,
    NewWalletTypeImport
}NewWalletType;

@interface DBHSelectWalletTypeViewController : DBHBaseViewController

@property (nonatomic, strong) UINavigationController *nc;
@property (nonatomic, assign) NewWalletType type;

@end
