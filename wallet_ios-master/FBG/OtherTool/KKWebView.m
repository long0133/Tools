//
//  KKWebView.m
//  StomatologicalOfCustomer
//
//  Created by 吴灶洲 on 2017/6/30.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import "KKWebView.h"
#import <WebKit/WebKit.h>
#import "ChoseWalletView.h"
#import "CommitOrderView.h"
//#import "ConfirmationTransferVC.h"
#import "WKWebView+Tool.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "LYShareMenuView.h"
#import <TwitterKit/TWTRComposer.h>

#import "CustomActivity.h"
#import "WXApi.h"
#import "WalletLeftListModel.h"
#import "DBHSharePictureViewController.h"
#import "DBHBaseNavigationController.h"
#import "WKWebView+ZFJViewCapture.h"

@interface KKWebView ()<WKUIDelegate,WKNavigationDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, ChoseWalletViewDelegate, CommitOrderViewDelegate, LYShareMenuViewDelegate, WXApiDelegate>

@property (weak, nonatomic) CALayer *progresslayer;
@property (weak, nonatomic) UIView *bottomView;
@property (weak, nonatomic) WKWebView *webView;

@property (nonatomic, strong) ChoseWalletView * choseWalletView;
@property (nonatomic, strong) CommitOrderView * commitOrderView;

//转账订单生产
@property (nonatomic, strong) WalletLeftListModel * walletModel;
@property (nonatomic, copy) NSString * gasPrice;   //手续费单价
@property (nonatomic, copy) NSString * totleGasPrice;       //总手续费
@property (nonatomic, copy) NSString * nonce;
@property (nonatomic, assign) int defaultGasNum;
@property (nonatomic, copy) NSString * banlacePrice;

@property (nonatomic, strong) LYShareMenuView *sharedMenuView;
@property (nonatomic, strong) NSMutableArray *sharedMenuItems;

@property (nonatomic, strong) UIImage *shareIconImg;
@property (nonatomic, strong) UIImage *captureImg;

@property (nonatomic, assign) BOOL isLoadFinish;

@end

