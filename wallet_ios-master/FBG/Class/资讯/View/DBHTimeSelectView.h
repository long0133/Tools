//
//  DBHTimeSelectView.h
//  FBG
//
//  Created by 邓毕华 on 2017/12/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTimeBlock)(NSString *time);

@class DBHMarketDetailKLineViewModelData;

@interface DBHTimeSelectView : UIView

/**
 是否显示数据统计
 */
@property (nonatomic, assign) BOOL isShowData;

@property (nonatomic, strong) DBHMarketDetailKLineViewModelData *model;

/**
 当前选中下标
 */
@property (nonatomic, assign) NSInteger currentSelectedIndex;

/**
 下标对应的值
 */
@property (nonatomic, copy) NSArray *timeValueArray;

/**
 选择时间格式回调
 */
- (void)clickTimeBlock:(ClickTimeBlock)clickTimeBlock;

@end
