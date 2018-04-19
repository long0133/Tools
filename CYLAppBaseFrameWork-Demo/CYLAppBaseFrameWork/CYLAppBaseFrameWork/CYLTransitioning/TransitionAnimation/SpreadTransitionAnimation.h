//
//  SpreadTransitionAnimation.h
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/16.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "CYLBaseTransitionAnimation.h"

@interface SpreadTransitionAnimation : CYLBaseTransitionAnimation<CAAnimationDelegate>
@property (nonatomic, assign) CYLTransitionStyle style;

@property (nonatomic, strong) UIButton *fromSpreadBtn;

- (instancetype)initWithSpreadBtn:(UIButton*)spreadBtn;
@end
