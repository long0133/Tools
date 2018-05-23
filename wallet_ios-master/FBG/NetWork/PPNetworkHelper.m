//
//  PPNetworkHelper.m
//  PPNetworkHelper
//
//  Created by AndyPang on 16/8/12.
//  Copyright © 2016年 AndyPang. All rights reserved.
//


#import "PPNetworkHelper.h"
#import "PPNetworkCache.h"
#import <AFNetworking/AFNetworking.h>

#define MainScreenW [UIScreen mainScreen].bounds.size.width
#ifdef DEBUG
#define PPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PPLog(...)
#endif

@implementation PPNetworkHelper
static AFHTTPSessionManager *_manager = nil;
static NetworkStatus _status;

#pragma mark - 开始监听网络

+ (BOOL)hasConnectedNetwork {
   AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    BOOL result = NO;
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@"未知网络");
            result = YES;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"未连接");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"4G");
            result = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"WIFI");
            result = YES;
            break;
    }
    return result;
}

+ (void)startMonitoringNetwork
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 网络提示
    static UILabel *_warningLabel = nil;
    _warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(-MainScreenW, 64, MainScreenW, 44)];
    _warningLabel.backgroundColor = [UIColor colorWithRed:0.996f green:0.973f blue:0.718f alpha:1.00f];
    _warningLabel.text = DBHGetStringWithKeyFromTable(@"The current network is not available, please check your network Settings.", nil);
    _warningLabel.numberOfLines = 0;
    _warningLabel.textAlignment = NSTextAlignmentCenter;
    _warningLabel.font = [UIFont systemFontOfSize:14];
    [[[UIApplication sharedApplication] keyWindow]addSubview:_warningLabel];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                _status(PPNetworkStatusUnknown);
                [self showMsg:DBHGetStringWithKeyFromTable(@"Unknown network", nil) forStatus:YES warningLabel:_warningLabel];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _status(PPNetworkStatusNotReachable);
                [self showMsg:DBHGetStringWithKeyFromTable(@"The current network is not available, please check your network Settings.", nil) forStatus:NO warningLabel:_warningLabel];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status(PPNetworkStatusReachableViaWWAN);
                [self showMsg:DBHGetStringWithKeyFromTable(@"The network of mobile", nil) forStatus:YES warningLabel:_warningLabel];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status(PPNetworkStatusReachableViaWiFi);
                [self showMsg:@"WIFI" forStatus:YES warningLabel:_warningLabel];
                break;
        }
    }];
    [manager startMonitoring];
}

+ (void)showMsg:(NSString*)msg forStatus:(BOOL)status warningLabel:(UILabel*)warningLabel
{
    if (!status) {
        [[[UIApplication sharedApplication] keyWindow]addSubview:warningLabel];
        warningLabel.text = msg;
        __block CGRect rect = warningLabel.frame;
        [UIView animateWithDuration:0.3 animations:^{
            rect.origin.x = 0;
            warningLabel.frame = rect;
        }];
    }
    else {
        if (warningLabel && warningLabel.frame.origin.x == 0) {
            
            [UIView transitionWithView:warningLabel duration:0.33 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                warningLabel.text = msg;
            } completion:^(BOOL finished) {
                __block CGRect rect = warningLabel.frame;
                [UIView animateWithDuration:0.6 animations:^{
                    rect.origin.x = MainScreenW;
                    warningLabel.frame = rect;
                } completion:^(BOOL finished) {
                    rect.origin.x = -MainScreenW;
                    warningLabel.frame = rect;
                    [warningLabel removeFromSuperview];
                }];
            }];
            
            
        }
    }
}

+ (void)networkStatusWithBlock:(NetworkStatus)status
{
    _status = status;
}

+ (void)gotoLoginVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *targetVC = [UIView currentViewController];
        [[AppDelegate delegate] goToLoginVC:targetVC];
    });
}

