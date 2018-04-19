//
//  CYLRefereshBaseView.h
//  CYLReferesh
//
//  Created by chinapex on 2018/4/9.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLRefereshConstant.h"
#import <Masonry.h>

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, RefreshState) {
    /** 普通闲置状态 */
    RefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    RefreshStatePulling,
    /** 正在刷新中的状态 */
    RefreshStateRefreshing,
    /** 所有数据加载完毕，没有更多的数据了 */
    RefreshStateNoMoreData
};

#define headerFooterColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]

@interface CYLRefereshBaseView : UIView
@property (nonatomic, assign) RefreshState state; /**< 刷新控件的状态 */
@property (nonatomic, strong) UIScrollView *scrollView;/**< 父控件scrollView */
@end
