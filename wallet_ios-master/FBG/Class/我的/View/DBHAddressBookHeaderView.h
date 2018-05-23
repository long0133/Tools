//
//  DBHAddressBookHeaderView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedTypeBlock)(NSInteger type);

@interface DBHAddressBookHeaderView : UIView

/**
 当前选中下标
 */
@property (nonatomic, assign) NSInteger currentSelectedIndex;

/**
 选中类型
 */
- (void)selectedType:(NSInteger)type;

/**
 选择类型回调
 */
- (void)selectedTypeBlock:(SelectedTypeBlock)selectedTypeBlock;

@end
