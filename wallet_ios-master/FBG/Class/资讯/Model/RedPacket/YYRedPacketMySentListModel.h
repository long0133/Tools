//
//  YYRedPacketMySentListModel.h
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YYRedPacketMySentListModel : NSObject

@property (nonatomic, assign) NSInteger redPacketId;
@property (nonatomic, copy) NSString *auth_tx_id; // 授权tx_id
@property (nonatomic, copy) NSString *redbag_tx_id; // 发送红包tx_id
@property (nonatomic, copy) NSString *fee_tx_id; // 手续费tx_id
@property (nonatomic, assign) NSInteger redbag_id;// 合约红包ID
@property (nonatomic, copy) NSString *redbag; // 红包金额
@property (nonatomic, copy) NSString *redbag_symbol; // 红包代币
@property (nonatomic, copy) NSString *redbag_addr; // 发红包钱包地址
@property (nonatomic, assign) NSInteger redbag_number; // 红包数量
@property (nonatomic, copy) NSString *fee; // 手续
@property (nonatomic, copy) NSString *fee_addr; // 手续费地址
@property (nonatomic, assign) NSInteger share_type;
@property (nonatomic, copy) NSString *share_attr;
@property (nonatomic, copy) NSString *share_user;
@property (nonatomic, copy) NSString *share_msg;
@property (nonatomic, copy) NSString *created_at; // 红包创建时间
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *share_theme_url;
@property (nonatomic, assign) BOOL done; // 红包是否完成
@property (nonatomic, assign) RedBagStatus status; // 红包状态,1.完成,2.礼金打包,3.红包创建中,4.领取中
@property (nonatomic, assign) NSInteger draw_redbag_number; // 红包已领取个数

@end
