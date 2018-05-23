//
//  UIButton+Tool.m
//  FBG
//
//  Created by yy on 2018/3/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "UIButton+Tool.h"

@implementation UIButton (Tool)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:state];
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:AUTOLAYOUTSIZE(5.0f)]; //设置圆角
    
    [self.layer setBorderWidth:AUTOLAYOUTSIZE(1.0)]; // 边框宽度
    self.layer.borderColor = color.CGColor;
}

- (void)setCorner:(CGFloat)radius {
    self.layer.cornerRadius = AUTOLAYOUTSIZE(radius);
    self.layer.masksToBounds = YES;
}

@end
