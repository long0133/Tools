//
//  DBHInputView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickButtonBlock)(NSInteger buttonType);

@interface DBHInputView : UIView

/**
 数据源
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 子菜单点击回调
 */
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock;

@end
