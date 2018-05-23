//
//  YYWalletModel.m
//  FBG
//
//  Created by yy on 2018/4/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYWalletModel.h"

@implementation YYWalletModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"walletId" : @"id"
             };
}

@end
