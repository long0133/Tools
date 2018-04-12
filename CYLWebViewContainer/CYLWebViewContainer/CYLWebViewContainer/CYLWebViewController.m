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

static CYLWebViewController * _instance = nil;
extern CFAbsoluteTime startTime;

@interface CYLWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) CYLWebView *webView;
@end

@implementation CYLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView loadHtml:self.request];
//    [CYLNetWorkManager GET:_request.URL.absoluteString parameter:@{} success:^(CYLResponse *response) {
//        NSLog(@"htmlString : %f",CFAbsoluteTimeGetCurrent() - startTime);
//        NSString *htmlString = [[NSString alloc] initWithData:response.returnObj encoding:NSUTF8StringEncoding];
//        [self.webView loadLocalHTMLString:htmlString];
//
//    } fail:^(NSError *error) {
//
//    }];
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
}

#pragma mark -  delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //  在发送请求之前，决定是否跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
    NSLog(@"decidePolicyForNavigationAction :%f",CFAbsoluteTimeGetCurrent() - startTime);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    // 页面开始加载时调用
    NSLog(@"didStartProvisionalNavigation :%f",CFAbsoluteTimeGetCurrent() - startTime);
    
}


- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    // 接收到服务器跳转请求之后调用
    
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation :%f",CFAbsoluteTimeGetCurrent() - startTime);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling ,nil);
    
    NSLog(@"didReceiveAuthenticationChallenge :%f",CFAbsoluteTimeGetCurrent() - startTime);
}


//以下三个是连续调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    // 在收到响应后，决定是否跳转和发送请求之前那个允许配套使用
    decisionHandler(WKNavigationResponsePolicyAllow);
    
    NSLog(@"decidePolicyForNavigationResponse :%f",CFAbsoluteTimeGetCurrent() - startTime);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    // 当内容开始返回时调用
    NSLog(@"didCommitNavigation :%f",CFAbsoluteTimeGetCurrent() - startTime);
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    // 页面加载完成之后调用
    NSLog(@"didFinishNavigation :%f",CFAbsoluteTimeGetCurrent() - startTime);
}

#pragma mark - getter
- (CYLWebView *)webView{
    if (!_webView) {
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
        
        _webView = [[CYLWebView alloc]initWithFrame:self.view.frame configuration:config];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
