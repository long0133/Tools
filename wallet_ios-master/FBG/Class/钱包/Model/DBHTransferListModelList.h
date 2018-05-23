//
//  DBHTransferListModelList.h
//
//  Created by   on 2018/1/10
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHTransferListModelList : NSObject

@property (nonatomic, strong) NSString *asset;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, assign) id remark;
@property (nonatomic, strong) NSString *tx;
@property (nonatomic, strong) NSString *confirmTime;
@property (nonatomic, strong) NSString *context;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *is_token;
@property (nonatomic, strong) NSString *handle_fee;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, assign) NSInteger transferType; // 转账类型 0:自转 1:转账 2:收款
@property (nonatomic, copy) NSString * block_number;  //当前块高
@property (nonatomic, copy) NSString * maxBlockNumber;  //最大块号 当前
@property (nonatomic, copy) NSString * minBlockNumber;  //最小块号 确认 12
@property (nonatomic, copy) NSString * flag;

@property (nonatomic, copy) NSString *typeName;

@end
