//
//  CYLNestingView.m
//  CYLAppBaseFrameWork
//
//  Created by yulin chi on 2018/4/19.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLNestingView.h"
#import "CYLNestMainTableView.h"


@interface CYLNestingView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CYLNestMainTableView *mainTableView; /**< main table view */
@end

@implementation CYLNestingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - private
- (void)initUI{
    [self addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.subTableView;
}

#pragma mark - getter setter
- (CYLNestMainTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[CYLNestMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (CYLNestSubTableView *)subTableView{
    if (!_subTableView) {
        _subTableView = [[CYLNestSubTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _subTableView;
}


- (void)setMainDataSource:(id<CYLNestMainTableViewDatasource>)mainDataSource{
    _mainDataSource = mainDataSource;
    self.mainTableView.mainTableViewDatasource = mainDataSource;
}

@end
