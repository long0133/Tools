//
//  CYLRefereshBaseView.h
//  CYLReferesh
//
//  Created by chinapex on 2018/4/9.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, RefreshState) {
    /** 普通闲置状态 */
    RefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    RefreshStatePulling,
    /** 正在刷新中的状态 */
    RefreshStateRefreshing,
    /** 即将刷新的状态 */
    RefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    RefreshStateNoMoreData
};

@interface CYLRefereshBaseView : UIView
@property (nonatomic, assign) RefreshState state; /**< 刷新控件的状态 */
@end
