//
//  DBHInputPasswordNamePromptView.h
//  FBG
//
//  Created by yy on 2018/3/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommitBlock)(NSString *password);

@interface DBHInputPasswordNamePromptView : UIView

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger inputPsdType;

/**
 动画显示
 */
- (void)animationShow;

/**
 提交回调
 */
- (void)commitBlock:(CommitBlock)commitBlock;

@end
