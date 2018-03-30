//
//  ViewController.m
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/3/29.
//  Copyright © 2018年 chinapex. All rights reserved.
//

#import "ViewController.h"
#import "CYLNetWorkManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [CYLNetWorkManager GET:@"/api/order/reqtype" CachePolicy:CYLNetWorkCachePolicy_MemoryAndDisk activePeriod:60 parameter:@{} success:^(CYLResponse *response) {
        NSLog(@"success");
    } fail:^(NSError *error) {
        NSLog(@"fail");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
