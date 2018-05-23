//
//  DBHBaseNavigationController.h
//  Trinity
//
//  Created by 邓毕华 on 2017/12/25.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHBaseNavigationController : UINavigationController<UIGestureRecognizerDelegate> {
    CGPoint startPoint;
    UIImageView *lastScreenShotView;// view
}

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSMutableArray *screenShotList;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, strong) UIPanGestureRecognizer *recognizer;

@property (nonatomic, assign) BOOL showSystemAnimation;

- (void)popViewControllerWithAnimate:(BOOL)isAnimate;


@end
