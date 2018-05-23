//
//  CDNavigationController.m
//  i-chengdu
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 lykj. All rights reserved.
//

#import "CDNavigationController.h"
#import "FBG-Swift.h"

@interface CDNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation CDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    //设置导航栏背景颜色
    UINavigationBar *bar = self.navigationBar;
    bar.tintColor = [UIColor colorWithHexString:@"333333"];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]}];
    [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"FFFFFF"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 删除系统自带的tabBarButton
    for (UIView *tabBar in self.tabBarController.tabBar.subviews)
    {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            [tabBar removeFromSuperview];
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        // 非根控制器才需要设置返回按钮
        // 设置返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:[NSStringFromClass([viewController class]) isEqualToString:@"DBHMarketDetailViewController"] ? @"white_nav_back" : @"nav_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton sizeToFit];
        // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        // 设置返回按钮

        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *otherBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   " style:UIBarButtonItemStylePlain target:self action:@selector(back)];

        viewController.navigationItem.leftBarButtonItems = @[backBarButtonItem, otherBarButtonItem];
    }
    return [super pushViewController:viewController animated:animated];
}

#pragma mark ------ UIGestureRecognizerDelegate ------
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
