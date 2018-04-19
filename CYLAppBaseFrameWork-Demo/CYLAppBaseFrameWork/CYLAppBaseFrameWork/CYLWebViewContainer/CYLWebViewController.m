//
//  CYLWebViewController.m
//  CYLWebViewContainer
//
//  Created by chinapex on 2018/4/12.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLWebViewController.h"
#import "CYLWebView.h"
#import "CYLNetWorkManager.h"
#import "CYLWebHandle.h"

static CYLWebViewController * _instance = nil;
extern CFAbsoluteTime startTime;

@interface CYLWebViewController ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>
@property (nonatomic, strong) CYLWebView *webView;

@end

@implementation CYLWebViewController
@synthesize jsCodeArr = _jsCodeArr;
@synthesize messageHandlerNameArr = _messageHandlerNameArr;
@synthesize triggerFuncFromInjectionAfterNavigationDoneArr = _triggerFuncFromInjectionAfterNavigationDoneArr;

- (void)loadView{
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.webView loadHtml:self.request];
//    [CYLNetWorkManager GET:_request.URL.absoluteString parameter:@{} success:^(CYLResponse *response) {
//        NSLog(@"htmlString : %f",CFAbsoluteTimeGetCurrent() - startTime);
//        NSString *htmlString = [[NSString alloc] initWithData:response.returnObj encoding:NSUTF8StringEncoding];
//        [self.webView loadLocalHTMLString:htmlString];
//
//    } fail:^(NSError *error) {
//
//    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self clearDataBase];
}

#pragma mark - private
- (void)clearDataBase{
    
}

#pragma mark - singleton
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone ];
    });
    return _instance;
}

+(instancetype) sharedInstance{
    if (_instance == nil) {
        _instance = [[super alloc]init];
    }
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

- (void)setRequest:(NSURLRequest *)request{
    _request = request;
    [self.webView loadHtml:self.request];
}

- (void)pre_initWebView{
    //初始化一个WKWebViewConfiguration对象
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    WKWebView *webView = [[CYLWebView alloc]initWithFrame:self.view.frame configuration:config];
    webView.navigationDelegate = self;
    webView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:webView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [webView removeFromSuperview];
    });
}

#pragma mark -  delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    for (NSString *funcName in self.triggerFuncFromInjectionAfterNavigationDoneArr) {
        [self.webView evaluateJavaScript:funcName completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            
        }];
    }
    
}

#pragma mark - script delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([self.handlers.allKeys containsObject:message.name]) {
        
        CYLWebHandle *handle = self.handlers[message.name];
        if (handle.msgHandle) {
            handle.msgHandle(userContentController, message);
        }
    }
}

#pragma mark - getter
- (CYLWebView *)webView{
    if (!_webView) {
        
        //注入JS监听pagehide事件阻止页面进入bfcache
        NSString *jScript = @"window.addEventListener('pagehide', function(e) {\
        var $body = $(document.body);\
        $body.children().remove();\
        setTimeout(function() {\
            $body.append(\"<script type='text/javascript'>window.location.reload();</script>\");\
        });\
    });";
        
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [wkUController addUserScript:wkUScript];
        
        //注入自定义js代码
        for (NSString *jsCode in self.jsCodeArr) {
            WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
            [wkUController addUserScript:wkUScript];
        }
        
        //添加messageHandler
        for (NSString *name in self.messageHandlerNameArr) {
            [wkUController addScriptMessageHandler:self name:name];
        }
        
        //初始化一个WKWebViewConfiguration对象
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        _webView = [[CYLWebView alloc]initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (NSArray *)jsCodeArr
{
    if (!_jsCodeArr) {
        _jsCodeArr = [NSArray array];
    }
    return _jsCodeArr;
}

- (NSArray *)messageHandlerNameArr
{
    if (!_messageHandlerNameArr) {
        _messageHandlerNameArr = [NSArray array];
    }
    return _messageHandlerNameArr;
}

- (NSArray *)triggerFuncFromInjectionAfterNavigationDoneArr{
    if (!_triggerFuncFromInjectionAfterNavigationDoneArr) {
        _triggerFuncFromInjectionAfterNavigationDoneArr = [NSArray array];
    }
    return _triggerFuncFromInjectionAfterNavigationDoneArr;
}

@end
