//
//  DBHHelpCenterWebViewController.m
//  FBG
//
//  Created by yy on 2018/3/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHHelpCenterWebViewController.h"
#import "DBHFeedbackViewController.h"

@interface DBHHelpCenterWebViewController ()<WKUIDelegate,WKNavigationDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) CALayer *progresslayer;
@property (weak, nonatomic) UIView *bottomView;
@property (weak, nonatomic) WKWebView *webView;

@property (nonatomic, strong) NSString *urlStr;

@end

@implementation DBHHelpCenterWebViewController

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _urlStr = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DBHGetStringWithKeyFromTable(@"Help Center", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController) {
        if ([self.navigationController.viewControllers count] > 1) {
            UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
            leftBarButtonItem.width = -30;
            self.navigationItem.leftBarButtonItem = leftBarButtonItem;
            [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
            
            UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Feedback", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToFeedbackButton)];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:FONT(15),NSFontAttributeName, nil];
            [rightBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
            [rightBarItem setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
            self.navigationItem.rightBarButtonItem = rightBarItem;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


-(void)setupUI {
    WKWebView *webView=[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    _webView = webView;
    
    if (![_urlStr containsString:@"<"]) {
        //添加属性监听
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        //进度条
        UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
        progress.backgroundColor = [UIColor clearColor];
        [self.view addSubview:progress];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 3);
        layer.backgroundColor = [UIColor colorWithHexString:@"FDD930"].CGColor;
        [progress.layer addSublayer:layer];
        _progresslayer = layer;
    }
    
    if ([_urlStr containsString:@"<"]) {
        [webView loadHTMLString:_urlStr baseURL:nil];
    } else {
        NSURL *url=[NSURL URLWithString:self.urlStr];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

#pragma mark - 响应按钮事件
- (void)respondsToFeedbackButton {
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
    } else {
        [self pushToFeedbackVC];
    }
}

#pragma mark - 跳转事件
- (void)pushToFeedbackVC {
    DBHFeedbackViewController *feedbackVC = [[DBHFeedbackViewController alloc] init];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

#pragma mark---WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


//加载失败调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //    [_activityIndicator stopAnimating];
    if (_bottomView == nil) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        _bottomView = bottomView;
        UITapGestureRecognizer *recongizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
        [bottomView addGestureRecognizer:recongizer];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150)];
        imageView.center = CGPointMake(bottomView.center.x, bottomView.center.y-64.0);
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [UIImage imageNamed:@"noData"];
        [bottomView addSubview:imageView];
    }else {
        _bottomView.hidden = NO;
    }
}


/** 观察加载进度 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progresslayer.opacity = 1;
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else if ([keyPath isEqualToString:@"title"]){
        //        self.title = self.webView.title;
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)action {
    _bottomView.hidden = YES;
    if (!_webView.isLoading) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    }
}

- (void)onClickBack {
    if (self.webView.canGoBack == YES) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc{
    NSLog(@"%@", NSStringFromClass([self class]));
    if (![_urlStr containsString:@"<"]) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
}

@end
