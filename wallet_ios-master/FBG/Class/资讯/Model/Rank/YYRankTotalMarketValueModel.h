//
//  YYRankTotalMarketValueModel.h
//  FBG
//
//  Created by yy on 2018/4/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYRankTotalMarketValueModel : NSObject

@property (nonatomic, assign) CGFloat bitcoin_percentage_of_market_cap;
@property (nonatomic, assign) CGFloat active_cryptocurrencies;
@property (nonatomic, assign) CGFloat total_volume_usd;
@property (nonatomic, assign) CGFloat active_markets;
@property (nonatomic, assign) CGFloat total_market_cap_by_available_supply_usd;

@end
