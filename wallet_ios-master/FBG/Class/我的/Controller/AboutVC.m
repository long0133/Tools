//
//  AboutVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/29.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "AboutVC.h"
#import "KKWebView.h"

@interface AboutVC ()

@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"About Us", nil);
    self.version.text = [NSString stringWithFormat:@"%@%@", DBHGetStringWithKeyFromTable(@"Current version:", nil), [self currentVersion]];
    self.label1.text = DBHGetStringWithKeyFromTable(@"Service Policy", nil);
    self.label2.text = DBHGetStringWithKeyFromTable(@"Privacy Policy", nil);
    self.label3.text = DBHGetStringWithKeyFromTable(@"Open Source Agreement", nil);
    self.label4.text = DBHGetStringWithKeyFromTable(@"Development Team", nil);
    
    self.iconImg.layer.cornerRadius = 5;
    self.iconImg.layer.masksToBounds = YES;
}

- (NSString *)currentVersion {
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (IBAction)userRuleButtonCilick:(id)sender
{
    //用户协议
    [self pushWebViewWithUrl:@"EULA.html" title:@"用户协议"];
}

- (IBAction)useRuleButtonCilick:(id)sender
{
    //使用条款
    [self pushWebViewWithUrl:@"EULA.html" title:@"使用条款"];
}

- (IBAction)openRuleButtonCilick:(id)sender
{
    //开源协议
    [self pushWebViewWithUrl:@"OpenSource.html" title:@"开源协议"];
}

- (IBAction)openTeamButtonCilick:(id)sender
{
    //开发团队
    [self pushWebViewWithUrl:@"Team.html" title:@"开发团队"];
}

- (void)pushWebViewWithUrl:(NSString *)url title:(NSString *)title
{
    NSString * api;
    if ([APP_APIEHEAD isEqualToString:TESTAPIEHEAD1])
    {
        //测试
        api = TESTAPIEHEAD3;
    }
    else
    {
        //正式
        api = APIEHEAD3;
    }
    KKWebView * vc = [[KKWebView alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", [APP_APIEHEAD isEqualToString:APIEHEAD1] ? APIEHEAD3 : TESTAPIEHEAD3, url]];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