@implementation KKWebView

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _urlStr = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController) {
        if ([self.navigationController.viewControllers count] > 1)
        {
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *backImageName = @"返回-3";
            
            [backButton setImage:[[UIImage imageNamed:backImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
            
            backButton.frame = CGRectMake(0, 0, 40, 40);
            [backButton setImageEdgeInsets:UIEdgeInsetsMake(4, -10, 4, 0)];
            backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
            //        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            // 设置返回按钮
            
            UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//            UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
//            leftBarButtonItem.width = -30;
            self.navigationItem.leftBarButtonItem = backBarButtonItem;
            [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
            
            if (self.isHaveShare) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gonggaoxiangqing_gengduo"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToShareBarButtonItem)];
            } else {
                UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shishihangqing_shuaxin"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButton)];
                self.navigationItem.rightBarButtonItem = rightBarButtonItem;
            }
        }
    }
    if (self.isLogin)
    {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
        leftBarButtonItem.width = -30;
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_sharedMenuView.delegate) {
        _sharedMenuView.delegate = nil;
    }
}

-(void)setupUI {
    WKWebView *webView=[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    webView.UIDelegate=self;
    webView.navigationDelegate=self;
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
    
    //模拟按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 100, 100, 100);
    [button setTitle:@"前往支付" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    NSLog(@"createWebViewWithConfiguration");
    
    if (!navigationAction.targetFrame.isMainFrame) {
        
        [webView loadRequest:navigationAction.request];
        
    }
    
    return nil;
    
}

- (void)rightButton {
    // 刷新
    [self.webView reload];
}

- (void)buttonClicked
{
    //模拟
    [self.choseWalletView showWithView:nil];
}

//选择钱包回调
- (void)sureButtonCilickWithData:(id)data
{
//    self.walletModel = data;
//
//    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"Loading...", nil)];
//    //获取账户余额
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:self.walletModel.address forKey:@"address"];
//
//    [PPNetworkHelper POST:@"extend/getBalance" parameters:dic hudString:nil success:^(id responseObject)
//     {
//         self.banlacePrice = [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[[responseObject objectForKey:VALUE] substringFromIndex:2]] secend:@"1000000000000000000" value:4];
//         self.commitOrderView.banalceLB.text = [NSString stringWithFormat:@"(当前余额:%@)",self.banlacePrice];
//
//         //获取gas手续费
//         NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
//         [parametersDic setObject:@(self.walletModel.category_id) forKey:@"category_id"];
//         [parametersDic setObject:@"1" forKey:@"type"];
//
//         [PPNetworkHelper GET:@"gas" baseUrlType:1 parameters:parametersDic hudString:nil success:^(id responseObject)
//          {
//              //获取单价
//              NSString * per = @"0";
//              if (![NSString isNulllWithObject:[responseObject objectForKey:@"gas"]])
//              {
//                  per = [[responseObject objectForKey:RECORD] objectForKey:@"gas"];
//              }
//              self.gasPrice = [NSString DecimalFuncWithOperatorType:3 first:per secend:@"1000000000000000000" value:4];
//              self.totleGasPrice = [NSString DecimalFuncWithOperatorType:2 first:self.gasPrice secend:[NSString stringWithFormat:@"%d",self.defaultGasNum] value:4];
//              self.commitOrderView.changesPriceLB.text = self.totleGasPrice;
//
//              [self.commitOrderView.priceSilder setValue:[self.totleGasPrice floatValue]];
//
//              //获取交易次数
//              NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
//              [dic setObject:self.walletModel.address forKey:@"address"];
//
//              [PPNetworkHelper POST:@"extend/getTransactionCount" parameters:dic hudString:nil success:^(id responseObject)
//               {
//                   // nonce 参数
//                   if (![NSString isNulllWithObject:[responseObject objectForKey:@"count"]])
//                   {
//                       self.nonce = [responseObject objectForKey:@"count"];
//                   }
//
//                   dispatch_queue_t mainQueue = dispatch_get_main_queue();
//                   //异步返回主线程，根据获取的数据，更新UI
//                   dispatch_async(mainQueue, ^
//                  {
//                      [LCProgressHUD hide];
//                  });
//                   //初始化钱包订单页面
//                   self.commitOrderView.orderLB.text = self.icoModel.title;
//                   self.commitOrderView.transferAddressLB.text = self.icoModel.address;
//                   self.commitOrderView.addressLB.text = self.walletModel.address;
//
//                   if (self.walletModel.isLookWallet)
//                   {
//                       //观察钱包
//                       [self.view addSubview:self.commitOrderView];
//
//                       [UIView animateWithDuration:0.3 animations:^{
//                           self.commitOrderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
//                       } completion:^(BOOL finished){
//
//                       }];
//                   }
//                   else
//                   {
//                       //普通钱包
//                       [self.view addSubview:self.commitOrderView];
//
//                       [UIView animateWithDuration:0.3 animations:^{
//                           self.commitOrderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
//                       } completion:^(BOOL finished){
//
//                       }];
//
//                   }
//               } failure:^(NSString *error)
//               {
//                   [LCProgressHUD showFailure:error];
//                   dispatch_queue_t mainQueue = dispatch_get_main_queue();
//                   //异步返回主线程，根据获取的数据，更新UI
//                   dispatch_async(mainQueue, ^
//                                  {
//                                      [LCProgressHUD hide];
//                                  });
//               }];
//
//          } failure:^(NSString *error)
//          {
//              [LCProgressHUD showFailure:error];
//              dispatch_queue_t mainQueue = dispatch_get_main_queue();
//              //异步返回主线程，根据获取的数据，更新UI
//              dispatch_async(mainQueue, ^
//                             {
//                                 [LCProgressHUD hide];
//                             });
//          }];
//     } failure:^(NSString *error)
//     {
//         [LCProgressHUD showFailure:error];
//         dispatch_queue_t mainQueue = dispatch_get_main_queue();
//         //异步返回主线程，根据获取的数据，更新UI
//         dispatch_async(mainQueue, ^
//                        {
//                            [LCProgressHUD hide];
//                        });
//     }];

}

 - (void)cancelView
{
    //取消订单详情
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.commitOrderView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    } completion:^(BOOL finished){
        [weakSelf.commitOrderView removeFromSuperview];
    }];
}

- (void)comiitButtonCilickWithData:(id)data
{
//    //确定
//    
//    if (self.nonce.length == 0)
//    {
//        [LCProgressHUD showMessage:@"暂未获取到交易次数。请稍后再试"];
//        return;
//    }
//    //钱包余额判断   手续费 + 转账金额 <= ether钱包余额
//    if (self.commitOrderView.priceTF.text.length == 0)
//    {
//        [LCProgressHUD showMessage:@"请输入正确价格"];
//        return;
//    }
//    
//    NSComparisonResult result = [NSString DecimalFuncComparefirst:self.commitOrderView.priceTF.text secend:self.banlacePrice];
//    if (result == NSOrderedDescending)
//    {
//        [LCProgressHUD showMessage:@"钱包余额不足"];
//        return;
//    }
//    
//    ConfirmationTransferVC * vc = [[ConfirmationTransferVC alloc] init];
//    vc.totleGasPrice = self.totleGasPrice;
//    vc.gasprice = self.gasPrice;
//    vc.nonce = self.nonce;
//    vc.price = self.commitOrderView.priceTF.text;
//    vc.address = self.commitOrderView.transferAddressLB.text;
//    vc.remark = @"";
//    vc.model = self.walletModel;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            _isLoadFinish = YES;
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
        if (self.isLogin) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    NSLog(@"%@", NSStringFromClass([self class]));
    if (![_urlStr containsString:@"<"]) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
}

- (void)setIsHiddenRefresh:(BOOL)isHiddenRefresh {
    _isHiddenRefresh = isHiddenRefresh;
    
    if (_isHiddenRefresh) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (ChoseWalletView *)choseWalletView
{
    if (!_choseWalletView)
    {
        _choseWalletView = [[ChoseWalletView alloc] initWithFrame:[AppDelegate delegate].window.bounds];
        _choseWalletView.delegate = self;
    }
    return _choseWalletView;
}

- (CommitOrderView *)commitOrderView
{
    if (!_commitOrderView)
    {
        _commitOrderView = [[CommitOrderView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _commitOrderView.delegate = self;
    }
    return _commitOrderView;
}

- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
    NSLog(@"111---share");
    if (![NSObject isNulllWithObject:imageStr]) {
        
        UIImage *img = [UIImage imageNamed:imageStr];
        if (img == nil) {
            UIImageView *imgView = [[UIImageView alloc] init];
            
            imageStr = [imageStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *imgURL = [NSURL URLWithString:imageStr];
            
            if (![NSObject isNulllWithObject:imgURL]) {
                WEAKSELF
                [imgView sd_setImageWithURL:imgURL completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
                    weakSelf.shareIconImg = image;
                }];
            }
        } else {
            self.shareIconImg = img;
        }
    }
}

- (void)setShareIconImg:(UIImage *)shareIconImg {
    _shareIconImg = shareIconImg;
}

/**
 分享
 */
- (void)respondsToShareBarButtonItem {
//    [self activityOriginalShare];
    [self activityCustomShare];
}

- (void)activityCustomShare {
    [[UIApplication sharedApplication].keyWindow addSubview:self.sharedMenuView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sharedMenuView show];
    });
}

- (void)activityOriginalShare {
    NSString *sharedUrlStr = [NSString stringWithFormat:@"%@%ld", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD6 : TESTAPIEHEAD6, (NSInteger)[self.infomationId doubleValue]];
    
    NSMutableArray *items = [NSMutableArray array];
    if (self.title.length > 0) {
        [items addObject:self.title];
    }
    
    if (![NSObject isNulllWithObject:self.shareIconImg]) {
        [items addObject:self.shareIconImg];
    }
    
    NSURL *urlToShare = [NSURL URLWithString:sharedUrlStr];
    if (![NSObject isNulllWithObject:urlToShare]) {
        [items addObject:urlToShare];
    }
    
    NSArray *activityItems = items;
    
    CustomActivity *reservesActivity = [[CustomActivity alloc]initWithTitle:DBHGetStringWithKeyFromTable(@"Reserves", nil) ActivityImage:[UIImage imageNamed:@"fenxiang_shoucang"] URL:[NSURL URLWithString:@"Reserves"] ActivityType:@"Reserves"];
//    CustomActivity *lookProjectActivity = [[CustomActivity alloc]initWithTitle:DBHGetStringWithKeyFromTable(@"Look Project", nil) ActivityImage:[UIImage imageNamed:@"fenxiang_chakan"] URL:[NSURL URLWithString:@"Look Project"] ActivityType:@"Look Project"];
    
    CustomActivity *longImgShareActivity = [[CustomActivity alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Share Picture", nil) ActivityImage:[UIImage imageNamed:@"fenxiang_jietu1"] URL:[NSURL URLWithString:@"Share Picture"] ActivityType:@"Share Picture"];
    CustomActivity *twitterActivity = [[CustomActivity alloc]initWithTitle:@"Twitter" ActivityImage:[UIImage imageNamed:@"fenxiang_twitter"] URL:[NSURL URLWithString:@"Twitter"] ActivityType:@"Twitter"];
    
    NSArray *activityArray = @[reservesActivity, longImgShareActivity, twitterActivity];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activityArray];
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];
    //applicationActivities可以指定分享的应用，不指定为系统默认支持的
    
    kWeakSelf(activityVC)
    WEAKSELF
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if(completed)
        {
            if ([activityType isEqualToString:@"Reserves"]) {
                [weakSelf reserves];
            }
//            if ([activityType isEqualToString:@"Look Project"]) {
//                [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Coming soon", nil)];
//            }
            
            if ([activityType isEqualToString:@"Share Picture"]) {
                if (!weakSelf.captureImg) {
                    [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"Creating Photo...", nil)];
                    
                    [weakSelf.webView ZFJContentScrollCaptureCompletionHandler:^(UIImage *capturedImage) {
                        [LCProgressHUD hide];
                        weakSelf.captureImg = capturedImage;
                        [weakSelf pushToShareVC];
                    }];
                } else {
                    [weakSelf pushToShareVC];
                }
                
            }
            
            if ([activityType isEqualToString:@"Twitter"]) {
                [weakSelf shareToTwitter];
            }
            
            NSLog(@"Share success");
        } else {
            NSLog(@"Cancel the share");
        }
        [weakactivityVC dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - push vc
- (void)pushToShareVC {
    DBHSharePictureViewController *shareVC = [[DBHSharePictureViewController alloc] init];
    shareVC.longPictureImg = self.captureImg;
    DBHBaseNavigationController *navigationController = [[DBHBaseNavigationController alloc] initWithRootViewController:shareVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark ------ Data ------
- (void)shareToTwitter {
    NSString *urlStr = [self sharedUrlStr];
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:self.title];
    [composer setImage:self.shareIconImg];
    [composer setURL:[NSURL URLWithString:urlStr]];
    
    WEAKSELF
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        [weakSelf shareSuccess:result == TWTRComposerResultDone];
    }];
}

- (void)reserves {
    NSDictionary *paramters = @{@"enable":[NSNumber numberWithBool:true]};
    
    [PPNetworkHelper PUT:[NSString stringWithFormat:@"article/%@/collect", self.infomationId] baseUrlType:3 parameters:paramters hudString:nil success:^(id responseObject) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Reserves Success", nil)];
    } failure:^(NSString *error) {
        [LCProgressHUD showFailure:error];
    }];
}