#pragma mark - GET请求无缓存
+ (PPURLSessionTask *)GET:(NSString *)URL baseUrlType:(NSInteger)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![NSString isNulllWithObject:hudString]) {
            [LCProgressHUD showLoading:hudString];
        }
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    PPLog(@"❤️GET URL❤️ = %@ -+++❤️+++- %@", URL, [NSThread currentThread]);
    PPLog(@"⚽️GET 数据⚽️ = %@",parameters);
    WEAKSELF
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          
            if ([[responseObject objectForKey:@"code"] intValue] == 4000) {
                success([responseObject objectForKey:@"data"]);
                PPLog(@"responseObject = %@",responseObject);
            } else if ([[responseObject objectForKey:@"code"] intValue] == 4007) {
                success([responseObject objectForKey:@"url"]);
            } else {
                NSString *code = responseObject[@"code"];
                if (code.integerValue == 4009 || code.integerValue == 4010 || code.integerValue == 4011  || code.integerValue == 4001) {
                    // 需要先登录
                    [weakSelf gotoLoginVC];
                    
                    [UserSignData share].user.token = nil;
                    [[UserSignData share] storageData:[UserSignData share].user];
                    return ;
                }
                
                if (![UserSignData share].user.token.length) {
                    [weakSelf gotoLoginVC];
                    return ;
                }
                
                failure([responseObject objectForKey:@"msg"]);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            failure ? failure(error.localizedDescription) : nil;
            PPLog(@"error = %@",error.localizedFailureReason);
        });
    }];
}

#pragma mark - GET请求自动缓存
+ (PPURLSessionTask *)GET:(NSString *)URL baseUrlType:(NSInteger)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure specialBlock:(HttpRequestSpecial)special {
    if ([URL isEqualToString:@"wallet"]) {
        NSLog(@"");
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![NSString isNulllWithObject:hudString]) {
            [LCProgressHUD showLoading:hudString];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    PPLog(@"❤️GET URL❤️ = %@ -+++❤️+++- %@", URL, [NSThread currentThread]);
    PPLog(@"⚽️GET 数据⚽️ = %@",parameters);
    //读取缓存
    id cache = [PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"%@/%@", URL, [NSString dataTOjsonString:parameters]]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        responseCache(cache);
    });
    
    if (![self hasConnectedNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        return nil;
    }
    
    WEAKSELF
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([[responseObject objectForKey:@"code"] intValue] == 4000) {
                if (success) {
                    success([responseObject objectForKey:@"data"]);
                }
                NSString *key = [NSString stringWithFormat:@"%@/%@", URL, [NSString dataTOjsonString:parameters]];
                [PPNetworkCache saveResponseCache:[responseObject objectForKey:@"data"] forKey:key];
                PPLog(@"responseObject = %@", responseObject);
            } else if ([[responseObject objectForKey:@"code"] intValue] == 4007) {
                if (success) {
                    success([responseObject objectForKey:@"url"]);
                }
            } else {
                NSString *code = responseObject[@"code"];
                if (code.integerValue == 4009 || code.integerValue == 4010 || code.integerValue == 4011  || code.integerValue == 4001) {
                    if (special) {
                        special();
                    } else {
                        // 需要先登录
                        [weakSelf gotoLoginVC];
                        
                        [UserSignData share].user.token = nil;
                        [[UserSignData share] storageData:[UserSignData share].user];
                    }
                    return ;
                }
                
                if (![UserSignData share].user.token.length) {
                    if (special) {
                        special();
                    } else {
                        [weakSelf gotoLoginVC];
                    }
                    return ;
                }
                
                if (failure) {
                    failure([responseObject objectForKey:@"msg"]);
                }
            }
        
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            failure ? failure(error.localizedDescription) : nil;
            PPLog(@"error = %@",error.localizedDescription);
        });
    }];
}

