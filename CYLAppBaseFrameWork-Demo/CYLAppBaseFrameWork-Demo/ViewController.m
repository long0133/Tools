//
//  ViewController.m
//  CYLAppBaseFrameWork-Demo
//
//  Created by yulin chi on 2018/4/19.
//  Copyright © 2018年 yulin chi. All rights reserved.
//

#import "ViewController.h"
#import <CYLAppBaseFrameWork/CYLAppBaseFrameWork.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CYLCountDownButton *btn = [[CYLCountDownButton alloc] initWithPeriod:10 beginCountBlock:^{
        NSLog(@"begin");
    } countToZeroBlock:^{
        NSLog(@"end");
    }];
    
    btn.frame = CGRectMake(200, 100, 50, 30);
    [btn setTitle:@"countDown" forState:UIControlStateNormal];;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:btn];
}

@end
