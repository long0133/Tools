//
//  DBHExchangeRankModel.h
//  FBG
//
//  Created by yy on 2018/4/2.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBHExchangeRankTypeModel;

@interface DBHExchangeRankModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, copy) NSString *volume_cny;
@property (nonatomic, strong) DBHExchangeRankTypeModel *type;
@property (nonatomic, copy) NSString *trade_ratio;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *website;

@end
