//
//  MyNavigationController.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/6/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#define VC_TITLE_FONT_SIZE 16.0f

@interface MyNavigationController : UINavigationController<UIGestureRecognizerDelegate> {
    CGPoint startPoint;
    UIImageView *lastScreenShotView;// view
}

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSMutableArray *screenShotList;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, strong) UIPanGestureRecognizer *recognizer;

- (void)popViewControllerWithAnimate:(BOOL)isAnimate;

@end
