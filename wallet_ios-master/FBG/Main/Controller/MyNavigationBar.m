//
//  MyNavigationBar.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/6/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "MyNavigationBar.h"

@implementation MyNavigationBar

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.color) {
        [self setNavigationBarWithColor:self.color];
    } else {
        [self setNavigationBarWithColor:[UIColor whiteColor]];
    }
}

#pragma mark - 初始化
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

#pragma mark - 设置navigationbar的颜色
/**
 *  设置navigationbar的颜色
 *
 *  @param color 指定颜色
 */
- (void)setNavigationBarWithColor:(UIColor *)color {
    UIImage *image = [UIImage imageWithColor:color];
    
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self setBarStyle:UIBarStyleBlack];
    [self setShadowImage:[UIImage new]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self setTintColor:[UIColor whiteColor]];
    [self setTranslucent:YES];
}

/**
 *  设置navigationbar的颜色（渐变）
 *
 *  @param colors 指定颜色数组
 */
- (void)setNavigationBarWithColors:(NSArray *)colors {
    UIImage *image = [UIImage imageWithGradients:colors];
    
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self setBarStyle:UIBarStyleBlack];
    [self setShadowImage:[UIImage new]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self setTintColor:[UIColor whiteColor]];
    [self setTranslucent:YES];
}

@end
