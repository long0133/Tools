//
//  DBHInformationTitleView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickButtonBlock)(NSInteger type);

@interface DBHInformationTitleView : UIView

@property (nonatomic, strong) UIButton *moreButton;

/**
 点击按钮回调 0:搜索 1:+号
 */
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock;

@end
