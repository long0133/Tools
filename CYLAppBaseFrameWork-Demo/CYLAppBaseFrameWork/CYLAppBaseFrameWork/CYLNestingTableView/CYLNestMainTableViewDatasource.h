//
//  CYLNestMainTableViewDatasource.h
//  CYLAppBaseFrameWork
//
//  Created by yulin chi on 2018/4/19.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CYLNestMainTableViewDatasource <NSObject>
@required
- (UIView*)tableHeaderViewForTableView:(UITableView*)tableview;
@end
