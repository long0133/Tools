//
//  CYLTansitionAnimationOne.m
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/11/15.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "CYLTansitionAnimationOne.h"

@interface CYLTansitionAnimationOne()
@property (nonatomic, strong) UIImageView *snapView;
@end

@implementation CYLTansitionAnimationOne
singleM(TansitionAnimationOne);
- (void)showAnimationWithDuration:(CGFloat)duration transitionStyle:(CYLTransitionStyle)style andtransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    if (style == CYLTransitionStyle_Push || style == CYLTransitionStyle_Present) {
        
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        _snapView = [[UIImageView alloc] initWithImage:[UIImage getWindowSnapshotImage]];

        [containerView addSubview:_snapView];
        [containerView addSubview:toVC.view];
        
        toVC.view.alpha = 0;
        [UIView animateWithDuration:duration animations:^{
            
            toVC.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }
    else if (style == CYLTransitionStyle_Pop || style == CYLTransitionStyle_Dismiss){
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        
        [containerView addSubview:toVC.view];
        [containerView addSubview:fromVC.view];
        
        toVC.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.5];;
        [UIView animateWithDuration:duration animations:^{
            toVC.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [_snapView removeFromSuperview];
        }];
    }
}
@end
