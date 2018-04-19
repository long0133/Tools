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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [CYLNetWorkManager GET:<#(NSString *)#> parameter:<#(id)#> success:<#^(CYLResponse *response)successBlock#> fail:<#^(NSError *error)failBlock#>]
}

@end
