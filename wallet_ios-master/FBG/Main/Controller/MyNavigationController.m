//
//  MyNavigationController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/6/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "MyNavigationController.h"

#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]


static CGFloat offset_float = 1;// 拉伸参数
static CGFloat min_distance = 60;// 最小回弹距离

@implementation MyNavigationController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题字体
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:VC_TITLE_FONT_SIZE], NSFontAttributeName, nil]];
}

/**
 * pop到上一个vc
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    // 有动画用自己的动画
    if (animated) {
        [self popAnimation];
        return nil;
    } else {
        return [super popViewControllerAnimated:animated];
    }
}

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
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.screenShotList addObject:[self capture]];
    
    if (animated) {
        [self pushAnimation:viewController];
        return;
    }
    [super pushViewController:viewController animated:animated];
}

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
    // TODO
    
    lastScreenShotView.frame = (CGRect){-(SCREENWIDTH*offset_float) + x * offset_float, 0, SCREENWIDTH, SCREENHEIGHT};
}

/**
 * 手势动画结束
 */
- (void)gestureAnimation:(BOOL)animated {
    [self.screenShotList removeLastObject];
    [super popViewControllerAnimated:animated];
}

/**
 * 动画过程中，设置里面一层显示的view
 */
- (void)setView {
    [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
    self.backGroundView.hidden = NO;
    
    if (lastScreenShotView)
        [lastScreenShotView removeFromSuperview];
    
    UIImage *lastScreenShot = [self.screenShotList lastObject];
    lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    
    lastScreenShotView.frame = (CGRect){-(SCREENWIDTH * offset_float), 0, SCREENWIDTH,SCREENHEIGHT};
    [self.backGroundView addSubview:lastScreenShotView];
}

- (void)setAnimate {
    [UIView animateWithDuration:0.3 animations:^{
        [self moveViewWithX:SCREENWIDTH];
    } completion:^(BOOL finished) {
        [self gestureAnimation:NO];
        
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        self.view.frame = frame;
        _isMoving = NO;
        self.backGroundView.hidden = YES;
    }];
}

- (void)setCancelAnimate {
    [UIView animateWithDuration:0.3 animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finished) {
        _isMoving = NO;
        self.backGroundView.hidden = YES;
    }];
}

- (void)popAnimation {
    if (self.viewControllers.count <= 1)
        return;
    [self setView];
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
    
    // TODO
    lastScreenShotView.frame = (CGRect){x, 0, SCREENWIDTH, SCREENHEIGHT};
}

- (void)setPushAnimate:(UIViewController *)vc {
    [super pushViewController:vc animated:NO];
    
    CGRect frame = self.view.frame;
    
    frame.origin.x = SCREENWIDTH;
    self.view.frame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self movePushViewWithX:-SCREENWIDTH];
    } completion:^(BOOL finished) {
        _isMoving = NO;
        self.backGroundView.hidden = YES;
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
        [self setView];
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
