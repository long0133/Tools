//
//  CYLResponse.m
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/3/29.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLResponse.h"

@implementation CYLResponse

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.returnObj = [aDecoder decodeObjectForKey:@"returnObj"];
        self.cachePolicy = ((NSNumber*)[aDecoder decodeObjectForKey:@"cachePolicy"]).integerValue;
        self.firstCacheTime = ((NSNumber*)[aDecoder decodeObjectForKey:@"firstCacheTime"]).doubleValue;
        self.cachePeriod = ((NSNumber*)[aDecoder decodeObjectForKey:@"cachePeriod"]).doubleValue;
        self.url = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.returnObj forKey:@"returnObj"];
    [aCoder encodeObject:@(self.cachePolicy) forKey:@"cachePolicy"];
    [aCoder encodeObject:@(self.firstCacheTime) forKey:@"firstCacheTime"];
    [aCoder encodeObject:@(self.cachePeriod) forKey:@"cachePeriod"];
    [aCoder encodeObject:self.url forKey:@"url"];
}

@end
