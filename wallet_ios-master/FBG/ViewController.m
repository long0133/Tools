//
//  ViewController.m
//  FBG
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ViewController.h"
#import "DBHSelectScrollView.h"

#define kCollectionViewHeight 54

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor backgroudColor];
    
    [self test];
    
}

- (void)test {
    DBHSelectScrollView *select = [[DBHSelectScrollView alloc] initWithTitles:[NSMutableArray arrayWithObjects:@" Market Cap", @" Exchange", @"Dapp", @"InWe Project Ranking", @"项目资产", nil] currentSelectedIndex:2];
    [self.view addSubview:select];
    WEAKSELF
    [select mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(STATUSBARHEIGHT + 44));
        make.height.offset(AUTOLAYOUTSIZE(kCollectionViewHeight));
    }];
}

- (void)buttonClicked
{
    [LCProgressHUD showLoading:@"哈哈哈哈"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
