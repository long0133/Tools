//
//  DBHSelectHotCodeWalletViewController.h
//  FBG
//
//  Created by yy on 2018/3/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

typedef enum wallet_type {
    WalletTypeNEO = 1,
    WalletTypeETH
}WalletType;

@interface DBHSelectHotCodeWalletViewController : DBHBaseViewController

@property (nonatomic, strong) UINavigationController *nc;
@property (nonatomic, assign) WalletType walletType;

@end
