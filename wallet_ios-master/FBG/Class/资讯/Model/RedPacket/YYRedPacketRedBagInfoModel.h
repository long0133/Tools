//
//  YYRedPacketRedBagInfoModel.h
//  FBG
//
//  Created by yy on 2018/5/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYRedPacketRedBagInfoModel : NSObject

@property (nonatomic, assign) NSInteger command;
@property (nonatomic, copy) NSString *comtract;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, assign) NSInteger remainCount; // 剩余红包个数
@property (nonatomic, assign) NSInteger remainValue; // 剩余红包金额
@property (nonatomic, assign) BOOL takebacke; // 是否结束
@property (nonatomic, assign) NSInteger totalCount; // 红包总数
@property (nonatomic, assign) NSInteger totalValue; // 红包金额
@property (nonatomic, strong) NSArray *users; // 领取红包的钱包地址
@property (nonatomic, strong) NSArray *values; // 领取红包金额

@end
