//
//  CYLGetTypeApi.m
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/4/2.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLGetTypeApi.h"

@implementation CYLGetTypeApi

- (NSString *)getUrl{
    return @"/api/order/reqtype";
}

- (APICallMethod)getMethod{
    return APICallMethod_GET;
}

- (NSDictionary *)getParams{
    return @{};
}

- (CYLNetWorkCachePolicy)getCachePolicy{
    return CYLNetWorkCachePolicy_OnlyMemory;
}

- (NSTimeInterval)getCachePeriod{
    return 10.0;
}
@end
