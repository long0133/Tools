//
//  ZFTabBarViewController.h
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTabBar.h"

@interface ZFTabBarViewController : UITabBarController

/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) ZFTabBar *customTabBar;

@end
