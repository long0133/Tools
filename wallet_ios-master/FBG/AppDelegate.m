//
//  AppDelegate.m
//  FBG
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "ZFTabBarViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
// Bugly
#import <Bugly/Bugly.h>
// 环信
#import <HyphenateLite/HyphenateLite.h>
//友盟统计
#import "UMMobClick/MobClick.h"
//阿里云
#import <AliyunOSSiOS/OSSService.h>
//推送
#import <CloudPushSDK/CloudPushSDK.h>
// 推特
#import <TwitterKit/TWTRKit.h>

// iOS 10 notification
#import <UserNotifications/UserNotifications.h>

static NSString *const QQAppID = @"1106810898";
static NSString *const QQAppKey = @"NY9GcnQXR8YWCVA9";
static NSString *const testAppKey = @"24535336";
static NSString *const testAppSecret = @"efb26f9fa9cc2afa2aef54e860e309a2";

#import <YYCache/YYCache.h>
#import "CDNavigationController.h"
#import "DBHBaseNavigationController.h"
#import "DBHHomePageViewController.h"
#import "DBHLoginViewController.h"
#import "DBHCheckFaceOrTouchViewController.h"
//#import "MessageVC.h"

#define BUGLY_APP_ID @"8f38371e64" // TODO
#define WEIXIN_APP_ID @"wxd346a4033d5a09a3"

#define TWITTER_APP_KEY     @"D7a0vT5OHmwIvdoFUQGzNCUIg"
#define TWITTER_APP_SECRET  @"hh9bpRGbsrO9cl1DzYzYHvFZQ4T1YW7dO681bjHQ0KitFNlVdd"

@interface AppDelegate () <UNUserNotificationCenterDelegate, EMChatManagerDelegate, EMClientDelegate, WXApiDelegate, QQApiInterfaceDelegate, TencentSessionDelegate>
{
    // iOS 10通知中心
    
}
@property (nonatomic, strong) UNUserNotificationCenter *notificationCenter;
@property (nonatomic, copy) NSArray *titleGroupNameArray; // 功能组件对应环信的组名
@property (nonatomic, assign) int connectCount;
@property (nonatomic, assign) BOOL isRegisterAPNs;
@property (nonatomic, strong) TencentOAuth *oauth;

@end

@implementation AppDelegate

+ (instancetype)delegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = WHITE_COLOR;
    
    if (!APP_APIEHEAD) { // 设置默认环境 APIEHEAD1 / TESTAPIEHEAD1
        [[NSUserDefaults standardUserDefaults] setObject:APIEHEAD1 forKey:APP_NETWORK_API_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (!APP_WALLETSTATUS) {
        [USER_DEFAULTS setObject:@"HOT" forKey:APP_WALLET_STATUS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.notificationCenter.delegate = self;
    
    // 推特
    [[Twitter sharedInstance] startWithConsumerKey:TWITTER_APP_KEY consumerSecret:TWITTER_APP_SECRET];
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [self otherThings];
    });
    
    return YES;
}

- (void)otherThings {
    //添加网络状态提醒
    [self netNotification];
    
    // 环信sdk注册
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:[APP_APIEHEAD isEqualToString:APIEHEAD1] ? @"1109180116115999#online" : @"1109180116115999#test"];
    options.apnsCertName = @"aps_development";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    [WXApi registerApp:WEIXIN_APP_ID];
    self.oauth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:self];
    
    UserModel *user = [UserSignData share].user;
    if (!user.isLogin) {
        user.walletUnitType = [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? 1 : 2;
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"has_come"]) {
        user.walletUnitType = [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? 1 : 2;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"has_come"];
    }
    [[UserSignData share] storageData:user];
    
    if ([APP_WALLETSTATUS isEqualToString:@"HOT"])  {
    } else {  //始终进入冷钱包
        [UserSignData share].user.isCode = YES;
        [[UserSignData share] storageData:[UserSignData share].user];
        YYCache * dataCache = [YYCache cacheWithName:@"FBGNetworkResponseCache"];
        [dataCache removeAllObjects];
    }
    
    //友盟统计
    UMConfigInstance.appKey = UM_APP_KEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    //        [MobClick setLogEnabled:YES]; // <#正式/测试切换#>❤️❤️切换❤️❤️
    
    // Bugly统计
    [Bugly startWithAppId:BUGLY_APP_ID];
    
    //推送
    [self registerEMAPNs];
    
    // 初始化SDK
    [self initCloudPush];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url {
    if ([url.scheme containsString:WEIXIN_APP_ID]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.scheme containsString:QQAppID]){
        return [QQApiInterface handleOpenURL:url delegate:self];
    }/** else if ([url.scheme containsString:TWITTER_APP_KEY]) {
//        return [[Twitter sharedInstance] application:application openURL:url options:options];
    }*/ else {
        return YES;
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme containsString:WEIXIN_APP_ID]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.scheme containsString:QQAppID]){
        return [QQApiInterface handleOpenURL:url delegate:self];
    } else if ([url.scheme containsString:TWITTER_APP_KEY]) {
      return [[Twitter sharedInstance] application:app openURL:url options:options];
    } else {
        return YES;
    }
}

