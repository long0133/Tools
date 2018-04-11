//
//  CYLBaseTansition.m
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/16.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "CYLTansitionManager.h"

@interface CYLTansitionManager ()
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, strong) CYLBaseTransitionAnimation *animator;
@property (nonatomic, assign) CYLTransitionStyle style;
@end

@implementation CYLTansitionManager

+ (id<UIViewControllerAnimatedTransitioning>)transitionObjectwithTransitionStyle:(CYLTransitionStyle)style animateDuration:(CGFloat)duration andTransitionAnimation:(CYLBaseTransitionAnimation *)animator
{
    CYLTansitionManager * tm = [[CYLTansitionManager alloc] init];
    tm.duration = duration;
    tm.animator = animator;
    tm.style = style;
    return tm;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [_animator showAnimationWithDuration:_duration transitionStyle:_style andtransitionContext:transitionContext];
}

@end
