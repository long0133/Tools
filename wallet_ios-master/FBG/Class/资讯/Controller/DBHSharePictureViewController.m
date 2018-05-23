//
//  DBHSharePictureViewController.m
//  FBG
//
//  Created by yy on 2018/3/14.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSharePictureViewController.h"
#import "WXApi.h"
#import <Social/Social.h>
#import "LYShareMenuView.h"
#import "DBHSharedItem.h"
#import "CustomActivity.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface DBHSharePictureViewController ()<UIScrollViewDelegate, WXApiDelegate, LYShareMenuViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UIImageView *centerImgView;
@property (nonatomic, strong) UIImageView *footImgView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *saveToLocalBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIImage *captureImg;

@property (nonatomic, strong) LYShareMenuView *sharedMenuView;

@end

@implementation DBHSharePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [self setUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_sharedMenuView.delegate) {
        _sharedMenuView.delegate = nil;
    }
}

- (void)setLongPictureImg:(UIImage *)longPictureImg {
    _longPictureImg = longPictureImg;
    
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.footImgView.frame));
}

- (void)setUI {
    self.view.backgroundColor = COLORFROM16(0XF6F6F6, 1);
    
    self.scrollView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:self.bottomView];
    
    WEAKSELF
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(AUTOLAYOUTSIZE(50)));
        make.bottom.width.centerX.equalTo(weakSelf.view);
    }];
    
    [self.bottomView addSubview:self.saveToLocalBtn];
    [self.saveToLocalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomView);
        make.top.centerY.equalTo(weakSelf.bottomView);
    }];
    
    [self.bottomView addSubview:self.lineView];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomView.mas_top).offset(AUTOLAYOUTSIZE(10));
        make.center.equalTo(weakSelf.bottomView);
        make.width.equalTo(@(AUTOLAYOUTSIZE(1)));
    }];
    
    [self.bottomView addSubview:self.shareBtn];
    [self.shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.saveToLocalBtn.mas_right);
        make.top.centerY.equalTo(weakSelf.bottomView);
        make.right.equalTo(weakSelf.bottomView);
        make.width.equalTo(weakSelf.saveToLocalBtn);
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.bottomView.mas_top).offset(-AUTOLAYOUTSIZE(10));
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.centerX.equalTo(weakSelf.scrollView);
    }];
    
    [self.contentView addSubview:self.headerImgView];
    [self.headerImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.centerX.equalTo(weakSelf.contentView);
        make.height.equalTo(@(AUTOLAYOUTSIZE(50)));
    }];
    
    [self.contentView addSubview:self.centerImgView];
    [self.centerImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerImgView.mas_bottom);
        make.width.centerX.equalTo(weakSelf.contentView);
        make.height.equalTo(@(weakSelf.longPictureImg.size.height));
    }];
    
    [self.contentView addSubview:self.footImgView];
    [self.footImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerImgView.mas_bottom);
        make.centerX.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(AUTOLAYOUTSIZE(0));
        make.height.equalTo(@(AUTOLAYOUTSIZE(200)));
        make.bottom.equalTo(weakSelf.contentView).offset(0);
    }];
}

#pragma mark - respondsToSelector
- (void)cancelClicked {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)respondsToSaveToLocalBtn {
    UIImage *img = self.captureImg;
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)respondsToShareBtn {
//    [self activityOriginalShare];
    [self activityCustomShare];
}

- (void)activityOriginalShare {
    CustomActivity *weixinActivity = [[CustomActivity alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"WeChat", nil) ActivityImage:[UIImage imageNamed:@"fenxiang_weixin"] URL:[NSURL URLWithString:@"WeChat"] ActivityType:@"WeChat"];
    
    CustomActivity *momentsActivity = [[CustomActivity alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Moments", nil) ActivityImage:[UIImage imageNamed:@"friend_pr"] URL:[NSURL URLWithString:@"Moments"] ActivityType:@"Moments"];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.captureImg]
                                                                             applicationActivities:@[weixinActivity, momentsActivity]];
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];
    kWeakSelf(activityVC)
    WEAKSELF
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if(completed) {
            if ([activityType isEqualToString:@"WeChat"]) {
                [WXApi sendReq:[weakSelf shareToWX:1]];
            } else if ([activityType isEqualToString:@"Moments"]) {
                [WXApi sendReq:[weakSelf shareToWX:0]];
            } else {
                [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Share successfully", nil)];
                [weakSelf cancelClicked];
            }
            NSLog(@"Share success");
        } else {
            NSLog(@"Cancel the share");
            [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Cancel share", nil)];
        }
        [weakactivityVC dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:activityVC animated:TRUE completion:nil];
    
}

- (void)activityCustomShare {
    [[UIApplication sharedApplication].keyWindow addSubview:self.sharedMenuView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sharedMenuView show];
    });
}

#pragma mark - 保存图片反馈
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Saved successfully", nil)];
        [self cancelClicked];
    } else {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Saved failed", nil)];
    }
}


