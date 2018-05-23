//
//  YYSharePromptView.m
//  FBG
//
//  Created by yy on 2018/4/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYSharePromptView.h"
#import "LYShareMenuView.h"
#import "WXApi.h"
#import <TwitterKit/TWTRComposer.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "DBHSharePictureViewController.h"
#import "DBHBaseNavigationController.h"
#import "WKWebView+ZFJViewCapture.h"

@interface YYSharePromptView()<LYShareMenuViewDelegate, WXApiDelegate>

@property (nonatomic, strong) LYShareMenuView *sharedMenuView;
@property (nonatomic, strong) NSMutableArray *sharedMenuItems;
//@property (nonatomic, strong) UIImage *captureImg;

@end

@implementation YYSharePromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.sharedMenuView];
    }
    return self;
}

#pragma mark ---- push vc ------
- (void)pushToShareVC {
    DBHSharePictureViewController *shareVC = [[DBHSharePictureViewController alloc] init];
    DBHBaseNavigationController *navigationController = [[DBHBaseNavigationController alloc] initWithRootViewController:shareVC];
    [[self parentController] presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark ------- Private Method ---------
- (void)show {
    [self.sharedMenuView show];
}

- (void)shareToTwitter {
    NSString *urlStr = self.urlStr;
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setURL:[NSURL URLWithString:urlStr]];
    
    WEAKSELF
    [composer showFromViewController:[self parentController] completion:^(TWTRComposerResult result) {
        [weakSelf shareSuccess:result == TWTRComposerResultDone];
    }];
}

- (void)shareToTelegram {
    NSString *urlStr = [NSString stringWithFormat:@"https://t.me/share/url?text=%@&url=%@", @"", self.urlStr];
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
    [self pushToShareVC];
}

- (void)shareSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Share successfully", nil)];
    } else {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Share failed", nil)];
    }
}

/**
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
    
    NSData *imgData = UIImagePNGRepresentation(self.longPictureImg);
    CGSize imgSize = self.longPictureImg.size;
    UIImage *img = [UIImage imageWithImage:self.longPictureImg scaledToSize:CGSizeMake(imgSize.width, imgSize.height / 8)];
    NSData *previewImageData = UIImagePNGRepresentation(img);
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData previewImageData:previewImageData title:@"" description:@""];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode send = [QQApiInterface sendReq:req];
    [self handleSendResult:send];
}*/

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
/**
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
    
    WXImageObject *obj = [[WXImageObject alloc] init];
    
    NSData *imageData = UIImagePNGRepresentation(self.longPictureImg);
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
*/
#pragma mark ----- Share Delegate ------
- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            [self pushToShareVC];
            break;
        }
        case 1: {
           [self pushToShareVC];
            break;
        }
        case 2: { // qq
            [self pushToShareVC];
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
            [self shareLongPicture]; //YYTODO
            break;
        }
        default:
            break;
    }
}

#pragma mark ----- Setters And Getters ---------
- (LYShareMenuView *)sharedMenuView {
    if (!_sharedMenuView) {
        _sharedMenuView = [[LYShareMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _sharedMenuView.shareMenuItems = self.sharedMenuItems;
        
        WEAKSELF
        [_sharedMenuView setBlock:^{
            [weakSelf removeFromSuperview];
        }];
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
        LYShareMenuItem *longImgShareItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_jietu1" itemTitle:DBHGetStringWithKeyFromTable(@"Capture", nil)];
        LYShareMenuItem *twitterShareItem = [[LYShareMenuItem alloc] initShareMenuItemWithImageName:@"fenxiang_twitter" itemTitle:@"Twitter"];
        
        _sharedMenuItems = [NSMutableArray arrayWithObjects:friendItem, weixinItem, qqItem, telegramItem, twitterShareItem, longImgShareItem, nil];
    }
    return _sharedMenuItems;
}

@end
