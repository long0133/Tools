//
//  YYRedPacketShareViewController.m
//  FBG
//
//  Created by yy on 2018/4/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketShareViewController.h"

@interface YYRedPacketShareViewController ()

@end

@implementation YYRedPacketShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
