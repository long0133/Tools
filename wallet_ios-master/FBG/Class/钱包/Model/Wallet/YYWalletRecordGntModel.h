//
//  YYWalletRecordGntModel.h
//  FBG
//
//  Created by yy on 2018/4/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBHProjectDetailInformationModelIco;

@interface YYWalletRecordGntModel : NSObject

@property (nonatomic, copy) NSString *available;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, strong) DBHProjectDetailInformationModelIco *cap;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *unavailable;


//@property (nonatomic, assign) NSInteger gnt_category_id;
//@property (nonatomic, assign) NSInteger gntId;
//@property (nonatomic, assign) NSInteger sort;
//@property (nonatomic, assign) NSInteger user_id;
//@property (nonatomic, assign) NSInteger wallet_id;
//@property (nonatomic, assign) NSInteger decimals;

@end
