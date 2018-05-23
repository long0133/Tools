//
//  CoustromViewController.h
//  11111
//
//  Created by mac on 16/8/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@class MJRefreshHeader, MJRefreshFooter;

@interface CoustromViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * coustromTableView;

// 上提刷新视图
@property (nonatomic) MJRefreshFooter *footRefreshView;

// 下拉刷新视图
@property (nonatomic) MJRefreshHeader *headRefreshView;

//注册下拉刷新功能，一般只用时第二个参数一律传NO
- (void)addpull2RefreshWithTableView:(UIScrollView *)tableView WithIsInset:(BOOL)isInset;

//注册上提加载，第二个参数同上
- (void)addPush2LoadMoreWithTableView:(UIScrollView *)tableView WithIsInset:(BOOL)isInset;

//下拉刷新回调
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView;

//上提加载回调
- (void)push2LoadMoreWithScrollerView:(UIScrollView *)scrollerView;

//结束刷新
- (void)endRefreshing;

@end
