//
//  YYRedPacketSuccessViewController.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSuccessViewController.h"
#import "YYRedPacketSucessTableViewCell.h"

#import "YYRedPacketDetailTableViewCell.h"
#import "YYRedPacketDetailHeaderView.h"

@interface YYRedPacketSuccessViewController ()

@end

@implementation YYRedPacketSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBarTitleColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

- (void)redPacketNavigationBar {
    NSArray *colors = @[COLORFROM16(0xD9725B, 1), COLORFROM16(0xC35542, 1)];
    UIImage *image = [UIImage imageWithGradients:colors];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Opened Success", nil);
    
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, -20, 0);
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > -scrollView.contentInset.top) {
        [self redPacketNavigationBar];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark ----- UITableView ---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return 2;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        YYRedPacketSucessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_SUCCESS_CELL_ID forIndexPath:indexPath];
        
        return cell;
    }
    
    YYRedPacketDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_DETAIL_CELL_ID forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return REDPACKET_SUCCESS_CELL_HEIGHT - 20 + STATUS_HEIGHT;
    }
    
    return REDPACKET_DETAIL_CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    YYRedPacketDetailHeaderView *headerView = [[YYRedPacketDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DETAIL_HEADERVIEW_HEIGHT)];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return DETAIL_HEADERVIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = COLORFROM16(0xFAFAFA, 1);
    return view;
}


@end
