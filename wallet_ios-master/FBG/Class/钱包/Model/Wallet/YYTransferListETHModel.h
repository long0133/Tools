//
//  YYTransferListETHModel.h
//  FBG
//
//  Created by yy on 2018/4/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYTransferListETHModel : NSObject

@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *block_number;  //当前块高
@property (nonatomic, copy) NSString *handle_fee;
@property (nonatomic, copy) NSString *confirm_at;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *hashStr;
@property (nonatomic, copy) NSString *pay_address; // from
@property (nonatomic, copy) NSString *receive_address; // to
@property (nonatomic, copy) NSString *trade_no; // tx
@property (nonatomic, copy) NSString *fee; //value

@property (nonatomic, assign) NSInteger transferType; // 转账类型 0:自转 1:转账 2:收款
@property (nonatomic, copy) NSString *maxBlockNumber;  //最大块号 当前
@property (nonatomic, copy) NSString *minBlockNumber;  //最小块号 确认 12

@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *typeName;

@end
