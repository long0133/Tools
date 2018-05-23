//
//  DBHGetTradingMarket.m
//  FBG
//
//  Created by yy on 2018/3/16.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHGetTradingMarket.h"
#import "PPNetworkHelper.h"
#import "DBHTradingMarketModelData.h"
#import "DBHTradingMarketViewController.h"

@interface DBHGetTradingMarket()

@end

@implementation DBHGetTradingMarket

/**
 获取TradingView数据
 */
+ (void)getInfomation:(NSString *)title block:(ResultBlock)block {
    [PPNetworkHelper GET:[NSString stringWithFormat:@"ico/markets/%@/all", title] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
        if(block) {
            block(responseCache);
        }
    } success:^(id responseObject) {
        if(block) {
            block(responseObject);
        }
    } failure:^(NSString *error) {
        if(block) {
            block(nil);
        }
    } specialBlock:nil];
}
//        for (NSDictionary *dic in responseObject) {
//            DBHTradingMarketModelData *model = [DBHTradingMarketModelData modelObjectWithDictionary:dic];
//
//            [weakSelf.dataSource addObject:model];
//        }

+ (void)addMarketVCToTarget:(UIViewController *)target model:(DBHProjectDetailInformationModelData *)model {
    DBHTradingMarketViewController *tradingMarketViewController = [[DBHTradingMarketViewController alloc] init];
    tradingMarketViewController.title = model.unit;
    tradingMarketViewController.chatRoomId = [NSString stringWithFormat:@"%ld", (NSInteger)model.roomId];
    
    [target.view addSubview:tradingMarketViewController.view];
//    [self.navigationController pushViewController:tradingMarketViewController animated:YES];
}
@end
