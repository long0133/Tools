//
//  DBHQuotationReminderPromptView.h
//  FBG
//
//  Created by 邓毕华 on 2018/2/7.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommitBlock)(NSString *maxValue, NSString *minValue);

@interface DBHQuotationReminderPromptView : UIView

/**
 当前价格
 */
@property (nonatomic, copy) NSString *price;

/**
 最高价
 */
@property (nonatomic, copy) NSString *maxPrice;

/**
 最低价
 */
@property (nonatomic, copy) NSString *minPrice;

/**
 动画显示
 */
- (void)animationShow;

/**
 提交回调
 */
- (void)commitBlock:(CommitBlock)commitBlock;

@end