#pragma mark - POST请求无缓存
+ (PPURLSessionTask *)POST:(NSString *)URL baseUrlType:(NSInteger)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![NSString isNulllWithObject:hudString]) {
            [LCProgressHUD showLoading:hudString];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    
//    NSString * requestUrl;
//    if ([URL containsString:@"http"]) {
//        requestUrl = URL;
//    } else {
//        requestUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appNetWorkApi"] stringByAppendingPathComponent:URL];
//    }
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    PPLog(@"❤️POST URL❤️ = %@",URL);
    PPLog(@"⚽️POST 数据⚽️ = %@",parameters);
    
    WEAKSELF
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PPLog(@"responseObject = %@",responseObject);
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([URL containsString:@"http"]) {
                success([responseObject objectForKey:@"result"]);
                return ;
            }
            if ([[responseObject objectForKey:@"code"] intValue] == 4000 || [URL containsString:@"http"]) {
                success([responseObject objectForKey:@"data"]);
            } else if ([[responseObject objectForKey:@"code"] intValue] == 4007) {
                success([responseObject objectForKey:@"url"]);
            }  else {
                NSString *code = responseObject[@"code"];
                if (code.integerValue == 4009 || code.integerValue == 4010 || code.integerValue == 4011  || code.integerValue == 4001) {
                    // 需要先登录
                    [weakSelf gotoLoginVC];
                    
                    [UserSignData share].user.token = nil;
                    [[UserSignData share] storageData:[UserSignData share].user];
                    return ;
                }
                
                if (![URL isEqualToString:@"login"] &&
                    ![URL isEqualToString:@"register"] &&
                    ![UserSignData share].user.token.length) {
                    [weakSelf gotoLoginVC];
                    return ;
                }
                
                NSString *error = [responseObject objectForKey:@"msg"];
                if ([URL isEqualToString:@"wallet-order"] && code.integerValue == 4006) {
                    error = DBHGetStringWithKeyFromTable(@"Has Uncompleted Orders", nil);
                }
                
                failure(error);
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            failure ? failure(error.localizedDescription) : nil;
            PPLog(@"error = %@",error.localizedDescription);
        });
    }];
    
}
+ (PPURLSessionTask *)POSTOtherURL:(NSString *)URL parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![NSString isNulllWithObject:hudString]) {
            [LCProgressHUD showLoading:hudString];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    
    //    NSString * requestUrl;
    //    if ([URL containsString:@"http"]) {
    //        requestUrl = URL;
    //    } else {
    //        requestUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appNetWorkApi"] stringByAppendingPathComponent:URL];
    //    }
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:1];
    PPLog(@"❤️POST URL❤️ = %@",URL);
    PPLog(@"⚽️POST 数据⚽️ = %@",parameters);
    
    WEAKSELF
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![NSString isNulllWithObject:hudString])
                    {
                        [LCProgressHUD hide];
                    }
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    if ([URL containsString:@"http"]) {
                        success([responseObject objectForKey:@"result"]);
                        return ;
                    }
                    if ([[responseObject objectForKey:@"code"] intValue] == 4000 || [URL containsString:@"http"]) {
                        success([responseObject objectForKey:@"data"]);
                        PPLog(@"responseObject = %@",responseObject);
                    } else if ([[responseObject objectForKey:@"code"] intValue] == 4007) {
                        success([responseObject objectForKey:@"url"]);
                    } else {
                        NSString *code = responseObject[@"code"];
                        if (code.integerValue == 4009 || code.integerValue == 4010 || code.integerValue == 4011  || code.integerValue == 4001) {
                            // 需要先登录
                            [weakSelf gotoLoginVC];
                            
                            [UserSignData share].user.token = nil;
                            [[UserSignData share] storageData:[UserSignData share].user];
                            return ;
                        }
                      
                        if (![UserSignData share].user.token.length) {
                            [weakSelf gotoLoginVC];
                            return ;
                        }
                        
                        failure([responseObject objectForKey:@"msg"]);
                    }
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![NSString isNulllWithObject:hudString]) {
                        [LCProgressHUD hide];
                    }
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    failure ? failure(error.localizedDescription) : nil;
                    PPLog(@"error = %@",error.localizedDescription);
                });
            }];
    
}

