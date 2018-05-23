//
//  AppDelegate.h
//  FBG
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseResp;
@class QQBaseResp;

typedef void(^WXResultBlock)(BaseResp *);
typedef void(^QQResultBlock)(QQBaseResp *);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)delegate;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) WXResultBlock resultBlock;
@property (nonatomic, copy) QQResultBlock qqResultBlock;

-(void)showLoginController;
- (void)goToTabbar;
- (void)emregister;
- (void)goToLoginVC:(UIViewController *)target;
- (void)showThirdLogin;

@end

