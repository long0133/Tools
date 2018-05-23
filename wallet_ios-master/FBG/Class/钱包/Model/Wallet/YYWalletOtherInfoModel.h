//
//  YYWalletOtherInfoModel.h
//  FBG
//
//  Created by yy on 2018/4/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBHWalletDetailTokenInfomationModelData;

@interface YYWalletOtherInfoModel : NSObject

@property (nonatomic, strong) NSMutableArray *tokensArray;
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *ethModel;

@end