- (LYShareMenuView *)sharedMenuView {
    if (!_sharedMenuView) {
        _sharedMenuView = [[LYShareMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _sharedMenuView.shareMenuItems = self.sharedMenuItems;
    }
    if (!_sharedMenuView.delegate) {
        _sharedMenuView.delegate = self;
    }
    return _sharedMenuView;
}

- (NSMutableArray *)sharedMenuItems {
    if (!_sharedMenuItems) {
        LYShareMenuItem *friendItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"friend_pr" itemTitle:DBHGetStringWithKeyFromTable(@"Moments", nil)];
        LYShareMenuItem *weixinItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"weixin_pr" itemTitle:DBHGetStringWithKeyFromTable(@"WeChat", nil)];
        LYShareMenuItem *qqItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"qq_pr" itemTitle:@"QQ"];
        LYShareMenuItem *telegramItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_telegram" itemTitle:@"Telegram"];
        
        LYShareMenuItem *reservesItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_shoucang" itemTitle:DBHGetStringWithKeyFromTable(@"Reserves", nil)];
//        LYShareMenuItem *lookProjectItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_chakan" itemTitle:DBHGetStringWithKeyFromTable(@"Look Project", nil)];
        LYShareMenuItem *longImgShareItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_jietu1" itemTitle:DBHGetStringWithKeyFromTable(@"Share Picture", nil)];
        LYShareMenuItem *twitterShareItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_twitter" itemTitle:@"Twitter"];
        
        _sharedMenuItems = [NSMutableArray arrayWithObjects:friendItem, weixinItem, qqItem, telegramItem, twitterShareItem, reservesItem, longImgShareItem, nil];
    }
    return _sharedMenuItems;
}

