//
//  DBHAddressBookMenuView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSInteger index);

@interface DBHAddressBookMenuView : UIView

/**
 数据源
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 动画显示
 */
- (void)animationShow;

/**
 选择回调
 */
- (void)selectedBlock:(SelectedBlock)selectedBlock;

@end
