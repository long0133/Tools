//
//  YYRedPacketOpenedRedBagModel.h
//  FBG
//
//  Created by yy on 2018/5/1.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYRedPacketOpenedRedBagGntCategoryModel;

@interface YYRedPacketOpenedRedBagModel : NSObject

@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy) NSString *auth_tx_id;
@property (nonatomic, copy) NSString *redbag_tx_id;
@property (nonatomic, assign) NSInteger redbag_id;
@property (nonatomic, copy) NSString *redbag;
@property (nonatomic, copy) NSString *redbag_symbol; // 红包代币
@property (nonatomic, copy) NSString *redbag_addr;
@property (nonatomic, assign) NSInteger redbag_number;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *fee_addr;
@property (nonatomic, assign) NSInteger share_type;
@property (nonatomic, copy) NSString *share_attr;
@property (nonatomic, copy) NSString *share_user;
@property (nonatomic, copy) NSString *share_msg;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *share_theme_url;
@property (nonatomic, copy) NSString *fee_tx_id;
@property (nonatomic, assign) BOOL done; // 红包是否开奖,1.已开奖,0.待开奖
@property (nonatomic, strong) YYRedPacketOpenedRedBagGntCategoryModel *gnt_category; // 红包发送情况

@end
