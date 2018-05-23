//
//  UserModel.h
//  FBG
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"
//#import "WalletLeftListModel.h"

typedef enum : NSUInteger {
    DBHCanUseUnlockTypeNone,      // 都不可用
    DBHCanUseUnlockTypeTouchID,   // Touch ID可用
    DBHCanUseUnlockTypeFaceID,    // Face ID可用
} DBHCanUseUnlockType;

@interface UserModel : BaseModel <NSCoding>

//储存字段

#pragma mark -- 用户基本信息
@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * open_id;
@property (nonatomic, copy) NSString * email; // 账号
@property (nonatomic, copy) NSString * nickname; //昵称
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSString * language; // 设置为cns或者en
@property (nonatomic, copy) NSString *invitationCode; // 邀请码
@property (nonatomic, assign) BOOL isLogin; // 是否登录
@property (nonatomic, assign) BOOL isFirstRegister; // 首次注册
@property (nonatomic, assign) BOOL isCode; //是不是从冷钱包进入
@property (nonatomic, assign) int walletUnitType; // 1 = rmb  2 = usd
@property (nonatomic, assign) BOOL isHideAsset; // 是否隐藏资产
@property (nonatomic, assign) BOOL isOpenTouchId; // 是否开启TouchID
@property (nonatomic, assign) BOOL isOpenFaceId; // 是否开启FaceID
@property (nonatomic, assign) DBHCanUseUnlockType canUseUnlockType; // 可以使用的第三方解锁方式
@property (nonatomic, strong) NSMutableArray *functionalUnitArray; // 功能组件是否删除数组 0:未删除 1:删除
@property (nonatomic, strong) NSMutableArray *realTimeDeliveryArray; // 功能组件是否开启实时资讯推送 0:未开启 1:开启

@property (nonatomic, strong) NSArray *sortedTokenFlags; // 代币的排序数组

@property (nonatomic, copy) NSString * API;
@property (nonatomic, copy) NSString * IMAGE;

#pragma mark -- 用户余额信息
@property (nonatomic, assign) BOOL isRefeshAssets; //需不需要刷新价格
@property (nonatomic, copy) NSString * totalAssets_cny;   //人民币总资产
@property (nonatomic, copy) NSString * totalAssets_usd;   //美元总资产
@property (nonatomic, copy) NSString * ETHAssets_ether;   //ETH资产数量
@property (nonatomic, copy) NSString * ETHAssets_cny;   //ETH资产人民币价值
@property (nonatomic, copy) NSString * ETHAssets_usd;   //ETH资产美元价值
@property (nonatomic, copy) NSString * NEOAssets_ether;   //NEO资产数量
@property (nonatomic, copy) NSString * NEOAssets_cny;   //NEO资产人民币价值
@property (nonatomic, copy) NSString * NEOAssets_usd;   //NEO资产美元价值
@property (nonatomic, copy) NSString * BTCAssets_ether;   //BTC资产数量
@property (nonatomic, copy) NSString * BTCAssets_cny;   //BTC资产人民币价值
@property (nonatomic, copy) NSString * BTCAssets_usd;   //BTC资产美元价值

#pragma mark -- 用户钱包信息
@property (nonatomic, strong) NSMutableArray * walletIdsArray;// 备份钱包ids
@property (nonatomic, strong) NSMutableArray * codeWalletsArray; //冷钱包进入本地钱包数组
@property (nonatomic, strong) NSMutableArray * walletZhujiciIdsArray;// 备份钱包ids  (助记词)

@end
