//
//  YYWalletConversionListGntCategoryModel.h
//  FBG
//
//  Created by yy on 2018/4/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBHProjectDetailInformationModelIco;
@class YYWalletCategoryIcoInfoModel;

@interface YYWalletConversionListGntCategoryModel : NSObject

@property (nonatomic, copy) NSString *address; // 合约地址
@property (nonatomic, strong) DBHProjectDetailInformationModelIco *cap;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *gntCategoryId; 
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *gas;
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger decimals;

@property (nonatomic, strong) YYWalletCategoryIcoInfoModel *ico_info;

@end
