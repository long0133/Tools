//
//  CYLNestMainTableView.m
//  CYLAppBaseFrameWork
//
//  Created by yulin chi on 2018/4/19.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLNestMainTableView.h"

@implementation CYLNestMainTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self initUI];
    }
    return self;
}

#pragma mark - private
- (void)initUI{
    
}


#pragma mark - getter setter
- (void)setMainTableViewDatasource:(id<CYLNestMainTableViewDatasource>)mainTableViewDatasource{
    _mainTableViewDatasource = mainTableViewDatasource;
    
    /* set tableView header */
    if ([self.mainTableViewDatasource respondsToSelector:@selector(tableHeaderViewForTableView:)]) {
        UIView *v = [self.mainTableViewDatasource tableHeaderViewForTableView:self];
        self.tableHeaderView = v;
    }
}
@end
