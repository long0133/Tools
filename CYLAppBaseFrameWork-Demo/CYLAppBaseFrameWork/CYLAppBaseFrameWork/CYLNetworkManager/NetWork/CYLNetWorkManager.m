//
//  CYLNetWorkManager.m
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/3/29.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLNetWorkManager.h"
#import <AFNetworking.h>
//#import "CYLNetworkConfigration.h"
#import "CYLNetWorkCache.h"
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreTelephony/CTCellularData.h>
#import <CommonCrypto/CommonDigest.h>


static CYLNetWorkManager *_instance;

@interface CYLNetWorkManager()
@property (nonatomic, assign) CYLNetWorkStatus netWorkStatus;
@property (nonatomic, strong) AFHTTPSessionManager *manner;
@property (nonatomic, strong) NSThread *netWorkThread;
@property (nonatomic, strong) NSRunLoop *netWorkRunLoop;
@property (nonatomic, strong) NSURL *baseURL;
@end

@implementation CYLNetWorkManager
#pragma mark - singleton
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            [_instance monitorNetworkState];
            [_instance startNetWorkThread];
            [CYLNetWorkCache shareInstance].netWorkThread = _instance.netWorkThread;
        }
    });
    return _instance;
}

+ (instancetype)shareInstance
{
    return [[self alloc]init];
}

#pragma mark - public
//监听网络权限是否开启
+ (void)monitorNetworkStatusOnViewController:(UIViewController*)vc{

    [self cellureMonitor:^(CTCellularDataRestrictedState state) {
        if (state == kCTCellularDataRestricted) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已关闭网络使用权限" message:@"是否前去开启网络" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *prefs = [NSString stringWithFormat:@"prefs:root=%@",@"General&path=Network"];
                NSURL *url = [NSURL URLWithString:prefs];
                if ([UIDevice currentDevice].systemVersion.doubleValue > 8.0f) {
                    url= [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                }
                
                if([[UIApplication sharedApplication] canOpenURL:url]){
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                }
            }]];
            
//            @weakify(alertController);
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                @strongify(alertController);
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [vc presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark - private

+ (NSURLSessionDataTask*)GET:(NSString*)url parameter:(id)param success:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock{
    return [self GET:url CachePolicy:CYLNetWorkCachePolicy_DoNotCache activePeriod:0 parameter:param success:successBlock fail:failBlock];
}

+ (NSURLSessionDataTask*)POST:(NSString*)url parameter:(id)param success:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock{
    return [self POST:url CachePolicy:CYLNetWorkCachePolicy_DoNotCache activePeriod:0 parameter:param success:successBlock fail:failBlock];
} 

+ (NSURLSessionDataTask*)GET:(NSString*)url CachePolicy:(CYLNetWorkCachePolicy)policy activePeriod:(NSTimeInterval)period parameter:(id)param success:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock{
    
    if (![[CYLNetWorkManager shareInstance] judgeIfNewWorkingAvailable]) {
        //无网络状态
        [[CYLNetWorkManager shareInstance] treatNetWorkNotAvailable];
    }
    
    NSString *cacheKey = [self getCacheKey:url params:param];
    CYLResponse *cachedRes = [[CYLNetWorkCache shareInstance] getResponseFromCacheWithKey:cacheKey];
    if (cachedRes) {
        if (successBlock) {
            successBlock(cachedRes);
            return nil;
        }
    }
    
    return [[CYLNetWorkManager shareInstance].manner GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (successBlock) {
            CYLResponse *res = [self prepareResponse:responseObject];
            res.cachePolicy = policy;
            res.url = url;
            res.cachePeriod = period;
            res.cacheKey = cacheKey;
            [self cacheResponse:res];
            successBlock(res);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failBlock) {
            failBlock(error);
        }
    }];
}

+ (NSURLSessionDataTask*)POST:(NSString*)url CachePolicy:(CYLNetWorkCachePolicy)policy activePeriod:(NSTimeInterval)period parameter:(id)param success:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock{
    
    if (![[CYLNetWorkManager shareInstance] judgeIfNewWorkingAvailable]) {
        //无网络状态
        [[CYLNetWorkManager shareInstance] treatNetWorkNotAvailable];
    }
    
    NSString *cacheKey = [self getCacheKey:url params:param];
    CYLResponse *cachedRes = [[CYLNetWorkCache shareInstance] getResponseFromCacheWithKey:cacheKey];
    if (cachedRes) {
        if (successBlock) {
            successBlock(cachedRes);
            return nil;
        }
    }
    
    return [[CYLNetWorkManager shareInstance].manner POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            CYLResponse *res = [self prepareResponse:responseObject];
            res.cachePolicy = policy;
            res.url = url;
            res.cachePeriod = period;
            res.cacheKey = cacheKey;
            [self cacheResponse:res];
            successBlock(res);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        if (failBlock) {
            failBlock(error);
        }
    }];
}

