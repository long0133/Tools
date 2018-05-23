//
//  WalletLeftListModel.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/8.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@interface WalletLeftListModel : BaseModel
/*
 id                  int             钱包id
 category_id     int             钱包类型ID
 name                string          钱包名称
 address         string          钱包地址
 created_at      string          创建时间
 category            array           钱包类型信息
 
 category字段说明:
 
 name            string          钱包类型
 */

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int category_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * category_name;
@property (nonatomic, copy) NSString * img;

//判断是不是观察钱包
@property (nonatomic, assign) BOOL isLookWallet;
//判断是不是备份钱包
@property (nonatomic, assign) BOOL isNotBackupsWallet;

@end
