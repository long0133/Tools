//
//  UserSignData.h
//  FBG
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserSignData : NSObject

+ (instancetype)share;

@property (nonatomic, strong) UserModel *user;

/** 更新存储本地数据 */
- (void)storageData:(UserModel *)user;

@end
