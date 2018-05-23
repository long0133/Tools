//
//  DBHWalletManagerForNeoModelList.h
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYWalletRecordGntModel.h"
@class NeomobileWallet;
@class EthmobileWallet;

@class DBHWalletManagerForNeoModelCategory;
@class DBHProjectDetailInformationModelIco;
@class YYWalletOtherInfoModel;
@class DBHWalletDetailTokenInfomationModelData;

@interface DBHWalletManagerForNeoModelList : NSObject

@property (nonatomic, strong) DBHWalletManagerForNeoModelCategory *category;
@property (nonatomic, strong) DBHProjectDetailInformationModelIco *cap;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger listIdentifier;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *deletedAt;
@property (nonatomic, strong) NSString *addressHash160;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, strong) NSString *balance; // 数量
@property (nonatomic, strong) NSArray *gnt; // 数量

@property (nonatomic, strong) NSMutableDictionary *tokenStatistics; // 代币统计
@property (nonatomic, assign) BOOL isLookWallet; // 是否观察钱包
@property (nonatomic, assign) BOOL isBackUpMnemonnic; // 是否备份助记词
@property (nonatomic, strong) NeomobileWallet *neoWallet;
@property (nonatomic, strong) EthmobileWallet *ethWallet;
@property (nonatomic, strong) YYWalletOtherInfoModel *infoModel; // 只是ETH钱包  ETH代币列表，ETHModel

@end
