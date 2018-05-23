//
//  DBHGetTradingMarket.h
//  FBG
//
//  Created by yy on 2018/3/16.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHProjectDetailInformationModelData.h"

typedef void(^ResultBlock)(id response);

@interface DBHGetTradingMarket : NSObject

//@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;

+ (void)getInfomation:(NSString *)title block:(ResultBlock)block;
+ (void)addMarketVCToTarget:(UIViewController *)target model:(DBHProjectDetailInformationModelData *)model;

@end
