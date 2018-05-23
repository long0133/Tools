//
//  DBHCheckVersionModel.m
//  FBG
//
//  Created by yy on 2018/3/21.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCheckVersionModel.h"
//#import "AFNetworking.h"

#import "DBHUpdateTipView.h"


#define VERSION @"VERSION"

//#define VERSIONCODE @"versionCode"
//#define UPDATEHIT @"updateHit"
//#define HASH @"hash"
#define FIR_VERSION @"FIR_VERSION"

static DBHCheckVersionModel *shareModel = nil;

@interface DBHCheckVersionModel()

@property (nonatomic, strong) DBHUpdateTipView *tipView;

@end

@implementation DBHCheckVersionModel

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareModel = [[[self class] alloc] init];
    });
    return shareModel;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareModel = [super allocWithZone:zone];
    });
    return shareModel;
}

/**
 检查版本更新
 */
- (void)checkVersion:(NSString *)tipStr {
    if (IS_APPSTORE_APP) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:@"config/get_key_collection/IOS_VERIFY" baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject)  {
            if (![NSObject isNulllWithObject:responseObject]) {
                NSDictionary *dict = responseObject[@"childrens"];
                if (![NSObject isNulllWithObject:dict]) {
                    [weakSelf handleResponse:dict];
                }
            }
        } failure:nil];
    });
}

- (void)handleResponse:(NSDictionary *)dict {
    NSString *versionStr = dict[FIR_VERSION];
    NSString *currentVer = [self currentVersion];
    if (versionStr.integerValue > currentVer.integerValue) { // 需要更新
        NSString *updateTip = dict[UPDATE_HIT];
        NSString *downloadURL = dict[DOWNLOAD_URL];
        NSLog(@"更新提示:%@", updateTip);
        if (updateTip.length > 0) {
            BOOL isForce = [dict[FORCE] boolValue];
            [self needUpdate:updateTip isForce:isForce downloadUrl:downloadURL];
        }
    }
    
}

- (void)needUpdate:(NSString *)tipStr isForce:(BOOL)isForceUpdate downloadUrl:(NSString *)downloadUrl {
    [self.tipView setTipString:tipStr isForce:isForceUpdate  downloadUrl:downloadUrl];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tipView animationShow];
    });
}


- (NSString *)currentVersion {
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

- (DBHUpdateTipView *)tipView {
    if (!_tipView) {
        _tipView = [[DBHUpdateTipView alloc] init];
    }
    return _tipView;
}

@end

