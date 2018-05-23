//
//  DBHMarketDetailViewModel.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHMarketDetailViewModel.h"

#import "DBHMarketDetailKLineViewDataModels.h"
#import "DBHMarketDetailMoneyRealTimePriceDataModels.h"

@interface DBHMarketDetailViewModel ()


@property (nonatomic, copy) NSString *ico_type;
/** 计时器 */
@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, copy) RequestMoneyRealTimePriceBlock requestMoneyRealTimePriceBlock;
@property (nonatomic, copy) RequestBlock requestBlock;

@end

@implementation DBHMarketDetailViewModel

#pragma mark ------ Lifecycle ------
- (void)dealloc {
    [self setTimernil];
}

- (void)setTimernil {
    [self.timer invalidate];
    _timer = nil;
}

#pragma mark ------ Data ------
/**
 获取货币实时价格
 */
- (void)getMoneyRealTimePrice {
    NSLog(@"getMoneyRealTimePrice  self.timer = %@", self.timer);
    WEAKSELF
    if (self.timer) { //TODO
        [PPNetworkHelper GET:[NSString stringWithFormat:@"ico/time_price/%@", self.ico_type] baseUrlType:3 parameters:nil hudString:nil responseCache:^(id responseCache) {
            DBHMarketDetailMoneyRealTimePriceModelData *model = [DBHMarketDetailMoneyRealTimePriceModelData modelObjectWithDictionary:responseCache];
            
            weakSelf.requestMoneyRealTimePriceBlock(model);
        } success:^(id responseObject) {
            DBHMarketDetailMoneyRealTimePriceModelData *model = [DBHMarketDetailMoneyRealTimePriceModelData modelObjectWithDictionary:responseObject];
            
            weakSelf .requestMoneyRealTimePriceBlock(model);
        } failure:^(NSString *error) {
            
        } specialBlock:^{
            if (![UserSignData share].user.isLogin) {
                return ;
            }
        }];
    }
}

#pragma mark ------ Public Methods ------
- (void)requestMoneyRealTimePriceBlock:(RequestMoneyRealTimePriceBlock)requestMoneyRealTimePriceBlock {
    self.requestMoneyRealTimePriceBlock = requestMoneyRealTimePriceBlock;
}
- (void)requestBlock:(RequestBlock)requestBlock {
    self.requestBlock = requestBlock;
}
- (void)getKLineDataWithIco_type:(NSString *)ico_type interval:(NSString *)interval {
    WEAKSELF
    if ([NSObject isNulllWithObject:ico_type]) {
        return;
    }
    [PPNetworkHelper GET:[NSString stringWithFormat:@"ico/currencies/%@/%@/%@", ico_type, @"usdt", interval] baseUrlType:2 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) responseCache:^(id responseCache) {
        NSArray *dataArray = responseCache;
        
        if (!dataArray.count) {
            weakSelf.requestBlock(@[]);
            return ;
        }
        
        NSMutableArray *kLineDataArray = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            DBHMarketDetailKLineViewModelData *model = [DBHMarketDetailKLineViewModelData modelObjectWithDictionary:dic];
            
            [kLineDataArray addObject:model];
        }
        
        weakSelf.requestBlock(kLineDataArray);
    } success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        
        if (!dataArray.count) {
            weakSelf.requestBlock(@[]);
            return ;
        }
        
        NSMutableArray *kLineDataArray = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            DBHMarketDetailKLineViewModelData *model = [DBHMarketDetailKLineViewModelData modelObjectWithDictionary:dic];
            
            [kLineDataArray addObject:model];
        }
        
        weakSelf.requestBlock(kLineDataArray);
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"No Data", nil)];
    } specialBlock:^{
        if (![UserSignData share].user.isLogin) {
            return ;
        }
    }];
}
- (void)getMoneyRealTimePriceWithIco_type:(NSString *)ico_type isRunLoop:(BOOL)isLoop {
    self.ico_type = ico_type;
    [self getMoneyRealTimePrice];
    
    if (isLoop) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getMoneyRealTimePrice) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

@end
