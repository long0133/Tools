//
//  DBHMarketDetailViewModel.h
//  FBG
//
//  Created by 邓毕华 on 2017/12/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHMarketDetailMoneyRealTimePriceModelData;

typedef void(^RequestMoneyRealTimePriceBlock)(DBHMarketDetailMoneyRealTimePriceModelData *moneyRealTimePriceModel);
typedef void(^RequestBlock)(NSArray *kLineDataArray);

@interface DBHMarketDetailViewModel : NSObject

/**
 货币实时价格请求成功回调
 */
- (void)requestMoneyRealTimePriceBlock:(RequestMoneyRealTimePriceBlock)requestMoneyRealTimePriceBlock;

/**
 k线图请求成功回调
 */
- (void)requestBlock:(RequestBlock)requestBlock;

/**
 请求k线图数据

 @param ico_type 货币类型
 @param interval 时间间隔
 */
- (void)getKLineDataWithIco_type:(NSString *)ico_type interval:(NSString *)interval;

/**
 获取货币实时价格

 @param ico_type 货币类型
 */
- (void)getMoneyRealTimePriceWithIco_type:(NSString *)ico_type isRunLoop:(BOOL)isLoop;
- (void)setTimernil;
@end