#pragma mark - getter
- (UIImage *)captureImg {
    if (!_captureImg) {
        _captureImg = [self composeWithHeader:self.headerImgView content:self.centerImgView footer:self.footImgView];
    }
    return _captureImg;
}

- (UIImage *)footerImg {
    return [UIImage imageNamed:DBHGetStringWithKeyFromTable(@"xiazaiyemian_en", nil)];
}

- (UIImage *)headerImg {
    return [UIImage imageNamed:@"fenxiang_top"];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        
        _scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 3);
        // 关闭回弹
        _scrollView.bounces = NO;
        // 隐藏水平滚动条
        _scrollView.showsVerticalScrollIndicator = NO;
        // 设置代理
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = WHITE_COLOR;
    }
    return _contentView;
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] initWithImage:[self headerImg]];
    }
    return _headerImgView;
}

- (UIImageView *)centerImgView {
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc] initWithImage:self.longPictureImg];
        _centerImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _centerImgView;
}

- (UIImageView *)footImgView {
    if (!_footImgView) {
        _footImgView = [[UIImageView alloc] initWithImage:[self footerImg]];
        _footImgView.contentMode = UIViewContentModeScaleAspectFit;
        _footImgView.backgroundColor = WHITE_COLOR;
    }
    return _footImgView;
}

- (void)setFooterBgColor:(UIColor *)footerBgColor {
    _footerBgColor = footerBgColor;
    
    self.footImgView.backgroundColor = footerBgColor;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIButton *)saveToLocalBtn {
    if (!_saveToLocalBtn) {
        _saveToLocalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_saveToLocalBtn setTitle:DBHGetStringWithKeyFromTable(@"Save ", nil) forState:UIControlStateNormal];
        [_saveToLocalBtn addTarget:self action:@selector(respondsToSaveToLocalBtn) forControlEvents:UIControlEventTouchUpInside];
        _saveToLocalBtn.titleLabel.font = FONT(16);
        [_saveToLocalBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_saveToLocalBtn setBackgroundColor:WHITE_COLOR];
        
        [_saveToLocalBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [_saveToLocalBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        
        [_saveToLocalBtn setImage:[UIImage imageNamed:@"baocun_ico"] forState:UIControlStateNormal];
    }
    return _saveToLocalBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_shareBtn setTitle:DBHGetStringWithKeyFromTable(@"Share", nil) forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(respondsToShareBtn) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.titleLabel.font = FONT(16);
        [_shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_shareBtn setBackgroundColor:WHITE_COLOR];
        
        [_shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [_shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        
        [_shareBtn setImage:[UIImage imageNamed:@"fenxiang_ico"] forState:UIControlStateNormal];
        
    }
    return _shareBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORFROM16(0xEEEEEE, 1);
    }
    return _lineView;
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

        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
    
    NSData *imgData = UIImagePNGRepresentation(self.captureImg);
    CGSize imgSize = self.captureImg.size;
    UIImage *img = [UIImage imageWithImage:self.captureImg scaledToSize:CGSizeMake(imgSize.width, imgSize.height / 8)];
    NSData *previewImageData = UIImagePNGRepresentation(img);
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData previewImageData:previewImageData title:@"" description:@""];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
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
    req.bText = NO;           // 指定为发送文本
    
    WXImageObject *obj = [[WXImageObject alloc] init];
    
    NSData *imageData = UIImagePNGRepresentation(self.captureImg);
    obj.imageData = imageData;
    req.message = [[WXMediaMessage alloc] init];
    
    req.message.mediaObject = obj;
    
    if (index == 0) {
        req.scene = WXSceneTimeline;
    } else {
        req.scene =  WXSceneSession;
    }
    return req;
}

#pragma mark - capture 拼接图片成一张图片
- (UIImage *)composeWithHeader:(UIImageView *)headerImgView content:(UIImageView *)contentImgView footer:(UIImageView *)footerImgView {
    CGFloat value = AUTOLAYOUTSIZE(10);
    CGSize size = CGSizeMake(CGRectGetWidth(contentImgView.frame), CGRectGetMaxY(footerImgView.frame) + value);
    //UIGraphicsBeginImageContext(size);
    //第一个参数表示区域大小，第二个表示是否是非透明，NO半透明。第三个参数屏幕密度，决定像素的关键
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [headerImgView.image drawInRect:CGRectMake(CGRectGetMinX(headerImgView.frame), 0, CGRectGetWidth(headerImgView.frame), CGRectGetHeight(headerImgView.frame))];
    
    [contentImgView.image drawInRect:CGRectMake(CGRectGetMinX(contentImgView.frame), CGRectGetMaxY(headerImgView.frame), CGRectGetWidth(contentImgView.frame), CGRectGetHeight(contentImgView.frame))];
    
    footerImgView.layer.contentsGravity = kCAGravityResizeAspectFill;
    [footerImgView.image drawInRect:CGRectMake(CGRectGetMinX(footerImgView.frame), CGRectGetMaxY(contentImgView.frame), CGRectGetWidth(footerImgView.frame), CGRectGetHeight(footerImgView.frame) + value)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




@end



