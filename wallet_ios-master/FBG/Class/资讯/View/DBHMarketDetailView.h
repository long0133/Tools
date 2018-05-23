//
//  DBHMarketDetailView.h
//  FBG
//
//  Created by 邓毕华 on 2017/11/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBHMarketDetailMoneyRealTimePriceModelData;

@interface DBHMarketDetailView : UIView

@property (nonatomic, strong) DBHMarketDetailMoneyRealTimePriceModelData *model;

/**
 项目ID
 */
@property (nonatomic, copy) NSString *projectId;

@property (nonatomic, copy) NSString *isMarketFollow;

@property (nonatomic, copy) NSString *max;

@property (nonatomic, copy) NSString *min;

@end
