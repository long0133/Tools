//
//  ViewController.m
//  CYLWebViewContainer
//
//  Created by chinapex on 2018/4/12.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ViewController.h"
#import "CYLWebViewController.h"

CFAbsoluteTime startTime;
static NSInteger count = 0;
@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CYLWebViewController *webvc = [CYLWebViewController sharedInstance];
    if (count %2 == 0) {
        webvc.request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chinapex.com.cn"]];
    }else{
        webvc.request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mp.weixin.qq.com/s/evzDnTsHrAr2b9jcevwBzA"]];
    }
    count ++;
    [self.navigationController pushViewController:webvc animated:YES];
    startTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"startTime: %f",startTime);
}


@end
