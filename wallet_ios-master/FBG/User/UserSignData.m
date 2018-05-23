//
//  UserSignData.m
//  FBG
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "UserSignData.h"
#import <YYCache/YYCache.h>

static NSString *const kUserCacheKey = @"FBGCacheKey";

@interface UserSignData()

@property (nonatomic) YYCache *userCache;

@end

@implementation UserSignData

#pragma mark ------ Init ------
+ (instancetype)share{
    static UserSignData *userSignData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userSignData = [[UserSignData alloc] init];
    });
    return userSignData;
}

#pragma mark ------ Public Methods ------
/** 更新存储本地数据 */
- (void)storageData:(UserModel *)user {
    [self.userCache setObject:user forKey:kUserCacheKey];
}

#pragma mark ------ Getters And Setters ------
- (void)setUserModel:(UserModel *)userModel {
    [self storageData:userModel];
}

- (UserModel *)user {
    // 检查 读取（直接读取，不存在则是 nil）
    if ([self.userCache containsObjectForKey:kUserCacheKey]) {
        UserModel *user = (UserModel *)[self.userCache objectForKey:kUserCacheKey];
        return user;
    }
    UserModel *user = [[UserModel alloc] init];
    return user;
}

- (YYCache *)userCache {
    if (!_userCache) {
        _userCache = [[YYCache alloc] initWithName:kUserCacheKey];
    }
    return _userCache;
}

@end
