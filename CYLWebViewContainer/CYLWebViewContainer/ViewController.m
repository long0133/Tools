//
//  ViewController.m
//  CYLWebViewContainer
//
//  Created by chinapex on 2018/4/12.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ViewController.h"
#import "CYLWebViewController.h"

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
    webvc.request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/d07298613f86"]];
    [self.navigationController pushViewController:webvc animated:YES];
}


@end