- (void)onResp:(id)res {
    if ([res isKindOfClass:[BaseResp class]]) {
        if (self.resultBlock) {
            self.resultBlock(res);
        }
    } else if ([res isKindOfClass:[QQBaseResp class]]) {
        NSLog(@"qq onResp");
        if (self.qqResultBlock) {
            self.qqResultBlock(res);
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
}

- (void)onReq:(id)req {
}


- (UNUserNotificationCenter *)notificationCenter {
    if (!_notificationCenter) {
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    }
    return _notificationCenter;
}

#pragma mark APNs Register
/**
 *    向APNs注册，获取deviceToken用于推送
 */
- (void)registerAPNS:(UIApplication *)application {
    if (self.connectCount >= 3) {
        NSLog(@"连接次数达到 -- %d次", self.connectCount);
        return;
    }
    
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        // 创建category，并注册到通知中心
        [self createCustomNotificationCategory];
        // 请求推送权限
        [self.notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                // 向APNs注册，获取deviceToken
                GCDMain(^{
                    [application registerForRemoteNotifications];
                });
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        GCDMain(^{
            [application registerForRemoteNotifications];
        });
#pragma clang diagnostic pop
    } else {
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
    self.connectCount ++;
}

/**
 *  主动获取设备通知是否授权(iOS 10+)
 */
- (void)getNotificationSettingStatus {
    [self.notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            NSLog(@"User authed.");
        } else {
            NSLog(@"User denied.");
        }
    }];
}

/*
 *  APNs注册成功回调，将返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
    NSLog(@"Upload deviceToken to CloudPush server.");
    WEAKSELF
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            
            NSLog(@"Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
            //获取成功,保存本地
            [[NSUserDefaults standardUserDefaults] setObject:[CloudPushSDK getApnsDeviceToken] forKey:@"appDeviceId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            weakSelf.isRegisterAPNs = YES;
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
            if (![UserSignData share].user.isCode) {
                [weakSelf registerAPNS:application];
            }
        }
    }];
}

/*
 *  APNs注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
 *  创建并注册通知category(iOS 10+)
 */
- (void)createCustomNotificationCategory {
    // 自定义`action1`和`action2`
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
    // 创建id为`test_category`的category，并注册两个action到category
    // UNNotificationCategoryOptionCustomDismissAction表明可以触发通知的dismiss回调
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:
                                        UNNotificationCategoryOptionCustomDismissAction];
    // 注册category到通知中心
    [self.notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification
{
    //前台接受推送
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}

/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知，并上报通知打开回执
    [self handleiOS10Notification:notification];
    // 通知不弹出
    //    completionHandler(UNNotificationPresentationOptionNone);
    
    // 通知弹出，且带有声音、内容和角标
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier])
    {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
        //跳转消息页面
        UIViewController *rootVC = self.window.rootViewController;
        if ([rootVC isKindOfClass:[ZFTabBarViewController class]]) {
            ZFTabBarViewController * tab = (ZFTabBarViewController*) rootVC;
            CDNavigationController * nav = tab.childViewControllers[tab.selectedIndex];
            //        MessageVC * vc = [[MessageVC alloc]init];
            //        [nav pushViewController:vc animated:YES];
        }
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier])
    {
        NSLog(@"User dismissed the notification.");
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1])
    {
        NSLog(@"User custom action1.");
    }
    
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2])
    {
        NSLog(@"User custom action2.");
    }
    completionHandler();
}