#pragma mark ----- Share Delegate ------
- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    switch (index) {
        case 0: {
             BOOL result = [WXApi sendReq:[self shareToWX:0]];
            NSLog(@"result = %d", result);
            break;
        }
        case 1: {
            BOOL result = [WXApi sendReq:[self shareToWX:1]];
            NSLog(@"result = %d", result);
            break;
        }
        case 2: { // qq
            [self shareToQQ];
            break;
        }
        case 3: { // tele
            [self shareToTelegram];
            break;
        }
        case 4: {
            [self shareToTwitter];
            break;
        }
            
        case 5: {
            [self reserves];
            break;
        }
//        case 5: {
//            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Coming soon", nil)];
//            break;
//        }
        case 6: {
            [self shareLongPicture];
            break;
        }
        default:
            break;
    }
}

- (NSString *)sharedUrlStr {
    return [NSString stringWithFormat:@"%@%ld", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD6 : TESTAPIEHEAD6, (NSInteger)[self.infomationId doubleValue]];
}

- (void)shareToTelegram {
    NSString *urlStr = [NSString stringWithFormat:@"https://t.me/share/url?text=%@&url=%@", self.title, [self sharedUrlStr]];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
    [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
        if (!success) {
            [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Uninstalled Telegram", nil)];
        }
    }];
}

