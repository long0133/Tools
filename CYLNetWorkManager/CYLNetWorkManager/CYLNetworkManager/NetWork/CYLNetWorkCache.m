//
//  CYLNetWorkCache.m
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/3/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLNetWorkCache.h"
#import <UIKit/UIKit.h>
#import "CYLResponse.h"
#import "TKFileManager.h"

static CYLNetWorkCache *_instance;
@interface CYLNetWorkCache()
@property (nonatomic, strong) NSSet<NSString*> *doNotCacheSet;
@property (nonatomic, strong) NSCache *cache;
@end

@implementation CYLNetWorkCache
#pragma mark - singleton
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue new] usingBlock:^(NSNotification * _Nonnull note) {
                [_instance.cache removeAllObjects];
            }];
        }
    });
    return _instance;
}

+ (instancetype)shareInstance
{
    return [[self alloc] init];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public
- (void)cacheResponse:(CYLResponse*)response{
    NSLog(@"try cache res : %@",response.url);
    
    response.firstCacheTime = [[NSDate date] timeIntervalSince1970];
    
    switch (response.cachePolicy) {
        case CYLNetWorkCachePolicy_DoNotCache:
            [self.doNotCacheSet setValue:response.url forKey:response.url];
            break;
        case CYLNetWorkCachePolicy_OnlyMemory:{
            if (response.cachePeriod == 0) return;
            [self.cache setObject:response forKey:response.url];
            [self performSelector:@selector(startTimerForEffectiveCachePeriod:) onThread:self.netWorkThread withObject:response waitUntilDone:YES];
        }
            break;
        case CYLNetWorkCachePolicy_MemoryAndDisk:{
            if (response.cachePeriod == 0) return;
            [self.cache setObject:response forKey:response.url];
            NSLog(@"cache disk to %@",[self getCacheDiskPathForRes:response.url]);
            [TKFileManager saveData:response withFileName:[self getCacheDiskPathForRes:response.url]];
            [self performSelector:@selector(startTimerForEffectiveCachePeriod:) onThread:self.netWorkThread withObject:response waitUntilDone:YES];
        }
            break;
    }
}

- (nullable CYLResponse*)getResponseFromCacheWithKey:(NSString*)urlKey{
    
    if ([self.doNotCacheSet containsObject:urlKey]) {
//        NSLog(@"do not cache");
        return nil;
    }
    
    //从内存中取出
    CYLResponse *res = [self.cache objectForKey:urlKey];
    
    //从磁盘中取出
    if (!res) {
        res = (CYLResponse*)[TKFileManager loadDataWithFileName:[self getCacheDiskPathForRes:urlKey]];
        NSTimeInterval currTimeStamp = [[NSDate date] timeIntervalSince1970];
        if (currTimeStamp > res.firstCacheTime + res.cachePeriod) {
            res = nil;
            [self.cache removeObjectForKey:res.url];
            [self removeLocalFile:urlKey];
            NSLog(@"cache outOfDate Remove: %@",res.url);
        }
        NSLog(@"cache from disk : %@", res);
    }else{
        NSLog(@"cache from memory : %@", res);
    }
    
    
    return res;
}

- (void)removeLocalFile:(NSString*)urlKey{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documentPath stringByAppendingString:[self getCacheDiskPathForRes:urlKey]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void)startTimerForEffectiveCachePeriod:(CYLResponse*)response{
    NSTimer *timer = [NSTimer timerWithTimeInterval:response.cachePeriod repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSLog(@"evict: %@",response.url);
        [self.cache removeObjectForKey:response.url];
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (NSString*)getCacheDiskPathForRes:(NSString*)resUrl{
    NSString *path = [resUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return path;
}

#pragma mark - getter setter
- (NSSet<NSString *> *)doNotCacheSet{
    if (!_doNotCacheSet) {
        _doNotCacheSet = [NSSet set];
    }
    return _doNotCacheSet;
}

- (NSCache *)cache{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}

@end
