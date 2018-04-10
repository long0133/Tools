//
//  Animator.m
//  CYLReferesh
//
//  Created by chinapex on 2018/4/9.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "Animator.h"
#import "CYLRefereshConstant.h"

#define refreshArrowWidth 6
#define refreshArrowHeight 20
#define arrowAngle M_PI/4.0
#define globleAnimaDuration 0.3
#define KAnimationName @"KAnimationName"
#define aliceBlue color255(192, 192, 192)

@interface Animator()<CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *rotationLayer;
@property (nonatomic, strong) UIView *canvas;
@property (nonatomic, copy) dispatch_block_t triggerActionBlock;
@end

@implementation Animator
#pragma mark - pulling
- (void)showArrowOnCanvas:(UIView *)view{
    self.canvas = view;
    self.arrowLayer.path = [self drawDownArrow].CGPath;
    [self.canvas.layer addSublayer:self.arrowLayer];
    
    self.lineLayer.path = [self drawLineLayer].CGPath;
    [self.canvas.layer addSublayer:self.lineLayer];
}

- (UIBezierPath*)drawDownArrow{
    CGPoint startPoint = CGPointMake(CGRectGetWidth(self.canvas.frame)/2.0, CGRectGetHeight(self.canvas.frame));
    CGPoint leftPoint = CGPointMake(startPoint.x - refreshArrowWidth, startPoint.y - (tan(arrowAngle)*refreshArrowWidth));
    CGPoint rightPoint = CGPointMake(startPoint.x + refreshArrowWidth, startPoint.y - (tan(arrowAngle)*refreshArrowWidth));

    // Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:leftPoint];
    [bezierPath addLineToPoint:startPoint];
    [bezierPath addLineToPoint:rightPoint];
    return bezierPath;
}

- (UIBezierPath*)drawLineLayer{
    CGPoint startPoint = CGPointMake(CGRectGetWidth(self.canvas.frame)/2.0, CGRectGetHeight(self.canvas.frame));
    CGPoint endPoint = CGPointMake(startPoint.x, 0);
    // Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath addLineToPoint:endPoint];
    return bezierPath;
}

#pragma mark - refreshing
//箭头变化部分
- (void)showRefreshAnimationCanTriggerActionBlock:(dispatch_block_t)block{
    self.triggerActionBlock = block;
    
    CAAnimationGroup *groupAnim = [[CAAnimationGroup alloc] init];
    
    CABasicAnimation *lineEndAnim = [[CABasicAnimation alloc] init];
    lineEndAnim.keyPath = @"strokeEnd";
    lineEndAnim.duration = globleAnimaDuration;
    lineEndAnim.toValue = @1;
    
    CABasicAnimation *lineStartAnim = [[CABasicAnimation alloc] init];
    lineStartAnim.keyPath = @"strokeStart";
    lineStartAnim.duration = globleAnimaDuration;
    lineStartAnim.toValue = @1;
    
    groupAnim.animations = @[lineStartAnim, lineEndAnim];
    groupAnim.removedOnCompletion = NO;
    groupAnim.fillMode = kCAFillModeForwards;
    groupAnim.delegate = self;
    [groupAnim setValue:@"arrowAnimation" forKey:KAnimationName];
    [self.lineLayer addAnimation:groupAnim forKey:@"arrowAnimation"];
    
    
    CABasicAnimation *arrowOpacity = [[CABasicAnimation alloc] init];
    arrowOpacity.keyPath = @"opacity";
    arrowOpacity.duration = globleAnimaDuration-0.2;
    arrowOpacity.toValue = @1;
    arrowOpacity.removedOnCompletion = NO;
    arrowOpacity.fillMode = kCAFillModeBackwards;
    arrowOpacity.delegate = self;
    [arrowOpacity setValue:@"arrowOpacity" forKey:KAnimationName];
    [self.arrowLayer addAnimation:arrowOpacity forKey:@"arrowOpacity"];
}

