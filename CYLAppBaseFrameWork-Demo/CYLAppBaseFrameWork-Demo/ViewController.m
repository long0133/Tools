//
//  ViewController.m
//  CYLAppBaseFrameWork-Demo
//
//  Created by yulin chi on 2018/4/19.
//  Copyright © 2018年 yulin chi. All rights reserved.
//

#import "ViewController.h"
#import <CYLAppBaseFrameWork/CYLAppBaseFrameWork.h>


@interface ViewController ()<CYLNestMainTableViewDatasource, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) CYLNestingView *nestingView; /**<  */
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nestingView];
}

#pragma mark - delegate
- (UIView *)tableHeaderViewForTableView:(UITableView *)tableview{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
    v.backgroundColor = [UIColor redColor];
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"0001";
    return cell;
}


- (CYLNestingView *)nestingView{
    if (!_nestingView) {
        _nestingView = [[CYLNestingView alloc] initWithFrame:self.view.bounds];
        _nestingView.mainDataSource = self;
        
        _nestingView.subTableView.delegate = self;
        _nestingView.subTableView.dataSource = self;
        [_nestingView.subTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _nestingView;
}

@end