#pragma mark - POST请求自动缓存
+ (PPURLSessionTask *)POST:(NSString *)URL baseUrlType:(NSInteger)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure special:(HttpRequestSpecial)special {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![NSString isNulllWithObject:hudString]) {
            [LCProgressHUD showLoading:hudString];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    PPLog(@"❤️POST URL❤️ = %@",URL);
    PPLog(@"⚽️POST 数据⚽️ = %@",parameters);
    //读取缓存
    id cache = [PPNetworkCache getResponseCacheForKey:[NSString stringWithFormat:@"%@/%@", URL, [NSString dataTOjsonString:parameters]]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        responseCache(cache);
    });
    
    if (![self hasConnectedNetwork]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        return nil;
    }
    WEAKSELF
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
            if ([[responseObject objectForKey:@"code"] intValue] == 4000) {
                success([responseObject objectForKey:@"data"]);
                [PPNetworkCache saveResponseCache:[responseObject objectForKey:@"data"] forKey:[NSString stringWithFormat:@"%@/%@", URL, [NSString dataTOjsonString:parameters]]];
                PPLog(@"responseObject = %@",responseObject);
            } else if ([[responseObject objectForKey:@"code"] intValue] == 4007) {
                success([responseObject objectForKey:@"url"]);
            } else {
                NSString *code = responseObject[@"code"];
                if (code.integerValue == 4009 || code.integerValue == 4010 || code.integerValue == 4011  || code.integerValue == 4001) {
                    if (special) {
                        special();
                    } else {
                        // 需要先登录
                        [weakSelf gotoLoginVC];
                        
                        [UserSignData share].user.token = nil;
                        [[UserSignData share] storageData:[UserSignData share].user];
                    }
                    return ;
                }
                
                if (![UserSignData share].user.token.length) {
                    if (special) {
                        special();
                    } else {
                        // 需要先登录
                        [weakSelf gotoLoginVC];
                    }
                    return ;
                }
                
                failure([responseObject objectForKey:@"msg"]);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            failure ? failure(error.localizedDescription) : nil;
            PPLog(@"error = %@",error.localizedDescription);
        });
    }];
    
}

+ (PPURLSessionTask *)PUT:(NSString *)URL baseUrlType:(NSInteger)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![NSString isNulllWithObject:hudString]) {
            [LCProgressHUD showLoading:hudString];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    PPLog(@"❤️PUT URL❤️ = %@",URL);
    PPLog(@"⚽️PUT 数据⚽️ = %@",parameters);
    
    return [manager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([[responseObject objectForKey:@"code"] intValue] == 4000) {
                success([responseObject objectForKey:@"data"]);
                PPLog(@"responseObject = %@",responseObject);
            } else if ([[responseObject objectForKey:@"code"] intValue] == 4007) {
                success([responseObject objectForKey:@"url"]);
            } else {
                failure([responseObject objectForKey:@"msg"]);
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            failure ? failure(error.localizedDescription) : nil;
            PPLog(@"error = %@",error.localizedDescription);
        });
    }];
}

+ (PPURLSessionTask *)DELETE:(NSString *)URL baseUrlType:(NSInteger)baseUrlType parameters:(NSDictionary *)parameters hudString:(NSString *)hudString success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![NSString isNulllWithObject:hudString])
        {
            [LCProgressHUD showLoading:hudString];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:baseUrlType];
    PPLog(@"❤️DELETE URL❤️ = %@",URL);
    PPLog(@"⚽️DELETE 数据⚽️ = %@",parameters);
    
    return [manager DELETE:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![NSString isNulllWithObject:hudString]) {
                            [LCProgressHUD hide];
                    }
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                    if ([[responseObject objectForKey:@"code"] intValue] == 4000) {
                        success([responseObject objectForKey:@"data"]);
                        PPLog(@"responseObject = %@",responseObject);
                    } else if ([[responseObject objectForKey:@"code"] intValue] == 4007) {
                        success([responseObject objectForKey:@"url"]);
                    } else {
                        failure([responseObject objectForKey:@"msg"]);
                    }
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![NSString isNulllWithObject:hudString]) {
                        [LCProgressHUD hide];
                    }
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    failure ? failure(error.localizedDescription) : nil;
                    PPLog(@"error = %@",error.localizedDescription);
                });
            }];
}


