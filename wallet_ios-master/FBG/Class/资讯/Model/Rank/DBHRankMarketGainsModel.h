//
//  DBHRankMarketGainsModel.h
//  FBG
//
//  Created by yy on 2018/3/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//  市值涨幅model

#import <Foundation/Foundation.h>

@interface DBHRankMarketGainsModel : NSObject

@property (nonatomic, copy) NSString *rank; // 排名
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *symbol; // 单位
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *price; // 美元当前价格
@property (nonatomic, copy) NSString *price_cny; // 人民币当前价格

@property (nonatomic, copy) NSString *volume; // 24小时美元交易量
@property (nonatomic, copy) NSString *volume_cny; // 24小时人民币交易量
@property (nonatomic, copy) NSString *change; // 24小时涨跌幅

@property (nonatomic, copy) NSString *market; // 24小时美元市值
@property (nonatomic, copy) NSString *market_cny; // 24小时人民币市值


@end
