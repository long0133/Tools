//
//  YYRedPacketDetailModel.h
//  FBG
//
//  Created by yy on 2018/5/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
// /redbag/send_record/:id

#import <Foundation/Foundation.h>

@interface YYRedPacketDetailModel : NSObject

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
@property (nonatomic, assign) RedBagStatus status; // 红包状态,1.完成,2.礼金打包,3.红包创建中,4.领取中, -2.礼金打包失败(授权失败),-3.红包创建失败
@property (nonatomic, assign) NSInteger draw_redbag_number; // 红包已领取个数
@property (nonatomic, assign) NSInteger auth_block; // 授权块高
@property (nonatomic, assign) NSInteger redbag_block; // 红包块高
@property (nonatomic, assign) NSInteger fee_block; // 手续费块高
@property (nonatomic, assign) NSInteger redbag_back_block; // 红包退回块高
@property (nonatomic, copy) NSString *redbag_back; // 红包退回金额
@property (nonatomic, copy) NSString *redbag_back_tx_id; // 红包退回tx_id
@property (nonatomic, strong) YYRedPacketRedBagInfoModel *redbag_info;
@property (nonatomic, strong) NSArray *draws;
@property (nonatomic, strong) YYRedPacketOpenedRedBagGntCategoryModel *gnt_category; // 红包发送情况

@end
