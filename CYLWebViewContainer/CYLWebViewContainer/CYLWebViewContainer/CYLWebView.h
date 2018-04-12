//
//  CYLWebView.h
//  CYLWebViewContainer
//
//  Created by chinapex on 2018/4/12.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface CYLWebView : WKWebView
- (WKNavigation*)loadHtml:(NSURLRequest*)request;
- (WKNavigation*)loadLocalHTMLString:(NSString*)htmlString;
@end
