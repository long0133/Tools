//
//  YYWalletConversionListModel.h
//  FBG
//
//  Created by yy on 2018/4/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYWalletConversionListGntCategoryModel.h"

@interface YYWalletConversionListModel : NSObject

@property (nonatomic, assign) NSInteger gnt_category_id;
@property (nonatomic, assign) NSInteger listId;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger wallet_id;

@property (nonatomic, strong) YYWalletConversionListGntCategoryModel *gnt_category;

@property (nonatomic, assign) NSInteger decimals;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *updated_at;

@end
