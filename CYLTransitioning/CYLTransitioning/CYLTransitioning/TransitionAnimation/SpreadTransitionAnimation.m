//
//  SpreadTransitionAnimation.m
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/16.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "SpreadTransitionAnimation.h"


@interface SpreadTransitionAnimation ()
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation SpreadTransitionAnimation

- (instancetype)initWithSpreadBtn:(UIButton *)spreadBtn
{
    if (self = [super init]) {
        self.fromSpreadBtn = spreadBtn;
    }
    return self;
}

- (void)showAnimationWithDuration:(CGFloat)duration transitionStyle:(CYLTransitionStyle)style andtransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.style = style;
    self.transitionContext = transitionContext;
    
    switch (style) {
        case CYLTransitionStyle_Present:
        {
//            UIViewController *fromVC = ((UINavigationController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]).viewControllers.lastObject;
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            UIView *containerView = [transitionContext containerView];
            [containerView addSubview:toVC.view];
            
            CGRect circleFrame = _fromSpreadBtn.frame;
            CGFloat x = MAX(circleFrame.origin.x, containerView.bounds.size.width - circleFrame.origin.x);
            CGFloat y = MAX(circleFrame.origin.y, containerView.bounds.size.height - circleFrame.origin.y);
            CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
            UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
            UIBezierPath * endPath = [UIBezierPath bezierPathWithArcCenter:_fromSpreadBtn.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            
            CAShapeLayer *mask = [[CAShapeLayer alloc] init];
            mask.path = endPath.CGPath;
            mask.shadowOffset = CGSizeMake(2, 2);
            toVC.view.layer.mask = mask;

            CABasicAnimation *anim = [[CABasicAnimation alloc] init];
            anim.keyPath = @"path";
            anim.duration = duration;
            anim.fromValue = (__bridge id _Nullable)(startPath.CGPath);
            anim.toValue = (__bridge id _Nullable)(endPath.CGPath);
            anim.delegate = self;
            [mask addAnimation:anim forKey:nil];
        }
            break;
        case CYLTransitionStyle_Dismiss:
        {
            UIViewController *toVC = ((UINavigationController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]).viewControllers.lastObject;
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            
            [[transitionContext containerView] addSubview:[toVC.navigationController.view snapshotViewAfterScreenUpdates:YES]];
            [[transitionContext containerView] addSubview:fromVC.view];
            
            CGRect circleFrame = _fromSpreadBtn.frame;
            
            CGPathRef startPath = ((CAShapeLayer*)fromVC.view.layer.mask).path;
            UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
            
            CAShapeLayer *mask = [[CAShapeLayer alloc] init];
            mask.path = endPath.CGPath;
            fromVC.view.layer.mask = mask;
            
            CABasicAnimation *anim = [[CABasicAnimation alloc] init];
            anim.keyPath = @"path";
            anim.duration = duration;
            anim.fromValue = (__bridge id _Nullable)(startPath);
            anim.toValue = (__bridge id _Nullable)(endPath.CGPath);
            anim.delegate = self;
            [mask addAnimation:anim forKey:nil];
            
        }
            break;
        case CYLTransitionStyle_Push:
        {
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            UIView *containerView = [transitionContext containerView];
            [containerView addSubview:[fromVC.view snapshotViewAfterScreenUpdates:YES]];
            [containerView addSubview:toVC.view];
            
            CGRect circleFrame = _fromSpreadBtn.frame;
            CGFloat x = MAX(circleFrame.origin.x, containerView.bounds.size.width - circleFrame.origin.x);
            CGFloat y = MAX(circleFrame.origin.y, containerView.bounds.size.height - circleFrame.origin.y);
            CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2)) + 50;
            UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
            UIBezierPath * endPath = [UIBezierPath bezierPathWithArcCenter:_fromSpreadBtn.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            
            CAShapeLayer *mask = [[CAShapeLayer alloc] init];
            mask.path = endPath.CGPath;
            mask.shadowOffset = CGSizeMake(2, 2);
            toVC.view.layer.mask = mask;
            
            CABasicAnimation *anim = [[CABasicAnimation alloc] init];
            anim.keyPath = @"path";
            anim.duration = duration;
            anim.fromValue = (__bridge id _Nullable)(startPath.CGPath);
            anim.toValue = (__bridge id _Nullable)(endPath.CGPath);
            anim.delegate = self;
            [mask addAnimation:anim forKey:nil];

        }
            break;
            
        case CYLTransitionStyle_Pop:
        {
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            
            [[transitionContext containerView] addSubview:toVC.view];
            [[transitionContext containerView] addSubview:fromVC.view];
            
            CGRect circleFrame = _fromSpreadBtn.frame;
            CGPathRef startPath = ((CAShapeLayer*)fromVC.view.layer.mask).path;
            UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
            
            CAShapeLayer *mask = [[CAShapeLayer alloc] init];
            mask.path = endPath.CGPath;
            fromVC.view.layer.mask = mask;
            
            CABasicAnimation *anim = [[CABasicAnimation alloc] init];
            anim.keyPath = @"path";
            anim.duration = duration;
            anim.fromValue = (__bridge id _Nullable)(startPath);
            anim.toValue = (__bridge id _Nullable)(endPath.CGPath);
            anim.delegate = self;
            [mask addAnimation:anim forKey:nil];

        }
            break;
        default:
            break;
    }
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.style == CYLTransitionStyle_Present) {
        [self.transitionContext completeTransition:YES];
//        [_transitionContext viewControllerForKey:UITransitionContextToViewKey].view.layer.mask = nil;
    }
    else
    {
        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
        if ([_transitionContext transitionWasCancelled]) {
            [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        }
        
    }
}

@end
