//
//  YYRedPacketEthTokenModel.h
//  FBG
//
//  Created by yy on 2018/4/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYRedPacketEthTokenModel : NSObject

@property (nonatomic, copy) NSString *name; // 代币名称
@property (nonatomic, copy) NSString *icon; // 代币图标
@property (nonatomic, copy) NSString *address; // 合约地址
@property (nonatomic, copy) NSString *gas;
@property (nonatomic, assign) NSInteger decimals; // 小数位数

@end
