//
//  UIWindow+Extension.m
//  FBG
//
//  Created by yy on 2018/4/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "UIWindow+Extension.h"
#import <objc/runtime.h>

@implementation UIWindow (Extension)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setRootViewController:)), class_getInstanceMethod(self, @selector(yy_setRootViewController:)));
}

- (void)yy_setRootViewController:(UIViewController *)rootViewController {
    
    //remove old rootViewController's sub views
    for (UIView* subView in self.rootViewController.view.subviews) {
        [subView removeFromSuperview];
    }
    
    //remove old rootViewController's view
    [self.rootViewController.view removeFromSuperview];
    //remove empty UILayoutContainerView(s) remaining on root window
    for (UIView *subView in self.subviews)  {
        if (subView.subviews.count == 0) {
            [subView removeFromSuperview];
        }
    }
    //set new rootViewController
//    [self addSubview:rootViewController.view];
    [self yy_setRootViewController:rootViewController];
}

@end
