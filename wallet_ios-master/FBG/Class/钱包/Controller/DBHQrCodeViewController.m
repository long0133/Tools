//
//  DBHQrCodeViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHQrCodeViewController.h"
#import "WXApi.h"
#import "LYShareMenuView.h"

#import <TencentOpenAPI/QQApiInterface.h>

@interface DBHQrCodeViewController ()<LYShareMenuViewDelegate>

@property (nonatomic, strong) UIImageView *backGroundImageView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) LYShareMenuView *sharedMenuView;

@end

@implementation DBHQrCodeViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Wallet Address", nil);
    
    [self setUI];
    [self createQrCodeImage];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLORFROM16(0xFFFFFF, 1)}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLORFROM16(0xFFFFFF, 1)}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLORFROM16(0x333333, 1)}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    if (_sharedMenuView.delegate) {
        _sharedMenuView.delegate = nil;
    }

}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"分享-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToShareBarButtonItem)];
    
    [self.view addSubview:self.backGroundImageView];
    [self.view addSubview:self.boxView];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.qrCodeImageView];
    [self.view addSubview:self.addressLabel];
    
    WEAKSELF
    [self.backGroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(40));
        make.height.equalTo(weakSelf.boxView.mas_width).offset(AUTOLAYOUTSIZE(60));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(104) + STATUS_HEIGHT + 44);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(70));
        make.centerX.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.boxView.mas_top);
    }];
    [self.qrCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(weakSelf.boxView.mas_width).offset(- AUTOLAYOUTSIZE(54));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(50));
    }];
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.qrCodeImageView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ Event Responds ------
/**
 分享
 */
- (void)respondsToShareBarButtonItem {
    [self activityCustomShare];
//    [self activityOriginalShare];
}

- (void)activityOriginalShare {
    NSArray* activityItems = [[NSArray alloc] initWithObjects:self.walletModel.address, nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //applicationActivities可以指定分享的应用，不指定为系统默认支持的
    
    kWeakSelf(activityVC)
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError)
    {
        if(completed)
        {
            NSLog(@"Share success");
        }
        else
        {
            NSLog(@"Cancel the share");
        }
        [weakactivityVC dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}
/**
 长按地址复制
 */
- (void)respondsToAddressLabel {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.walletModel.address;
    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Copy success, you can send it to friends", nil)];
}

- (void)activityCustomShare {
    [[UIApplication sharedApplication].keyWindow addSubview:self.sharedMenuView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sharedMenuView show];
    });
}

- (LYShareMenuView *)sharedMenuView {
    if (!_sharedMenuView) {
        _sharedMenuView = [[LYShareMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        LYShareMenuItem *friendItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"friend_pr" itemTitle:DBHGetStringWithKeyFromTable(@"Moments", nil)];
        LYShareMenuItem *weixinItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"weixin_pr" itemTitle:DBHGetStringWithKeyFromTable(@"WeChat", nil)];
        LYShareMenuItem *qqItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"qq_pr" itemTitle:@"QQ"];
        
        _sharedMenuView.shareMenuItems = [NSMutableArray arrayWithObjects:friendItem, weixinItem, qqItem, nil];
    }
    if (!_sharedMenuView.delegate) {
        _sharedMenuView.delegate = self;
    }
    return _sharedMenuView;
}

#pragma mark ----- Share Delegate ------
- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    switch (index) {
        case 2: { // QQ
            [self shareToQQ];
            break;
        }
        default: {
            [WXApi sendReq:[self shareToWX:index]];
            break;
        }
            
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
    
    QQApiTextObject *textObj = [QQApiTextObject objectWithText:self.walletModel.address];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:textObj];
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    WEAKSELF
    [appDelegate setResultBlock:^(BaseResp *res) {
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
    req.bText = YES;           // 指定为发送文本
    req.text = self.walletModel.address;
    
    if (index == 0) {
        req.scene = WXSceneTimeline;
    } else {
        req.scene =  WXSceneSession;
    }
    return req;
}

#pragma mark ------ Private Methods ------
- (void)createQrCodeImage
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    
    NSData *data = [self.walletModel.address dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    self.qrCodeImageView.image = [self creatNonInterpolatedUIImageFormCIImage:outputImage withSize:SCREENWIDTH - AUTOLAYOUTSIZE(182)];
}
- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark ------ Getters And Setters ------
- (void)setWalletModel:(DBHWalletManagerForNeoModelList *)walletModel {
    _walletModel = walletModel;
    
    self.backGroundImageView.image = [UIImage imageNamed:_walletModel.category.categoryIdentifier == 1 ? @"Rectangle 4" : @"Rectangle 2"];
    self.iconImageView.image = [UIImage imageNamed:_walletModel.category.categoryIdentifier == 1 ? @"qianbaoxiangqing_yuan" : @"Group 21"];
}

- (UIImageView *)backGroundImageView {
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc] init];
    }
    return _backGroundImageView;
}
- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = WHITE_COLOR;
    }
    return _boxView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UIImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
    }
    return _qrCodeImageView;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT(13);
        _addressLabel.textColor = COLORFROM16(0x3D3D3D, 1);
        _addressLabel.text = self.walletModel.address;
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAddressLabel)];
        [_addressLabel addGestureRecognizer:longPressGR];
    }
    return _addressLabel;
}

@end
