//
//  ZFTabBarViewController.m
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import "ZFTabBarViewController.h"

#import "ZFTabBar.h"
#import "DBHBaseNavigationController.h"

#import "DBHInformationViewController.h"
#import "DBHHomePageViewController.h"
#import "DBHMyViewController.h"

#import "DBHWalletPageViewController.h"
#import "DBHCheckVersionModel.h"


@interface ZFTabBarViewController () <ZFTabBarDelegate>

@property (nonatomic, assign) BOOL isReview;

@end

@implementation ZFTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:WHITE_COLOR]];
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    
    if ([UserSignData share].user.isFirstRegister) {
        [UserSignData share].user.isFirstRegister = NO;
        [[UserSignData share] storageData:[UserSignData share].user];
    }
}

#pragma mark ------ set ui ------

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    ZFTabBar *customTabBar = [[ZFTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(ZFTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to {
    if ([UserSignData share].user.isCode && to != 0)
    {
        //冷钱包进入
        [LCProgressHUD showMessage:@"冷钱包"];
    }
    else
    {
        //热钱包
        self.selectedIndex = to;
    }
    
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers {
    // 1.资讯
    DBHInformationViewController *informationViewController = [[DBHInformationViewController alloc] init];
    informationViewController.tabBarItem.badgeValue = @"";
    [self setupChildViewController:informationViewController title:DBHGetStringWithKeyFromTable(@"News", nil) imageName:@"zixun_ico_s" selectedImageName:@"zixun_ico"];
    
    if (!self.isReview) { // 不在审核中
        // 2.钱包
//        DBHHomePageViewController *homePageViewController = [[DBHHomePageViewController alloc] init];
        
        DBHWalletPageViewController *homePageViewController = [[DBHWalletPageViewController alloc] init];
        
        homePageViewController.tabBarItem.badgeValue = @"";
        [self setupChildViewController:homePageViewController title:DBHGetStringWithKeyFromTable(@"Wallet", nil) imageName:@"qianbao_ico_s" selectedImageName:@"qianbao_ico"];
    }
    
    // 3.我的
    DBHMyViewController * my = [[DBHMyViewController alloc] init];
    my.tabBarItem.badgeValue = @"";
    [self setupChildViewController:my title:DBHGetStringWithKeyFromTable(@"My Profile", nil) imageName:@"wode_ico_s" selectedImageName:@"wode_ico"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    NSLog(@"title  语言 -- %@", title);
    // 1.设置控制器的属性
    if ([title isEqualToString:DBHGetStringWithKeyFromTable(@"My Profile", nil)]) {
        childVc.title = title;
    } else {
        childVc.tabBarItem.title = title;
    }
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    // 2.包装一个导航控制器
    DBHBaseNavigationController *nav = [[DBHBaseNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

- (BOOL)isReview {
    return [[NSUserDefaults standardUserDefaults] boolForKey:CHECK_STATUS];
}

/**
 设置状态栏颜色
 */
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

@end