#pragma mark SDK Init
- (void)initCloudPush {
    // <#正式/测试切换#>❤️❤️切换❤️❤️
    //    [CloudPushSDK turnOnDebug];
    // SDK初始化
    [CloudPushSDK asyncInit:testAppKey appSecret:testAppSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
            
            //绑定用户
            [CloudPushSDK bindAccount:[UserSignData share].user.open_id withCallback:^(CloudPushCallbackResult *res) {
                if (res.success)
                {
                    NSLog(@"绑定成功 %@", res.error);
                }
                else
                {
                    NSLog(@"绑定失败失败 %@", res.error);
                }
            }];
            
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

#pragma mark Notification Open
/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
}

#pragma mark Receive Message
/**
 *    @brief    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}

/**
 *    处理到来推送消息
 *
 */
- (void)onMessageReceived:(NSNotification *)notification {
    NSLog(@"Receive one message!");
    
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:body preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //弹出提示框；
    //    [self presentViewController:alert animated:true completion:nil];
}

//判断网络状态
- (void)netNotification {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    WEAKSELF
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变时调用
        weakSelf.connectCount = 0;
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"netNotification" object:nil userInfo:nil]];
        switch (status)  {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知网络");
                if ([UserSignData share].user.isCode)  //发送消息
                    [weakSelf goToTabbar];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"网络不可用！请检查网络连接。");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"手机自带网络");
                if (!weakSelf.isRegisterAPNs) {
                    [weakSelf registerAPNS:[UIApplication sharedApplication]];
                }
                if ([UserSignData share].user.isCode)  //发送消息
                    [weakSelf goToTabbar];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"WIFI");
                if (!weakSelf.isRegisterAPNs) {
                    [weakSelf registerAPNS:[UIApplication sharedApplication]];
                }
                if ([UserSignData share].user.isCode)  //发送消息
                    [weakSelf goToTabbar];
                break;
            }
        }
        
    }];
    
    //开始监控
    [manager startMonitoring];
}

