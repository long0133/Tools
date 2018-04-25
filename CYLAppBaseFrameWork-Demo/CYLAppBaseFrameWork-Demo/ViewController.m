//
//  ViewController.m
//  CYLAppBaseFrameWork-Demo
//
//  Created by yulin chi on 2018/4/19.
//  Copyright © 2018年 yulin chi. All rights reserved.
//

#import "ViewController.h"
#import <CYLAppBaseFrameWork/CYLAppBaseFrameWork.h>
#import "Account.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Account *account = [Account randomMnemonicAccount];
    NSLog(@"%@",account);
}

@end
