//
//  Animator.m
//  CYLReferesh
//
//  Created by chinapex on 2018/4/9.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "Animator.h"

#define refreshArrowWidth 5
#define refreshArrowHeight 10

@implementation Animator
+ (void)showArrowOnCanvas:(UIView *)view{
    CAShapeLayer *arrowLayer = [[CAShapeLayer alloc] init];

    CGFloat width = view.frame.size.width/3.0;
    arrowLayer.frame = CGRectMake((view.frame.size.width-width)/2.0, view.frame.size.height-(width/2.0), width, width);
    [view.layer addSublayer:arrowLayer];
    
//    arrowLayer.path = [self drawDownArrowWithLayer:arrowLayer].CGPath;
}

//+ (UIBezierPath*)drawDownArrowWithLayer:(CAShapeLayer*)layer{
//    CGPoint startPoint = CGPointMake(CGRectGetWidth(layer.frame)/2.0, CGRectGetMaxY(layer.frame));
//    CGPoint leftPoint = CGPointMake(startPoint.x - refreshArrowWidth, startPoint.y - tan(M_PI_4));
//    CGPoint rightPoint = CGPointMake(startPoint.x + refreshArrowWidth, startPoint.y - tan(M_PI_4));
//    CGPoint endPoint = CGPointMake(startPoint.x, startPoint.y - refreshArrowHeight);
//
//    // Bezier Drawing
//    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:endPoint];
//    [bezierPath addLineToPoint:startPoint];
//    [bezierPath addLineToPoint:leftPoint];
//    [bezierPath addLineToPoint:rightPoint];
//    [bezierPath addLineToPoint:startPoint];
////    [bezierPath moveToPoint:startPoint];
////    [bezierPath addLineToPoint:leftPoint];
////    [bezierPath moveToPoint:startPoint];
////    [bezierPath addLineToPoint:rightPoint];
////    [bezierPath moveToPoint:startPoint];
////    [bezierPath addLineToPoint:endPoint];
//
//    bezierPath.lineWidth = 2;
//    return bezierPath;
//}
@end
