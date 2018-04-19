//
//  CardPopUpTransitionAnimation.m
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/26.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "CardPopUpTransitionAnimation.h"
#import "UIImage+Blur.h"
#import "FXBlurView.h"

@interface CardPopUpTransitionAnimation ()
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isSpring;
@property (nonatomic, assign) BOOL isRound;
@property (nonatomic, strong) FXBlurView *imageV;
@end

@implementation CardPopUpTransitionAnimation

- (instancetype)initWithHeight:(CGFloat)height SpringAnim:(BOOL)isSpring andRoundCornor:(BOOL)isRound
{
    if (self = [super init]) {
        self.height = height;
        self.isSpring = isSpring;
        self.isRound = isRound;
    }
    
    return self;
}

- (void)showAnimationWithDuration:(CGFloat)duration transitionStyle:(CYLTransitionStyle)style andtransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (style) {
        case CYLTransitionStyle_Present:
        {
            UINavigationController *FromNav = (UINavigationController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *ToVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            ToVc.view.layer.cornerRadius = 5;
            CGRect frame = ToVc.view.frame;
            ToVc.view.frame = CGRectMake(5, frame.size.height, frame.size.width-10, frame.size.height);
            ToVc.view.layer.cornerRadius = 10;
            _imageV = [[FXBlurView alloc] initWithFrame:FromNav.view.frame];
            _imageV.backgroundColor = [UIColor whiteColor];
            _imageV.dynamic = YES;
            _imageV.underlyingView = FromNav.view;
            
            UIView *container = [transitionContext containerView];
            container.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
//            [container addSubview:FromNav.view];
            [container addSubview:_imageV];
            [container addSubview:ToVc.view];
            
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:self.isSpring? 0.8 : 1.0 initialSpringVelocity:0 options:0 animations:^{
                
                _imageV.blurRadius = 20;
                ToVc.view.transform = CGAffineTransformMakeTranslation(0, -_height);
                
            } completion:^(BOOL finished) {
                
                [transitionContext completeTransition:YES];
            }];
        }
            break;
            
        case CYLTransitionStyle_Dismiss:
        {
            UIViewController *FromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UINavigationController *toNav = (UINavigationController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            UIView *container = [transitionContext containerView];
            [container addSubview:_imageV];
            [container addSubview:FromVc.view];
            
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:_isSpring ? 0.8 : 1 initialSpringVelocity:0 options:0 animations:^{
               
                FromVc.view.transform = CGAffineTransformIdentity;
                _imageV.blurRadius = 0;
                
            } completion:^(BOOL finished) {
                
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                [_imageV removeFromSuperview];
                toNav.view.hidden = NO;                
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
