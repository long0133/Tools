//
//  WKWebView+ZFJViewCapture.h
//  FingerprintUnlock.git
//
//  Created by ZFJ on 2016/10/31.
//  Copyright © 2016年 张福杰. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (ZFJViewCapture)

- (void)ZFJContentCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;

- (void)ZFJContentScrollCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;

@end
