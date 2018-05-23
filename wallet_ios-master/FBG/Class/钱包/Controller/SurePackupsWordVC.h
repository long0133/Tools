//
//  SurePackupsWordVC.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/29.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WalletLeftListModel;

@interface SurePackupsWordVC : UIViewController

@property (nonatomic, strong) WalletLeftListModel *model;
@property (nonatomic, copy) NSString * mnemonic;

@end