- (void)shareLongPicture {
    if (!self.captureImg) {
        [LCProgressHUD showLoading:DBHGetStringWithKeyFromTable(@"Creating Photo...", nil)];
        
        WEAKSELF
        [self.webView ZFJContentScrollCaptureCompletionHandler:^(UIImage *capturedImage) {
            [LCProgressHUD hide];
            weakSelf.captureImg = capturedImage;
            [weakSelf pushToShareVC];
        }];
    } else {
        [self pushToShareVC];
    }
}

- (void)shareSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Share successfully", nil)];
    } else {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Share failed", nil)];
    }
}

- (void)shareToQQ {
    WEAKSELF
    [[AppDelegate delegate] setQqResultBlock:^(QQBaseResp *res) {
        if ([res isKindOfClass:[SendMessageToQQResp class]]) {
            if (res.type == ESENDMESSAGETOQQRESPTYPE) { // 手Q->第三方
                if ([res.result intValue] == 0) { // 没有错误
                    [weakSelf shareSuccess:YES];
                } else {
                    if (res.result.intValue == -4) { // 取消分享
                        [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Cancel share", nil)];
                    } else {
                        [weakSelf shareSuccess:NO];
                    }
                }
            }
        }
    }];
    
    UIImage *img = [UIImage imageWithImage:self.shareIconImg scaledToSize:CGSizeMake(100, 100)];
    NSData *data = UIImagePNGRepresentation(img);
    
    NSString *urlStr = [self sharedUrlStr];
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlStr] title:self.title description:urlStr previewImageData:data];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode send = [QQApiInterface sendReq:req];
    [self handleSendResult:send];
}

- (void)handleSendResult:(QQApiSendResultCode)code {
    switch (code) {
        case EQQAPIAPPNOTREGISTED: // 未注册
            NSLog(@"未注册");
            break;
        case EQQAPIQQNOTINSTALLED:
            [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Please install QQ mobile", nil)]; // todo
            break;
        case EQQAPISENDFAILD:
            [self shareSuccess:NO];
            break;
        default:
            break;
    }
}

/**
 发送消息到微信
 
 @param index 0-朋友圈  1-好友
 @return 消息
 */
- (SendMessageToWXReq *)shareToWX:(NSInteger)index {
    WEAKSELF
    [[AppDelegate delegate] setResultBlock:^(BaseResp *res) {
        if ([res isKindOfClass:[SendMessageToWXResp class]]) {
            if (res.errCode == 0) { // 没有错误
                [weakSelf shareSuccess:YES];
            } else {
                if (res.errCode == -2) {
                    // cancel
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Cancel share", nil)];
                } else {
                    [weakSelf shareSuccess:NO];
                }
            }
        }
    }];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;           // 指定为发送文本
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    
    WXWebpageObject *obj = [[WXWebpageObject alloc] init];
    obj.webpageUrl = [self sharedUrlStr];
    
    UIImage *img = [UIImage imageWithImage:self.shareIconImg scaledToSize:CGSizeMake(100, 100)];
    [message setThumbImage:img];
    message.mediaObject = obj;
    req.message = message;
    
    if (index == 0) {
        req.scene = WXSceneTimeline;
    } else {
        req.scene =  WXSceneSession;
    }
    return req;
}

//- (void)setIsHaveShare:(BOOL)isHaveShare {
//    _isHaveShare = isHaveShare;
//
//    if (!_isHaveShare) {
//        return;
//    }
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gonggaoxiangqing_gengduo"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToShareBarButtonItem)];
//}

@end
