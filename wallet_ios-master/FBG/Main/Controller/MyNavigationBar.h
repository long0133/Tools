//
//  MyNavigationBar.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/6/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavigationBar : UINavigationBar

@property (strong, nonatomic) IBInspectable UIColor *color;

- (void)setNavigationBarWithColor:(UIColor *)color;
- (void)setNavigationBarWithColors:(NSArray *)colors;

@end
