//
//  DBHNavigationController.m
//  FBG
//
//  Created by 邓毕华 on 2017/11/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHNavigationController.h"

@interface DBHNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation DBHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    //设置导航栏背景颜色
    UINavigationBar *bar = self.navigationBar;
    bar.tintColor = [UIColor colorWithHexString:@"97BDDB"];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"97BDDB"]}];
    [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"10171F"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.interactivePopGestureRecognizer.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 非根控制器才需要设置返回按钮
        // 设置返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"icon_market_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton sizeToFit];
        // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        // 设置返回按钮
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *otherBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"     " style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        
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
