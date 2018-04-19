//
//  CYLNestMainTableView.h
//  CYLAppBaseFrameWork
//
//  Created by yulin chi on 2018/4/19.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLNestMainTableViewDatasource.h"

@interface CYLNestMainTableView : UITableView
@property (nonatomic, strong) id<CYLNestMainTableViewDatasource> mainTableViewDatasource; /**<  */
@end