- (void)showLoginController
{
    DBHLoginViewController *loginViewController = [[DBHLoginViewController alloc] init];
    DBHBaseNavigationController *loginNavigationController = [[DBHBaseNavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController = loginNavigationController;
    [self.window makeKeyAndVisible];
}

- (void)goToLoginVC:(UIViewController *)target {
    GCDMain(^{
        DBHLoginViewController *loginViewController = [[DBHLoginViewController alloc] init];
        DBHBaseNavigationController *loginNavigationController = [[DBHBaseNavigationController alloc] initWithRootViewController:loginViewController];
        [target presentViewController:loginNavigationController animated:YES completion:nil];
    });
}

- (void)goToTabbar {
    ZFTabBarViewController * tab = [[ZFTabBarViewController alloc] init];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
}

- (void)showThirdLogin {
    DBHCheckFaceOrTouchViewController *checkFaceOrTouchViewController = [[DBHCheckFaceOrTouchViewController alloc] init];
    self.window.rootViewController = checkFaceOrTouchViewController;
    [self.window makeKeyAndVisible];
}

- (void)emregister {
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    [[EMClient sharedClient] changeAppkey:[APP_APIEHEAD isEqualToString:APIEHEAD1] ? @"1109180116115999#online" : @"1109180116115999#test"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

/// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enter_backgroud" object:nil];
    //后台运行timer
    /*
     UIApplication*   app = [UIApplication sharedApplication];
     __block    UIBackgroundTaskIdentifier bgTask;
     bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
     dispatch_async(dispatch_get_main_queue(), ^{
     if (bgTask != UIBackgroundTaskInvalid)
     {
     bgTask = UIBackgroundTaskInvalid;
     }
     });
     }];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     dispatch_async(dispatch_get_main_queue(), ^{
     if (bgTask != UIBackgroundTaskInvalid)
     {
     bgTask = UIBackgroundTaskInvalid;
     }
     });
     });
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enter_foreground" object:nil];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField=60;
    manager.enableAutoToolbar = NO;
}

/**
 注册环信离线推送
 */
- (void)registerEMAPNs {
    UIApplication *application = [UIApplication sharedApplication];
    
    //iOS10 注册APNs
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                GCDMain(^{
                    [application registerForRemoteNotifications];
                });
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        GCDMain(^{
            [application registerForRemoteNotifications];
        });
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark ------ EMChatManagerDelegate ------
/**
 收到消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages {
    NSLog(@"appdele messagesDidReceive  ");
    for (EMMessage *msg in aMessages) {
        switch (msg.chatType) {
            case EMChatTypeChat: {
                // 单聊
                if ([msg.conversationId isEqualToString:@"sys_msg"] && [UserSignData share].user.functionalUnitArray.count > 4) {
                    [UserSignData share].user.functionalUnitArray[4] = @"0";
                    [[UserSignData share] storageData:[UserSignData share].user];
                }
                break;
            }
            case EMChatTypeGroupChat: {
                // 群聊
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:msg.conversationId error:&error];
                if (!error) { //TODO
                    NSInteger index = [self.titleGroupNameArray indexOfObject:[group.subject substringToIndex:group.subject.length - 3]];
                    if (index < 0 || index > 4) {
                        return;
                    }
                    
                    if (index == 3) { // 交易所公告 要放在动态里面去
                        index = 0;
                    }
                    if ([[UserSignData share].user.functionalUnitArray[index] isEqualToString:@"1"]) {
                        [UserSignData share].user.functionalUnitArray[index] = @"0";
                        [[UserSignData share] storageData:[UserSignData share].user];
                        return;
                    }
                }
                break;
            }
            case EMChatTypeChatRoom: {
                // 聊天室
                return;
                break;
            }
                
            default:
                break;
        }
    }
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    // App在前台
    if (state != UIApplicationStateBackground) {
        return;
    }
    
    for (EMMessage *msg in aMessages) {
        if (msg.chatType == EMChatTypeGroupChat) {
            // 群聊
            EMError *error = nil;
            EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:msg.conversationId error:&error];
            if (!error) {
                NSInteger index = [self.titleGroupNameArray indexOfObject:[group.subject substringToIndex:group.subject.length - 3]];
                if (index < 0 || index > 4) {
                    continue;
                }
                
                if ([UserSignData share].user.realTimeDeliveryArray.count > index) {
                    if ([[UserSignData share].user.realTimeDeliveryArray[index] isEqualToString:@"0"]) {
                        continue;
                    }
                }
            }
        } else if (msg.chatType == EMChatTypeChat) {
            // 单聊
            if ([msg.conversationId isEqualToString:@"sys_msg"]) {
                if ([UserSignData share].user.realTimeDeliveryArray.count > 5) {
                    if ([[UserSignData share].user.realTimeDeliveryArray[5] isEqualToString:@"0"]) {
                        continue;
                    }
                }
            }
        }
        
        EMTextMessageBody *message = (EMTextMessageBody *)msg.body;
        //发送本地推送
        if (NSClassFromString(@"UNUserNotificationCenter")) { // ios 10
            // 设置触发时间
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.sound = [UNNotificationSound defaultSound];
            // 提醒，可以根据需要进行弹出，比如显示消息详情，或者是显示“您有一条新消息”
            
            NSString *msgStr = message.text;
            //            msgStr = [NSString flattenHTML:msgStr];
            content.body = msgStr;
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:msg.messageId content:content trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
        } else {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date]; //触发通知的时间
            notification.alertBody = message.text;
            notification.alertAction = @"Open";
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

#pragma mark ------ EMClientDelegate ------
/**
 其他设备上登录
 */
- (void)userAccountDidLoginFromOtherDevice {
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        [[UserSignData share] storageData:nil];
        UserModel *user = [UserSignData share].user;
        // 货币单位跟随语言
        user.walletUnitType = [[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? 1 : 2;
        [[UserSignData share] storageData:user];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_LOGIN_KEY];
        
        //        [self showLoginController];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self goToLoginVC:[UIView currentViewController]];
        });
        NSLog(@"退出成功");
    }
}

#pragma mark ------ Getters And Setters ------
- (NSArray *)titleGroupNameArray {
    if (!_titleGroupNameArray) {
        _titleGroupNameArray = @[@"SYS_MSG_INWEHOT", @"SYS_MSG_VIEWPOINT", @"SYS_MSG_TRADING", @"SYS_MSG_EXCHANGENOTICE"/*, @"SYS_MSG_CANDYBOW"*/, @"SYS_MSG"];
    }
    return _titleGroupNameArray;
}

- (void)tencentDidLogin {
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

@end
