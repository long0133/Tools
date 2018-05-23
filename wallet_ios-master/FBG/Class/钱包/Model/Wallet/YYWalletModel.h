//
//  YYWalletModel.h
//  FBG
//
//  Created by yy on 2018/4/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYWalletModel : NSObject

//@property (nonatomic, strong) DBHWalletManagerForNeoModelCategory *category;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *deleted_at;
@property (nonatomic, copy) NSString *address_hash160;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger walletId; 
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger user_id;


@end
