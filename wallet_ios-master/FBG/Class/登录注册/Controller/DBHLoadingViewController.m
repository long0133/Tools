//
//  DBHLoadingViewController.m
//  FBG
//
//  Created by yy on 2018/3/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHLoadingViewController.h"

#define VERSION @"VERSION"

typedef void(^ResultBlock) (NSDictionary *dict);

@interface DBHLoadingViewController ()

@end

@implementation DBHLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_APPSTORE_APP) { // 是app_store才审核
        [self judgePushWhere];
    } else {
        [self goToTabbarWithIsReview:NO];
    }
}

// 默认是审核中
- (void)judgePushWhere {
    NSDictionary *checkObj = [[NSUserDefaults standardUserDefaults] objectForKey:CHECK_STATUS_OBJECT];
    if (!checkObj) { // 未请求过 去请求
        if ([PPNetworkHelper hasConnectedNetwork]) { // 有网 去请求
            [self getReviewFromServer];
        } else { // 为空且没网 则默认隐藏
            [self goToTabbarWithIsReview:YES];
        }
    } else { // 请求过
        NSString *versionStr = checkObj[VERSION];
        
        NSString *currentVersionStr = [self currentVersion];
        if (versionStr.integerValue == currentVersionStr.integerValue) {
            BOOL isReviewStatus = [checkObj[CHECK_STATUS] boolValue];
            if (isReviewStatus) { // 本地当前版本在审核中 需请求最新
                if ([PPNetworkHelper hasConnectedNetwork]) { // 有网 去请求
                    [self getReviewFromServer];
                } else { // 为空且没网 则默认隐藏
                    [self goToTabbarWithIsReview:isReviewStatus];
                }
            } else {
                [self goToTabbarWithIsReview:isReviewStatus];
            }
        } else { // 不是当前版本
            [self goToTabbarWithIsReview:NO];
        }
    }
}

- (void)getReviewFromServer {
    WEAKSELF
    [self getIsReview:^(NSDictionary *dict) {
        if (dict) {
            NSString *versionStr = dict[VERSION];
            NSString *currentVersionStr = [self currentVersion];
            if (versionStr.integerValue == currentVersionStr.integerValue) {
                BOOL isReviewStatus = [dict[CHECK_STATUS] boolValue];
                [weakSelf goToTabbarWithIsReview:isReviewStatus];
            } else { // 不是当前版本
                [weakSelf goToTabbarWithIsReview:NO];
            }
        } else {
            [weakSelf goToTabbarWithIsReview:YES]; // 返回空或者失败时 默认审核中
        }
    }];
}

- (void)goToTabbarWithIsReview:(BOOL)isReview {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isReview forKey:CHECK_STATUS];
    [userDefaults synchronize];
    
    if ([UserSignData share].user.token.length && [UserSignData share].user.canUseUnlockType != DBHCanUseUnlockTypeNone && ([UserSignData share].user.isOpenTouchId || [UserSignData share].user.isOpenFaceId)) {
        [[AppDelegate delegate] showThirdLogin];
    } else {
        [[AppDelegate delegate] goToTabbar];
    }
}

/**
 获取是否在审核中状态
 */
- (void)getIsReview:(ResultBlock)block {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [PPNetworkHelper GET:@"config/get_key_collection/IOS_VERIFY" baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
            if (responseObject) {
                NSDictionary *dict = responseObject[@"childrens"];
                if (dict && ![dict isEqual:[NSNull null]]) {
                    NSString *versionStr = dict[VERSION];
                    BOOL isReviewStatus = [dict[CHECK_STATUS] boolValue];
                    NSDictionary *obj = @{
                                          CHECK_STATUS : @(isReviewStatus),
                                          VERSION : versionStr
                                          };
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:obj forKey:CHECK_STATUS_OBJECT];
                    
//                    NSString *updateTip = dict[UPDATE_HIT];
//                    BOOL isForce = [dict[FORCE] boolValue];
//                    [userDefaults setBool:isForce forKey:FORCE];
//                    [userDefaults setObject:updateTip forKey:UPDATE_HIT];
//                    [userDefaults setObject:versionStr forKey:SERVER_VERSION];
                    [userDefaults synchronize];
                    
                    if (block) {
                        block(obj);
                    }
                }
            } else {
                if (block) {
                    block(nil);
                }
            }
        } failure:^(NSString *error) {
            if (block) {
                block(nil);
            }
        }];
    });
}

- (NSString *)currentVersion {
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

@end
