//
//  DBHCandyBowlHeaderView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MonthChangeBlock)();
typedef void(^SelectedDateBlock)(NSDate *date);

@interface DBHCandyBowlHeaderView : UIView

@property (nonatomic, copy) NSArray *monthArray;

/**
 是否没有数据
 */
@property (nonatomic, assign) BOOL isNoData;

/**
 选择日期回调
 */
- (void)selectedDateBlock:(SelectedDateBlock)selectedDateBlock;

- (void)monthChangeBlock:(MonthChangeBlock)monthChangeBlock;

@end
