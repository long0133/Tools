//
//  CYLNestingView.h
//  CYLAppBaseFrameWork
//
//  Created by yulin chi on 2018/4/19.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLNestMainTableViewDatasource.h"
#import "CYLNestSubTableView.h"

@interface CYLNestingView : UIView
@property (nonatomic, strong) CYLNestSubTableView *subTableView; /**< sub table view */

@property (nonatomic, strong) id<CYLNestMainTableViewDatasource> mainDataSource; /**< main tableview datasource */

@property (nonatomic, strong) id<UITableViewDataSource> subDataSource; /**< sub tableview datasource */
@property (nonatomic, strong) id<UITableViewDelegate> subDelegate; /**< sub tableview delegate */

@end
