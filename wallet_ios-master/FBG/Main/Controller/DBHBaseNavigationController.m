//
//  DBHBaseNavigationController.m
//  Trinity
//
//  Created by 邓毕华 on 2017/12/25.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHBaseNavigationController.h"

#import "DBHBaseViewController.h"

#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

static CGFloat offset_float = 1;// 拉伸参数
static CGFloat min_distance = 60;// 最小回弹距离


@interface DBHBaseNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, assign) NSInteger currentVCBackIndex;

@end

@implementation DBHBaseNavigationController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    //设置导航栏背景颜色
    UINavigationBar *bar = self.navigationBar;
    
    bar.tintColor = COLORFROM16(0x333333, 1);
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORFROM16(0x333333, 1), NSFontAttributeName:FONT(18)}];
    
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLORFROM16(0x333333, 1), NSFontAttributeName:FONT(18)}];
    [self.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:FONT(16)} forState:UIControlStateNormal];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark ------ UINavigationControllerDelegate ------
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 删除系统自带的tabBarButton
    for (UIView *tabBar in self.tabBarController.tabBar.subviews) {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBar removeFromSuperview];
        }
    }
}

- (void)setBackItem:(UIViewController *)viewController {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 非根控制器才需要设置返回按钮
        // 设置返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *backImageName;
        if ([viewController isKindOfClass:NSClassFromString(@"DBHImportWalletViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHAddWalletViewController")]) {
            backImageName = @"login_close";
        } else if ([viewController isKindOfClass:NSClassFromString(@"DBHWalletDetailViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHWalletDetailWithETHViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHQrCodeViewController")] || [viewController isKindOfClass:NSClassFromString(@"DBHPaymentReceivedViewController")]) {
            backImageName = @"关闭-4";
        } else if ([viewController isKindOfClass:NSClassFromString(@"YYRedPacketViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketSendFirstViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketSendSecondViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketSendThirdViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketSendFourthTextViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketSendFourthImageViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketSendFourthLinkViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketSendFourthCodeViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketDetailViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketSuccessViewController")]) {
            backImageName = @"white_back";
        } else { 
            backImageName = @"返回-3";
        }
        [backButton setImage:[[UIImage imageNamed:backImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        backButton.frame = CGRectMake(0, 0, 40, 40);
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(4, -10, 4, 0)];
        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
//        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        // 设置返回按钮
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *otherBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   " style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        
        if ([viewController isKindOfClass:NSClassFromString(@"DBHPersonalCenterViewController")]) {
            [viewController.navigationItem setHidesBackButton:YES];
            viewController.navigationItem.rightBarButtonItem = backBarButtonItem;
        } else if ([viewController isKindOfClass:NSClassFromString(@"DBHSelectFaceOrTouchViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"DBHCheckFaceOrTouchViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"DBHSearchViewController")] ||
                   [viewController isKindOfClass:NSClassFromString(@"YYRedPacketPackagingViewController")]) {
            [viewController.navigationItem setHidesBackButton:YES];
        } else {
            viewController.navigationItem.leftBarButtonItems = @[backBarButtonItem, otherBarButtonItem];
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setBackItem:viewController];
    return [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if ([self.viewControllers.lastObject isKindOfClass:[DBHBaseViewController class]]) {
        DBHBaseViewController *currentVC = self.viewControllers.lastObject;
        if (!currentVC.backIndex) {
            return [super popViewControllerAnimated:animated];
        } else {
            return [self popToViewController:self.viewControllers[currentVC.backIndex - 1] animated:YES].lastObject;
        }
    }
    return [super popViewControllerAnimated:animated];
}


- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        
    }
    return [super popToViewController:viewController animated:animated];
}

#pragma mark ------ Private Methods ------
- (void)back {
    if ([self.viewControllers.lastObject isKindOfClass:[DBHBaseViewController class]]) {
        DBHBaseViewController *currentVC = self.viewControllers.lastObject;
        if (currentVC.backIndex && currentVC.backIndex < self.viewControllers.count) {
            [self popToViewController:self.viewControllers[currentVC.backIndex - 1] animated:YES];
            return;
        }
    }
    [self popViewControllerAnimated:YES];
}

#pragma mark -MyNavigationController中的
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.viewControllers[0];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)screenShotList {
    if (!_screenShotList) {
        _screenShotList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _screenShotList;
}

- (UIPanGestureRecognizer *)recognizer {
    if (!_recognizer) {
        _recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    }
    return _recognizer;
}

/**
 * 增加手势
 */
- (void)addGesture {
    self.recognizer.delaysTouchesBegan = NO;
    [self.view addGestureRecognizer:self.recognizer];
}

/**
 * 移除手势
 */
- (void)removeGesture {
    [self.view removeGestureRecognizer:self.recognizer];
    _recognizer = nil;
}

- (NSInteger)currentVCBackIndex {
    if ([self.viewControllers.lastObject isKindOfClass:[DBHBaseViewController class]]) {
        DBHBaseViewController *currentVC = self.viewControllers.lastObject;
        return currentVC.backIndex;
    }
    return 0;
}

/**
 * pop到上一个vc
 */
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    // 有动画用自己的动画
//    if (animated) {
//        [self popAnimation];
//        return nil;
//    }
//    return [super popViewControllerAnimated:animated];
//}

/**
 * IOS默认的pop动画 pop到上一个VC
 */
- (void)popViewControllerWithAnimate:(BOOL)isAnimate {
    [super popViewControllerAnimated:YES];
}

- (UIView *)backGroundView {
    if (!_backGroundView) {
        CGRect frame = self.view.frame;
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        _backGroundView.backgroundColor = [UIColor clearColor];
    }
    return _backGroundView;
}

/**
 * 自定义push
 */
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    [self setBackItem:viewController];
//    [self.screenShotList addObject:[self capture]];
//    
//    if (animated) {
//        [self pushAnimation:viewController];
//        return;
//    }
//    [super pushViewController:viewController animated:animated];
//}

/**
 * 当前界面生成的截图
 */
- (UIImage *)capture {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

/**
 * 将view的平移到x
 */
- (void)moveViewWithX:(float)x {
    x = x > SCREENWIDTH ? SCREENWIDTH : x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    lastScreenShotView.frame = (CGRect){-(SCREENWIDTH*offset_float) + x * offset_float, 0, SCREENWIDTH, SCREENHEIGHT};
}

/**
 * 手势动画结束
 */
- (void)gestureAnimation:(BOOL)animated {
    switch (self.currentVCBackIndex) {
        case 1: // 根viewcontroller
            if (self.screenShotList.count > 1) {
                [self.screenShotList removeObjectsInRange:NSMakeRange(1, self.screenShotList.count - 1)];
            }
            [super popToViewController:self.viewControllers[0] animated:NO];
            break;
            
        case 2: // 倒数第二个viewcontroller
            if (self.screenShotList.count > 2) {
                [self.screenShotList removeObjectsInRange:NSMakeRange(2, self.screenShotList.count - 2)];
            }
            [super popToViewController:self.viewControllers[1] animated:NO];
            break;
            
        default:
            [self.screenShotList removeLastObject];
            [super popViewControllerAnimated:animated];
            break;
    }
    
//    [self.screenShotList removeLastObject]; // 移除TODO
}

/**
 * 动画过程中，设置里面一层显示的view
 */
- (void)setBgView {
    [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
    self.backGroundView.hidden = NO;
    
    if (lastScreenShotView)
        [lastScreenShotView removeFromSuperview];
    
    UIImage *lastScreenShot = nil; //TODO 左边的图片
    switch (self.currentVCBackIndex) {
        case 1:
            if (self.screenShotList.count > 1) {
                lastScreenShot = self.screenShotList[1];
            }
            break;
        case 2:
            if (self.screenShotList.count > 2) {
                lastScreenShot = self.screenShotList[2];
            }
            break;
            
        default:
            lastScreenShot = [self.screenShotList lastObject];
            break;
    }
    lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    
    lastScreenShotView.frame = (CGRect){-(SCREENWIDTH * offset_float), 0, SCREENWIDTH,SCREENHEIGHT};
    [self.backGroundView addSubview:lastScreenShotView];
}

- (void)setAnimate {
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf moveViewWithX:SCREENWIDTH];
    } completion:^(BOOL finished) {
        [weakSelf gestureAnimation:NO];
        
        CGRect frame = weakSelf.view.frame;
        frame.origin.x = 0;
        weakSelf.view.frame = frame;
        weakSelf.isMoving = NO;
        weakSelf.backGroundView.hidden = YES;
    }];
}

