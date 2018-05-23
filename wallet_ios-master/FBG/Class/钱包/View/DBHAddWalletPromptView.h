//
//  DBHAddWalletPromptView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSInteger index);

@interface DBHAddWalletPromptView : UIView

/**
 动画显示
 */
- (void)animationShow;

/**
 选择回调
 */
- (void)selectedBlock:(SelectedBlock)selectedBlock;

- (void)boxViewAtInit;
- (void)animateFromLeftShow;
@end
