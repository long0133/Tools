//
//  CYLTabBarController.m
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTabBarController.h"
#import "CYLTabBar.h"


@interface CYLTabBarController ()<CYLTabBarDelegate>
@property (nonatomic, strong) NSMutableArray *tabBarItemArray;
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@property (nonatomic, strong) CYLTabBar* subTabBar;
@property (nonatomic, strong) UIView *lineView;
@end

#define color(x) x/255 * 1.0

@implementation CYLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllViewContoller];
    
    [self setTabBar];
    
    [self registPatter];
    
    [self addNotification];
}

- (void)dealloc{
    [self removeNotification];
}

#pragma mark - private

- (void)registPatter
{
    [ZJNRoutes registTabbarControllerPatterHandler:^BOOL(NSDictionary<NSString *,id> *parameters) {
       
        NSInteger index = [parameters[@"selectedIndex"] integerValue];
       
        if (index >= 0 && index <= 4) {
            self.selectedIndex = index;
            return YES;
        }
        
        return NO;
    }];
}

- (void)setTabBar
{
    _subTabBar = [[CYLTabBar alloc] init];
    
    _subTabBar.frame = self.tabBar.bounds;
    
    _subTabBar.backgroundColor = [UIColor zjnfff];
    
    _subTabBar.tabBarDelegate = self;
    
    _subTabBar.tabBarItemArray = self.tabBarItemArray;
    
    [_subTabBar setSpecialBtn:2];
    
    [self setValue:_subTabBar forKey:@"tabBar"];
}

#pragma mark - notification
- (void)addNotification{
}

- (void)removeNotification{
    [[ZJNNotificationManager shareshareNotifiManager] removeNotificationObserver:self];
}

- (void)tabbarDidClick:(NSInteger)index{
    if (index == 4) {
        CYLTabBarButton *btn = self.subTabBar.btnArr.lastObject;
        btn.redDot.hidden = YES;
    }
}

#pragma mark - 删除系统的TabbarBtn
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *view in self.tabBar.subviews) {
        
        if (![view isKindOfClass:[CYLTabBarButton class]]) {
            
            [view removeFromSuperview];
        }
    }
}

- (void)setUpAllViewContoller
{
    UIViewController *vc = [[UIViewController alloc] init];
    
//    vc = [[ZJNMainPageController alloc] init];
////    vc = [[ZJNViewController alloc] init];
//    [self setUpOneViewController:vc withImage:[UIImage imageNamed:@"首页"] selectedImage:[UIImage imageNamed:@"首页-1"] andTitle:@"首页"];
//
//    vc = [[ZJNDisplayPageController alloc] init];
//    [self setUpOneViewController:vc withImage:[UIImage imageNamed:@"展厅"] selectedImage:[UIImage imageNamed:@"材料-1"] andTitle:@"材料"];
//
//    vc = [[ZJNDiscoverPageController alloc] init];
//    [self setUpOneViewController:vc withImage:[UIImage imageNamed:@"发现"] selectedImage:[UIImage imageNamed:@"发现-点击状态"] andTitle:@"发现"];
//
//    vc = [[ZJNOrderPagerController alloc] init];
//    [self setUpOneViewController:vc withImage:[UIImage imageNamed:@"工地"] selectedImage:[UIImage imageNamed:@"工地-1"] andTitle:@"工地"];
//
//    vc = [[ZJNMinePageController alloc] init];
//    [self setUpOneViewController:vc withImage:[UIImage imageNamed:@"我的"] selectedImage:[UIImage imageNamed:@"我的-1"] andTitle:@"我的"];
}


- (void)setUpOneViewController:(UIViewController*)viewController withImage:(UIImage*)image selectedImage:(UIImage *)selectedImage andTitle:(NSString*)title
{
    CYLNaviViewController *navVC = [[CYLNaviViewController alloc] initWithRootViewController:viewController];
    
    viewController.title = title;
    
    navVC.tabBarItem.selectedImage = selectedImage;
    navVC.tabBarItem.image = image;
    navVC.tabBarItem.title = title;
    
    [self.tabBarItemArray addObject:navVC.tabBarItem];
    
    [self addChildViewController:navVC];
}

#pragma mark - CYLTabBarDelegate
- (void)tabBar:(CYLTabBar *)tabBar DidClickButton:(UIButton *)button
{
    self.selectedIndex = button.tag;
    [self tabbarDidClick:self.selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    super.selectedIndex = selectedIndex;
    [_subTabBar selectBtnByIndex:selectedIndex];
}

#pragma mark - 懒加载
- (NSMutableArray *)tabBarItemArray
{
    if (_tabBarItemArray == nil) {
        _tabBarItemArray = [NSMutableArray array];
    }
    return _tabBarItemArray;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _lineView.backgroundColor = mainGray;
    }
    return _lineView;
}


@end
