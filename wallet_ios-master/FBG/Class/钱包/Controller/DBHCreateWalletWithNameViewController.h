//
//  DBHCreateWalletWithNameViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

typedef enum create_from {
    CreateWalletFromKeyStore = 0,
    CreateWalletFromZhuJiCi = 1,
    CreateWalletFromSiYao
}CreateWalletFrom;
@class DBHWalletManagerForNeoModelList;

@interface DBHCreateWalletWithNameViewController : DBHBaseViewController

/**
 钱包类型 1:ETH 2:NEO
 */
@property (nonatomic, assign) NSInteger walletType;

@property (nonatomic, assign) CreateWalletFrom from;

/**
 NEO钱包Model
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;


/**
 NEO钱包
 */
@property (nonatomic, strong) NeomobileWallet *neoWallet;


/**
 ETH钱包
 */
@property (nonatomic, strong) EthmobileWallet *ethWallet;


/**
 地址
 */
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *password;

@end
