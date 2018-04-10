//
//  ViewController.m
//  CYLReferesh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+Refresh.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentArr;;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentArr = [NSMutableArray arrayWithObjects:@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1, nil];
    [self.view addSubview:self.tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView addHeaderRefreshAction:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentArr = [NSMutableArray arrayWithObjects:@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1, nil];
            [self.tableView reloadData];
            [_tableView endHeaderRefresh];
        });
    }];
    
    [_tableView addFooterRfreshAction:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.contentArr addObjectsFromArray:@[@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1]];
            [self.tableView reloadData];
            [_tableView endFooterRefresh];
        });
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"cell";
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
@end
