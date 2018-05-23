//
//  UIButton+SDSetImage.m
//  PandaTravel
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "UIButton+SDSetImage.h"
#import "UIButton+WebCache.h"
#import <objc/runtime.h>

@implementation UIButton (SDSetImage)

- (void)sdsetImageWithHeadimg:(NSString *)img
{
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,img]] forState:UIControlStateNormal placeholderImage:Default_Person_Image];
}

- (void)sdsetImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,url]] forState:UIControlStateNormal placeholderImage:placeholder];
}

- (void)sdsetBackgroundImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,url]] forState:UIControlStateNormal];
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,url]] forState:UIControlStateSelected];
}

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.doubleValue,
                          self.bounds.origin.y - topEdge.doubleValue,
                          self.bounds.size.width + leftEdge.doubleValue + rightEdge.doubleValue,
                          self.bounds.size.height + topEdge.doubleValue + bottomEdge.doubleValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
