//
//  CYLApiBaseManager.m
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/4/2.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLApiBaseManager.h"
#import "CYLNetWorkManager.h"

@interface CYLApiBaseManager()
#pragma mark -  基本请求信息
@property (nonatomic, strong) NSString *requestUrl; /**< 请求路径 */
@property (nonatomic, strong) id parameters; /**< 请求参数 */
@property (nonatomic, assign) APICallMethod method; /**< 请求方法 */

#pragma mark - 缓存相关配置
//@property (nonatomic, assign) CYLNetWorkCachePolicy cachePolicy; /**< 缓存策略 */
//@property (nonatomic, assign) NSTimeInterval cachePeriod; /**< 缓存事件 */
@end

@implementation CYLApiBaseManager

- (instancetype)init
{
    self = [super init];
    if ([self conformsToProtocol:@protocol(APIManager)]) {
        self.child = (id<APIManager>)self;
    } else {
        // 不遵守这个protocol的就让他crash，防止派生类乱来。
        NSAssert(NO, @"子类必须要实现APIManager这个protocol。");
    }
    return self;
}

- (void)callApi{
    switch (self.method) {
        case APICallMethod_GET:
        {
            if (self.cachePolicy != CYLNetWorkCachePolicy_DoNotCache) {
                
                [CYLNetWorkManager GET:self.requestUrl CachePolicy:[self cachePolicy] activePeriod:[self cachePeriod] parameter:self.parameters success:^(CYLResponse *response) {
                    
                    self.response = response;
                    
                    if ([self.delegate respondsToSelector:@selector(callApiDidSuccess:)]) {
                        
                        if ([self.delegate respondsToSelector:@selector(callApiDidSuccess:)]) {
                            [self.delegate callApiDidSuccess:self];
                        }
                        
                    }
                    
                } fail:^(NSError *error) {
                    
                    if ([self.delegate respondsToSelector:@selector(callApiDidFailed:)]) {
                        [self.delegate callApiDidFailed:error];
                    }
                    
                }];
                
            }else{
                [CYLNetWorkManager GET:self.requestUrl parameter:self.parameters success:^(CYLResponse *response) {
                    
                    self.response = response;
                    
                    if ([self respondsToSelector:@selector(callApiDidSuccess:)]) {
                        
                        if ([self.delegate respondsToSelector:@selector(callApiDidSuccess:)]) {
                            [self.delegate callApiDidSuccess:self];
                        }
                        
                    }
                } fail:^(NSError *error) {
                    
                    if ([self.delegate respondsToSelector:@selector(callApiDidFailed:)]) {
                        [self.delegate callApiDidFailed:error];
                    }
                    
                }];
            }
        }
            break;
            
        case APICallMethod_POST:{
            if (self.cachePolicy != CYLNetWorkCachePolicy_DoNotCache) {
                
                [CYLNetWorkManager POST:self.requestUrl CachePolicy:self.cachePolicy activePeriod:self.cachePeriod parameter:self.parameters success:^(CYLResponse *response) {
                    
                    self.response = response;
                    
                    if ([self.delegate respondsToSelector:@selector(callApiDidSuccess:)]) {
                        
                        if ([self.delegate respondsToSelector:@selector(callApiDidSuccess:)]) {
                            [self.delegate callApiDidSuccess:self];
                        }
                        
                    }
                    
                } fail:^(NSError *error) {
                    
                    if ([self.delegate respondsToSelector:@selector(callApiDidFailed:)]) {
                        [self.delegate callApiDidFailed:error];
                    }
                    
                }];
                
            }else{
                [CYLNetWorkManager POST:self.requestUrl parameter:self.parameters success:^(CYLResponse *response) {
                   
                    self.response = response;
                    
                    if ([self respondsToSelector:@selector(callApiDidSuccess:)]) {
                        
                        if ([self.delegate respondsToSelector:@selector(callApiDidSuccess:)]) {
                            [self.delegate callApiDidSuccess:self];
                        }
                        
                    }
                } fail:^(NSError *error) {
                    
                    if ([self.delegate respondsToSelector:@selector(callApiDidFailed:)]) {
                        [self.delegate callApiDidFailed:error];
                    }
                    
                }];
            }
        }
            break;
    }
}


- (id)fetchDataWithReformer:(id<ReformerProtocol>)reformer
{
    if (reformer == nil) {
        return self.response.returnObj;
    } else {
        return [reformer reformDataWithManager:self];
    }
}

#pragma mark - getter
- (NSString *)requestUrl{
    return [self.child getUrl];
}

- (APICallMethod)method{
    return [self.child getMethod];
}

- (id)parameters{
    return [self.child getParams];
}

- (CYLNetWorkCachePolicy)cachePolicy{
    if ([self.child respondsToSelector:@selector(getCachePolicy)]) {
        return [self.child getCachePolicy];
    }
    
    return CYLNetWorkCachePolicy_DoNotCache;
}

- (NSTimeInterval)cachePeriod{
    if ([self.child respondsToSelector:@selector(getCachePeriod)]) {
        return [self.child getCachePeriod];
    }
    return 0;
}

@end
