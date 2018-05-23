//
//  YYRedPacketDetailViewController.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailViewController.h"
#import "YYRedPacketDetailHeaderView.h"
#import "YYRedPacketDetailTableViewCell.h"
#import "YYRedPacketDetailSpecialTableViewCell.h"
#import "YYRedPacketPackagingViewController.h"

@interface YYRedPacketDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YYRedPacketDetailModel *detailModel;

@end

@implementation YYRedPacketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self getDetailData];
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

#pragma mark ------- Data ---------
- (void)getDetailData {
    NSString *urlStr = [NSString stringWithFormat:@"redbag/send_record/%ld", self.model.redPacketId];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper GET:urlStr baseUrlType:3 parameters:nil hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            [weakSelf handleResponse:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Load failed", nil)];
        }];
    });
}

- (void)handleResponse:(id)responseObj {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        YYRedPacketDetailModel *model = [YYRedPacketDetailModel mj_objectWithKeyValues:responseObj];
        self.detailModel = model;
    }
}


#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"RedPacket Detail", nil);
    
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
    NSInteger count = 1;
    RedBagStatus status = self.detailModel.status;
    if (status == RedBagStatusCashPackaging || status == RedBagStatusCashPackageFailed) { // 礼金打包
        count = count + 1;
    } else if (status == RedBagStatusCreateFailed || status == RedBagStatusCreating) { // 红包创建
        count = count + 2;
    } else {
        count = count + 3;
    }
    
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 3:
            return self.detailModel.draw_redbag_number;
            break;
            
        default:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        YYRedPacketDetailSpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_DETAIL_SPECIAL_CELL_ID forIndexPath:indexPath];
        cell.model = self.detailModel;
        WEAKSELF
        [cell setBlock:^(RedBagStatus status) { // YYTODO
            switch (status) {
                case RedBagStatusCashPackaging:
                    [weakSelf pushToPackagingVC];
                    break;
                    
                default:
                    [weakSelf pushToPackagingVC];
                    break;
            }
        }];
        return cell;
    }

    NSInteger row = indexPath.row;
    YYRedPacketDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDPACKET_DETAIL_CELL_ID forIndexPath:indexPath];
    [cell setModel:self.detailModel section:section];
    if (section == 1 || section == 2) {
        cell.isLastCellInSection = YES;
    } else {
        if (row == self.detailModel.draw_redbag_number - 1) {
            cell.isLastCellInSection = YES;
        } else {
            cell.isLastCellInSection = NO;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return REDPACKET_DETAIL_SPECIAL_CELL_HEIGHT - 20 + STATUS_HEIGHT;
    }

    return REDPACKET_DETAIL_CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    YYRedPacketDetailHeaderView *headerView = [[YYRedPacketDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DETAIL_HEADERVIEW_HEIGHT)];
    
    NSString *titleStr = nil;
    if (section == 1) {
        titleStr = DBHGetStringWithKeyFromTable(@"Cash Package Detail Info", nil);
    } else if (section == 2) {
        titleStr = DBHGetStringWithKeyFromTable(@"Poundage Payment Detail Info", nil);
    } else if (section == 3) {
        titleStr = [NSString stringWithFormat:@"%@ %ld/%ld", DBHGetStringWithKeyFromTable(@"Opened Number", nil), self.detailModel.draw_redbag_number, self.detailModel.redbag_number];
    }
    headerView.headerTitle = titleStr;
    headerView.model = self.detailModel;
    headerView.showTotal = (section == 3);
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

#pragma mark ------- Push To VC ---------
- (void)pushToPackagingVC {
//    YYRedPacketPackagingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_PACKAGING_STORYBOARD_ID];
//    vc.packageType = PackageTypeCash;
//    vc.redbag_number = self.detailModel.redbag_number;
//    vc.redbag = self.detailModel.redbag;
//    vc.walletModel = self.currentWalletModel;
//    vc.tokenModel = self.tokenModel;
//    vc.poundage = self.detailModel.fee;
//    vc.ethWallet = self;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----- Setters And Getters ---------
- (void)setDetailModel:(YYRedPacketDetailModel *)detailModel {
    _detailModel = detailModel;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