#pragma mark - 上传图片文件
+ (PPURLSessionTask *)uploadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType hudString:(NSString *)hudString progress:(HttpProgress)progress success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
        if (![NSString isNulllWithObject:hudString])
        {
                [LCProgressHUD showLoading:@"上传中..."];
        }
    });
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:1];
    return [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@%ld.%@",fileName,idx,mimeType?mimeType:@"jpeg"] mimeType:[NSString stringWithFormat:@"image/%@",mimeType?mimeType:@"jpeg"]];
            
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //上传进度
            progress ? progress(uploadProgress) : nil;
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString]) {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            success(responseObject);
            PPLog(@"responseObject = %@",responseObject);
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)  {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isNulllWithObject:hudString])
            {
                [LCProgressHUD hide];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            failure ? failure(error.localizedDescription) : nil;
            PPLog(@"error = %@",error.localizedDescription);
        });
    }];
}

#pragma mark - 下载文件
+ (PPURLSessionTask *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttpProgress)progress success:(void(^)(NSString *))success failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWithUrl:URL baseUrlType:1];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //下载进度
            progress ? progress(downloadProgress) : nil;
            PPLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        PPLog(@"downloadDir = %@",downloadDir);
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
            failure && error ? failure(error.localizedDescription) : nil;
        });
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    return downloadTask;
}


#pragma mark - 设置AFHTTPSessionManager相关属性

+ (AFHTTPSessionManager *)createAFHTTPSessionManagerWithUrl:(NSString *)url baseUrlType:(NSInteger)baseUrlType
{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *baseUrl;
    switch (baseUrlType) {
        case 1:
            baseUrl = [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD1 : TESTAPIEHEAD1;
            break;
        case 2:
            baseUrl = [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD2 : TESTAPIEHEAD2;
            break;
        case 3:
            baseUrl = [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD3 : TESTAPIEHEAD3;
            break;
        case 4:
            baseUrl = CHECKVERSION;
            break;
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    //设置请求参数的类型:HTTP (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 60.f;
//    manager.operationQueue.maxConcurrentOperationCount = 10;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/x-www-form-urlencoded", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager.requestSerializer setValue:[[DBHLanguageTool sharedInstance].language isEqualToString:CNS] ? @"zh" : @"en" forHTTPHeaderField:@"lang"];
    NSLog(@"request ---- %d ---- %@", [UserSignData share].user.token.length > 0, url);
    UserSignData *signData = [UserSignData share];
    if (signData.user.token.length > 0) {
        [manager.requestSerializer setValue:[UserSignData share].user.token forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:@"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" forHTTPHeaderField:@"neo-asset-id"];
        [manager.requestSerializer setValue:@"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7" forHTTPHeaderField:@"neo-gas-asset-id"];
    }
    return manager;
}

- (NSString *)errorFromCode:(int)code
{
    /*
     4000    请求执行成功
     4010    未登陆
     4002    无权限
     4003    路由不存在
     4004    验证不通过
     4005    查询数据不存在
     4006    请求执行失败
     4007    请求执行成功,即将跳转
     4008    未注册
     4009    token过期
     */
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:DBHGetStringWithKeyFromTable(@"Request success", nil) forKey:@"4000"];
    [dic setObject:@"未登陆" forKey:@"4010"];
    [dic setObject:@"无权限" forKey:@"4002"];
    [dic setObject:@"路由不存在" forKey:@"4003"];
    [dic setObject:@"验证不通过" forKey:@"4004"];
    [dic setObject:@"查询数据不存在" forKey:@"4005"];
    [dic setObject:@"请求执行失败" forKey:@"4006"];
    [dic setObject:@"请求执行成功,即将跳转" forKey:@"4007"];
    [dic setObject:@"未注册" forKey:@"4008"];
    [dic setObject:@"token过期" forKey:@"4009"];
    
    return [dic objectForKey:[NSString stringWithFormat:@"%d",code]];
}

@end