- (void)setCancelAnimate {
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf moveViewWithX:0];
    } completion:^(BOOL finished) {
        weakSelf.isMoving = NO;
        weakSelf.backGroundView.hidden = YES;
    }];
}

- (void)popAnimation {
    if (self.viewControllers.count <= 1 || self.viewControllers.count < self.currentVCBackIndex)
        return;
    [self setBgView];
    [self setAnimate];
}

- (void)pushAnimation:(UIViewController *)vc {
    [self setPushView];
    [self setPushAnimate:vc];
}

- (void)movePushViewWithX:(float)x {
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    self.view.frame = frame;
    
    lastScreenShotView.frame = (CGRect){x, 0, SCREENWIDTH, SCREENHEIGHT};
}

- (void)setPushAnimate:(UIViewController *)vc {
    [super pushViewController:vc animated:NO];
    
    CGRect frame = self.view.frame;
    
    frame.origin.x = SCREENWIDTH;
    self.view.frame = frame;
    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf movePushViewWithX:-SCREENWIDTH];
    } completion:^(BOOL finished) {
        weakSelf.isMoving = NO;
        weakSelf.backGroundView.hidden = YES;
    }];
}

- (void)setPushView {
    @autoreleasepool {
        [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
        self.backGroundView.hidden = NO;
        
        if (lastScreenShotView)
            [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotList lastObject];
        lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
        lastScreenShotView.frame = (CGRect){0, 0, SCREENWIDTH, SCREENHEIGHT};
        [self.backGroundView addSubview:lastScreenShotView];
    }
}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer {
    if (self.viewControllers.count <= 1)
        return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        startPoint = touchPoint;
        
        if (startPoint.x > 50) {
            return;
        }
        _isMoving = YES;
        [self setBgView];
    } else if (recoginzer.state == UIGestureRecognizerStateChanged) {
        if (startPoint.x > 50) {
            return;
        }
        if (touchPoint.x < startPoint.x) {
            return;
        }
    } else if (recoginzer.state == UIGestureRecognizerStateEnded) {
        if (startPoint.x > 50) {
            return;
        }
        CGFloat value = touchPoint.x - startPoint.x;
        if (value > min_distance) {
            [self setAnimate];
        } else {
            [self setCancelAnimate];
        }
        return;
    } else if (recoginzer.state == UIGestureRecognizerStateCancelled) {
        if (startPoint.x > 50) {
            return;
        }
        
        [self setCancelAnimate];
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startPoint.x];
    }
}


@end
