//
//  PackupsWordsVC.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/29.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WalletLeftListModel;

@interface PackupsWordsVC : UIViewController

@property (nonatomic, copy) NSString * mnemonic;
@property (nonatomic, strong) WalletLeftListModel * model;

@end