//缓存处理
+ (void)cacheResponse:(CYLResponse*)response{
    [[CYLNetWorkCache shareInstance] cacheResponse:response];
}


/**
 获取请求的md5key
 */
+ (NSString*)getCacheKey:(NSString*)url params:(NSDictionary*)params{
    NSString *key = [NSMutableString stringWithString:url];
    NSString *paramStr = [NSMutableString string];
    
    if ([params isKindOfClass:[NSDictionary class]] || [params isKindOfClass:[NSMutableDictionary class]]) {
        for (NSString *value in params.allValues) {
            [paramStr stringByAppendingString:[NSString stringWithFormat:@"&%@",value]];
        }
    }else if ([params isKindOfClass:[NSArray class]] || [params isKindOfClass:[NSMutableArray class]]){
        NSArray *paramArr = (NSArray*)params;
        for (NSString *value in paramArr) {
            [paramStr stringByAppendingString:[NSString stringWithFormat:@"&%@",value]];
        }
    }
    
    key = [key stringByAppendingString:paramStr];
    key = [self md5:key];
    return key;
}

//无网络状态下的处理流程
- (void)treatNetWorkNotAvailable{
    NSLog(@"network not reachable");
}

- (BOOL)judgeIfNewWorkingAvailable{
    BOOL flag = YES;
    
    switch ([self currentNetWorkStatus]) {
        case CYLNetWorkStatus_NotReachable:
            flag = false;
            break;
        case CYLNetWorkStatus_UNKnow:
        case CYLNetWorkStatus_Wifi:
        case CYLNetWorkStatus_Celluler:
            flag = YES;
            break;
    }
    
    return flag;
}

//开启常驻线程
- (void)startNetWorkThread{
    self.netWorkThread = [[NSThread alloc] initWithTarget:self selector:@selector(runLoopRun) object:nil];
    self.netWorkThread.name = @"CYLNetWorkThread";
    [self.netWorkThread start];
}

- (void)runLoopRun{
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    self.netWorkRunLoop = [NSRunLoop currentRunLoop];
    [self.netWorkRunLoop addTimer:[NSTimer timerWithTimeInterval:1000 repeats:YES block:^(NSTimer * _Nonnull timer) {
    }] forMode:NSRunLoopCommonModes];
    
    [[NSRunLoop currentRunLoop] run];
}


+ (CYLResponse*)prepareResponse:(id)responseObj{
    CYLResponse *res = [[CYLResponse alloc] init];
    res.returnObj = responseObj;
    return res;
}

- (void)monitorNetworkState{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CYLNetWorkStatusHasChnagedNotification object:self];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.netWorkStatus = CYLNetWorkStatus_UNKnow;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.netWorkStatus = CYLNetWorkStatus_NotReachable;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.netWorkStatus = CYLNetWorkStatus_Celluler;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.netWorkStatus = CYLNetWorkStatus_Wifi;
                break;
                
            default:
                break;
        }
    }] ;
    [manager startMonitoring];
}

- (CYLNetWorkStatus)currentNetWorkStatus{
    return self.netWorkStatus;
}

+ (void)cellureMonitor:(void(^)(CTCellularDataRestrictedState state))stateBlock{
    CTCellularData *cellular = [[CTCellularData alloc] init];
    cellular.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        stateBlock(state);
    };
}

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

#pragma mark - getter setter
- (AFHTTPSessionManager *)manner{
    if (!_manner) {
        NSAssert(_baseURL != nil, @"CYLNetWorkManager's base url cannot be nil, use instance method -(void)setBaseUrl: to set one");
        _manner = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseURL];
        _manner.requestSerializer.timeoutInterval = 10;
        _manner.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        _manner.securityPolicy = securityPolicy;
    }
    return _manner;
}

- (AFHTTPSessionManager *)getManager{
    return self.manner;
}

- (void)setBaseUrl:(NSURL *)baseurl{
    _baseURL = baseurl;
}

@end
