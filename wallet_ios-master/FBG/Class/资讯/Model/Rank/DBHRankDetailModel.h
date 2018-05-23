//
//  DBHRankDetailModel.h
//  FBG
//
//  Created by yy on 2018/4/2.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHInformationModelData.h"

@interface DBHRankDetailModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name_zh;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *change;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *price_cny;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, copy) NSString *volume_cny;
@property (nonatomic, copy) NSString *high_price_cny;
@property (nonatomic, copy) NSString *low_price_cny;
@property (nonatomic, copy) NSString *high_price;
@property (nonatomic, copy) NSString *low_price;
@property (nonatomic, copy) NSString *market;
@property (nonatomic, copy) NSString *market_cny;
@property (nonatomic, copy) NSString *liquidity; // 流通量
@property (nonatomic, copy) NSString *circulation; // 总量

@property (nonatomic, strong) DBHInformationModelData *projectModel;

@end
