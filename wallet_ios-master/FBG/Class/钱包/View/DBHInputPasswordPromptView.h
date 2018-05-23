//
//  DBHInputPasswordPromptView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommitBlock)(NSString *password);

@interface DBHInputPasswordPromptView : UIView

@property (nonatomic, assign) NSInteger inputPsdType;

@property (nonatomic, copy) NSString *placeHolder;

/**
 动画显示
 */
- (void)animationShow;

/**
 提交回调
 */
- (void)commitBlock:(CommitBlock)commitBlock;


@end
