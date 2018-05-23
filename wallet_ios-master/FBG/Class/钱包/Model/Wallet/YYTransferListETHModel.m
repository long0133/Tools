//
//  YYTransferListETHModel.m
//  FBG
//
//  Created by yy on 2018/4/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYTransferListETHModel.h"

@implementation YYTransferListETHModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"hashStr" : @"hash"
             };
}

MJCodingImplementation

- (NSString *)maxBlockNumber {
    if (!_maxBlockNumber) {
        _maxBlockNumber = @"0";
    }
    return _maxBlockNumber;
}

- (NSString *)minBlockNumber {
    if (!_minBlockNumber) {
        _minBlockNumber = @"12";
    }
    return _minBlockNumber;
}

@end
