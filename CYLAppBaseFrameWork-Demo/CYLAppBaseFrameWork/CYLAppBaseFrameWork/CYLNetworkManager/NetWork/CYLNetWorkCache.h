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
@property (nonatomic, strong) NSThread * _Nonnull netWorkThread;

+ (instancetype _Nonnull )shareInstance;
- (void)cacheResponse:(CYLResponse*_Nullable)response;
- (nullable CYLResponse*)getResponseFromCacheWithKey:(NSString*_Nonnull)urlKey;
@end
