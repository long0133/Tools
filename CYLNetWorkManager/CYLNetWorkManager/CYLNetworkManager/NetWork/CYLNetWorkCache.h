//
//  CYLNetWorkCache.h
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/3/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@class CYLResponse;

@interface CYLNetWorkCache : NSObject
@property (nonatomic, strong) NSThread *netWorkThread;

+ (instancetype)shareInstance;
- (void)cacheResponse:(CYLResponse*)response;
- (nullable CYLResponse*)getResponseFromCacheWithKey:(NSString*)urlKey;
@end
