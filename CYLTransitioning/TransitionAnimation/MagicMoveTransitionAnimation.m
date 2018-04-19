//
//  MagicMoveTransitionAnimation.m
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/23.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "MagicMoveTransitionAnimation.h"

@interface MagicMoveTransitionAnimation ()

@end

@implementation MagicMoveTransitionAnimation

// 创建静态对象 防止外部访问
static MagicMoveTransitionAnimation *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+(instancetype)shareAnimator
{
    //return _instance;
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}

// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

- (instancetype)initWithFromImageV:(UIImageView *)fromImageV toImageView:(UIImageView *)toImageV
{
    if (self = [super init]) {
        self.fromImageV = fromImageV;
        self.toImageV = toImageV;
    }
    return self;
}

 - (void)showAnimationWithDuration:(CGFloat)duration transitionStyle:(CYLTransitionStyle)style andtransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (style) {
        case CYLTransitionStyle_Push:
        {
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            UIView *container = [transitionContext containerView];
            UIImageView *imageV = _fromImageV;

            [container addSubview:fromVC.view];
            [container addSubview:toVC.view];
            [container addSubview:imageV];
            _originalRect = _fromImageV.frame;
            
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
               
                fromVC.view.alpha = 0.5;
                imageV.frame = _toImageV.frame;
                
            } completion:^(BOOL finished) {
                
                _toImageV.image = imageV.image;
                [imageV removeFromSuperview];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                
            }];
        }
            break;
            
        case CYLTransitionStyle_Pop:
        {
            UIViewController *toVC =[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//            UIViewController *fromVC =[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            
            UIView *container = [transitionContext containerView];
            UIImageView *imageV = _fromImageV;
            [container addSubview:toVC.view];
            [container addSubview:imageV];
            _toImageV.image = nil;
            
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                imageV.frame = _originalRect;
                toVC.view.alpha = 1;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
