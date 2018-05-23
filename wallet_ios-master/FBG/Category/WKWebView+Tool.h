//
//  WKWebView+Tool.h
//  FBG
//
//  Created by yy on 2018/3/14.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (Tool)

- (void)ZFJContentCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler ;
- (void)ZFJContentPageDrawTargetView:(UIView *)targetView index:(int)index maxIndex:(int)maxIndex drawCallback:(void(^)())drawCallback;
- (void)ZFJContentCaptureWithoutOffsetCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;
@end
