//
//  CYLWebView.h
//  CYLWebViewContainer
//
//  Created by chinapex on 2018/4/12.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface CYLWebView : WKWebView
- (WKNavigation*_Nullable)loadHtml:(NSURLRequest*_Nonnull)request;
- (WKNavigation*_Nonnull)loadLocalHTMLString:(NSString*_Nonnull)htmlString;
- (void)evaluateJavaScript:(NSString *_Nonnull)js completionHandler:(void (^_Nullable)(id _Nullable, NSError * _Nullable))completionHandler;
@end
