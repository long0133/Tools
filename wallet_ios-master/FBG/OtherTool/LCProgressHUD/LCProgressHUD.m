//
//  Created by 刘超 on 15/4/14.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "LCProgressHUD.h"
#import "UIImage+GIF.h"

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    15.0f

@implementation LCProgressHUD

+ (instancetype)sharedHUD {
    static id hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(LCProgressHUDStatus)status text:(NSString *)text {

    LCProgressHUD *hud = [LCProgressHUD sharedHUD];
    [hud showAnimated:YES];
    [hud setShowNow:YES];
    hud.label.text = text;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor lightGrayColor];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    
    hud.label.numberOfLines = 0;
    [hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];

    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LCProgressHUD" ofType:@"bundle"];

    switch (status) {

        case LCProgressHUDStatusSuccess: {

            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"hud_success@2x.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];

            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            hud.label.font = [UIFont systemFontOfSize:13];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hide) userInfo:nil repeats:NO];
        }
            break;

        case LCProgressHUDStatusError: {

            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"hud_error@2x.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];

            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            hud.label.font = [UIFont systemFontOfSize:13];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hide) userInfo:nil repeats:NO];
        }
            break;

        case LCProgressHUDStatusWaitting: {

            hud.mode = MBProgressHUDModeIndeterminate;
//            hud.bezelView.color = [UIColor clearColor];
//            UIImageView *gifImageView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"C-_Users_U"]];
//            hud.customView = gifImageView;
        }
            break;

        case LCProgressHUDStatusInfo: {

            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"hud_info@2x.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];

            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            hud.label.font = [UIFont systemFontOfSize:13];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hide) userInfo:nil repeats:NO];
        }
            break;

        default:
            break;
    }
}

+ (void)showMessage:(NSString *)text {

    LCProgressHUD *hud = [LCProgressHUD sharedHUD];
    [hud showAnimated:YES];
    [hud setShowNow:YES];
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:11];
//    hud.label.textColor = [UIColor whiteColor];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor lightGrayColor];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];

    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

+ (void)showInfoMsg:(NSString *)text {

    [self showStatus:LCProgressHUDStatusInfo text:text];
}

+ (void)showFailure:(NSString *)text {

    [self showStatus:LCProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {

    [self showStatus:LCProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {

    [self showStatus:LCProgressHUDStatusWaitting text:text];
}

+ (void)hide {
    
    [[LCProgressHUD sharedHUD] setShowNow:NO];
    [[LCProgressHUD sharedHUD] hideAnimated:YES];
}

@end