//圆圈变化部分
- (void)showRefreshCircle{
    self.circleLayer.path = [self drawCircleLayer].CGPath;
    [self.canvas.layer addSublayer:self.circleLayer];
}

- (void)showRotationAnimation{
    self.rotationLayer.path = [self drawFragileLayer].CGPath;
    [self.canvas.layer addSublayer:self.rotationLayer];

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.canvas.layer addAnimation:rotationAnimation forKey:@"ss"];

}

- (UIBezierPath*)drawCircleLayer{
    CGFloat radius = CGRectGetHeight(self.canvas.frame)/2.0;
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.canvas.frame)/2.0,  CGRectGetHeight(self.canvas.frame)/2.0);
    // Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath] ;
    [bezierPath addArcWithCenter:centerPoint radius:radius startAngle:M_PI*1.5 endAngle:M_PI*1.499 clockwise:YES];
    return bezierPath;
}

- (UIBezierPath*)drawFragileLayer{
    CGFloat radius = CGRectGetHeight(self.canvas.frame)/2.0;
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.canvas.frame)/2.0,  CGRectGetHeight(self.canvas.frame)/2.0);
    // Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath] ;
    [bezierPath addArcWithCenter:centerPoint radius:radius startAngle:M_PI*1.5 endAngle:M_PI*1.45 clockwise:NO];
    return bezierPath;
}

#pragma mark - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSString *animName = [anim valueForKey:KAnimationName];
    
    if ([animName isEqualToString:@"arrowOpacity"]) {
        self.arrowLayer.hidden = YES;
    }
    
    if ([animName isEqualToString:@"arrowAnimation"]) {
        self.lineLayer.hidden = YES;
        [self showRefreshCircle];
        [self showRotationAnimation];
        if (self.triggerActionBlock) {
            self.triggerActionBlock();
        }
    }
}

- (void)clear{
    [self.arrowLayer removeFromSuperlayer];
    [self.lineLayer removeFromSuperlayer];
    [self.circleLayer removeFromSuperlayer];
    [self.rotationLayer removeFromSuperlayer];
    [self.canvas.layer removeAllAnimations];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forLayer:(CALayer *)layer
{
    CGPoint oldOrigin = layer.frame.origin;
    layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = layer.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    layer.position = CGPointMake (layer.position.x - transition.x, layer.position.y - transition.y);
}

#pragma mark - getter setter
- (CAShapeLayer *)arrowLayer{
    if (!_arrowLayer) {
        _arrowLayer = [[CAShapeLayer alloc] init];
        _arrowLayer.strokeColor = aliceBlue.CGColor;
        _arrowLayer.fillColor = [UIColor clearColor].CGColor;
        _arrowLayer.lineWidth = 2;
        _arrowLayer.lineCap = kCALineCapRound;
    }
    return _arrowLayer;
}

- (CAShapeLayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [[CAShapeLayer alloc] init];
        _lineLayer.strokeColor = aliceBlue.CGColor;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        _lineLayer.lineWidth = 2;
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.strokeEnd = 0.45;
    }
    return _lineLayer;
}

- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.strokeColor = aliceBlue.CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineWidth = 2;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.strokeEnd = 0.96;
    }
    return _circleLayer;
}

- (CAShapeLayer *)rotationLayer{
    if (!_rotationLayer) {
        _rotationLayer = [[CAShapeLayer alloc] init];
        _rotationLayer.strokeColor = color255(240, 248, 255).CGColor;
        _rotationLayer.fillColor = [UIColor clearColor].CGColor;
        _rotationLayer.lineWidth = 2;
        _rotationLayer.lineCap = kCALineCapRound;
//        [self setAnchorPoint:CGPointMake(CGRectGetWidth(_canvas.frame)/2.0, CGRectGetWidth(_canvas.frame)/2.0) forLayer:_rotationLayer];
    }
    return _rotationLayer;
}
@end
