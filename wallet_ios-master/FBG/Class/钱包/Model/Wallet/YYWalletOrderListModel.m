//
//  YYWalletOrderListModel.m
//  FBG
//
//  Created by yy on 2018/4/18.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYWalletOrderListModel.h"

@implementation YYWalletOrderListModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"hashAddress" : @"hash"
             };
}

@end
