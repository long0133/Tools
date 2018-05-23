//
//  YYWalletOrderListModel.h
//  FBG
//
//  Created by yy on 2018/4/18.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYWalletOrderListModel : NSObject

@property (nonatomic, copy) NSString *block_number;
@property (nonatomic, copy) NSString *confirm_at;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *handle_fee;
@property (nonatomic, copy) NSString *hashAddress; // hash
@property (nonatomic, copy) NSString *pay_address;
@property (nonatomic, copy) NSString *receive_address;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *trade_no;

@end
