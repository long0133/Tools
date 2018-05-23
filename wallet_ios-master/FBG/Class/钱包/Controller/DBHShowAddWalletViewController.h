//
//  DBHShowAddWalletViewController.h
//  FBG
//
//  Created by yy on 2018/3/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"
#import "DBHSelectHotCodeWalletViewController.h"

@interface DBHShowAddWalletViewController : DBHBaseViewController

@property (nonatomic, strong) UINavigationController *nc;

@property (nonatomic, assign) WalletType type;

- (void)animateShow:(BOOL)isShow completion:(void (^)(BOOL isFinish))completion;

@end
