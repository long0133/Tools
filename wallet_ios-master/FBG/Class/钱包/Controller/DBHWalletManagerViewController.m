//
//  DBHWalletManagerViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletManagerViewController.h"

#import "DBHCreateWalletViewController.h"
#import "DBHCreateWalletWithETHViewController.h"
#import "DBHWalletDetailViewController.h"
#import "DBHWalletDetailWithETHViewController.h"

#import "DBHAddWalletPromptView.h"
#import "DBHSelectWalletTypeOnePromptView.h"
#import "DBHSelectWalletTypeTwoPromptView.h"
#import "DBHImportWalletViewController.h"
#import "DBHImportWalletWithETHViewController.h"
#import "DBHWalletManageListTableViewCell.h"


#import "DBHShowAddWalletViewController.h"
#import "MyNavigationController.h"

static NSString *const kDBHWalletManageListTableViewCellIdentifier = @"kDBHWalletManageListTableViewCellIdentifier";

@interface DBHWalletManagerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBHAddWalletPromptView *addWalletPromptView;
@property (nonatomic, strong) DBHSelectWalletTypeOnePromptView *selectWalletTypeOnePromptView;
@property (nonatomic, strong) DBHSelectWalletTypeTwoPromptView *selectWalletTypeTwoPromptView;

@property (nonatomic, assign) NSInteger type; // 0:添加钱包 1:导入钱包
@property (nonatomic, assign) NSInteger walletType; // 0:NEO 1:ETH
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *grayLineView;

@property (nonatomic, strong) UIView *noWalletView;
@property (nonatomic, strong) UIImageView *noWalletImgView;
@property (nonatomic, strong) UILabel *noWalletTipLabel;

@end

@implementation DBHWalletManagerViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Wallet List", nil);
    
    [self setUI];
    
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
    [self getWalletList];
}

#pragma mark ------ UI ------
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@" Add ", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToAddWalletBarButtonItem)];
    //[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add Wallet"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToAddWalletBarButtonItem)];
    
    [self.view addSubview:self.grayLineView];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.noWalletView];
    [self.noWalletView addSubview:self.noWalletImgView];
    [self.noWalletView addSubview:self.noWalletTipLabel];
    
    WEAKSELF
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.tableView.mas_top).offset(-AUTOLAYOUTSIZE(9));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(AUTOLAYOUTSIZE(10));
        make.width.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    [self.noWalletView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.tableView);
        make.center.equalTo(weakSelf.tableView);
    }];
    
    [self.noWalletImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(88));
        make.top.offset(AUTOLAYOUTSIZE(5));
        make.centerX.equalTo(weakSelf.noWalletView);
    }];
    
    [self.noWalletTipLabel  mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.noWalletView).offset(- AUTOLAYOUTSIZE(30));
        make.top.equalTo(weakSelf.noWalletImgView.mas_bottom).offset(AUTOLAYOUTSIZE(5));
        make.centerX.equalTo(weakSelf.noWalletView);
    }];
    
    [self judgeIsShowGuide];
    
}

- (void)judgeIsShowGuide {
    BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:IS_SHOW_ADD_WALLET_GUIDE];
    if (!isShow) {
        [self addGuideView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_SHOW_ADD_WALLET_GUIDE];
    }
}

- (void)addGuideView {
    [self.view layoutIfNeeded];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    bgView.backgroundColor = COLORFROM16(0x323232, 0.8);
    
    UIImageView *circleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_wallet_guide_circle"]];
    CGFloat width = AUTOLAYOUTSIZE(76);
    circleImg.contentMode = UIViewContentModeScaleAspectFit;
    
    circleImg.frame = CGRectMake(CGRectGetWidth(frame) - width - AUTOLAYOUTSIZE(4), STATUSBARHEIGHT - AUTOLAYOUTSIZE(6), width, AUTOLAYOUTSIZE(60));
    circleImg.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:circleImg];
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_guide_arrow"]];
    
    arrowImg.contentMode = UIViewContentModeScaleAspectFit;
    
    arrowImg.frame = CGRectMake(CGRectGetMinX(circleImg.frame) - width / 2, CGRectGetMaxY(circleImg.frame) - 6, width, 30);
    [bgView addSubview:arrowImg];
    
    UIImageView *tipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DBHGetStringWithKeyFromTable(@"add_wallet_guide_tip_en", nil)]];
    
    tipImg.contentMode = UIViewContentModeScaleAspectFit;
    width = AUTOLAYOUTSIZE(180);
    tipImg.frame = CGRectMake(CGRectGetMidX(frame) - width / 4, CGRectGetMaxY(arrowImg.frame) + 6, width, 40);
    [bgView addSubview:tipImg];
    
    UIButton *iKownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    width = AUTOLAYOUTSIZE(100);
    
    CGRect btnFrame = iKownBtn.frame;
    btnFrame.origin.x = CGRectGetMidX(tipImg.frame) - width / 2;
    btnFrame.origin.y = CGRectGetMaxY(tipImg.frame) + 38;
    btnFrame.size.width = width;
    btnFrame.size.height = 36;
    
    iKownBtn.frame = btnFrame;
    
    iKownBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [iKownBtn setImage:[UIImage imageNamed:DBHGetStringWithKeyFromTable(@"info_guide_ikown_en", nil)] forState:UIControlStateNormal];
    [iKownBtn addTarget:self action:@selector(iKownClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:iKownBtn];
    [keyWindow addSubview:bgView];
}

- (void)iKownClicked:(UIButton *)btn {
    [btn.superview removeFromSuperview];
}

#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHWalletManageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHWalletManageListTableViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.model = self.dataSource[indexPath.row];
    }
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    
    DBHWalletManagerForNeoModelList *model = self.dataSource[indexPath.row];
    if (model.category.categoryIdentifier == 1) {
        // ETH
        DBHWalletDetailWithETHViewController *walletDetailWithETHViewController = [[DBHWalletDetailWithETHViewController alloc] init];
        walletDetailWithETHViewController.backIndex = 1;
        walletDetailWithETHViewController.ethWalletModel = model;
        [self.navigationController pushViewController:walletDetailWithETHViewController animated:YES];
    } else {
        // NEO
        DBHWalletDetailViewController *walletDetailViewController = [[DBHWalletDetailViewController alloc] init];
        walletDetailViewController.backIndex = 1;
        walletDetailViewController.neoWalletModel = model;
        [self.navigationController pushViewController:walletDetailViewController animated:YES];
    }
}

#pragma mark ------ Data ------
/**
 获取钱包列表
 */
- (void)getWalletList {
    WEAKSELF
    [PPNetworkHelper GET:@"wallet" baseUrlType:1 parameters:nil hudString:nil responseCache:^(id responseCache) {
        [weakSelf endRefresh];
        weakSelf.noWalletView.hidden = YES;
        [weakSelf.dataSource removeAllObjects];
        for (NSDictionary *dic in responseCache[LIST]) {
            DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dic];
            
            model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]];
            model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
            [weakSelf.dataSource addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.dataSource.count == 0) {
                weakSelf.noWalletView.hidden = NO;
            } else {
                [weakSelf.tableView reloadData];
            }
        });
    } success:^(id responseObject) {
        [weakSelf endRefresh];
        
        weakSelf.noWalletView.hidden = YES;
        [weakSelf.dataSource removeAllObjects];
        for (NSDictionary *dic in responseObject[LIST]) {
            DBHWalletManagerForNeoModelList *model = [DBHWalletManagerForNeoModelList mj_objectWithKeyValues:dic];
            
            model.isLookWallet = [NSString isNulllWithObject:[PDKeyChain load:KEYCHAIN_KEY(model.address)]];
            model.isBackUpMnemonnic = [[UserSignData share].user.walletIdsArray containsObject:@(model.listIdentifier)];
            [weakSelf.dataSource addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.dataSource.count == 0) {
                weakSelf.noWalletView.hidden = NO;
            } else {
                [weakSelf.tableView reloadData];
            }
        });
    } failure:^(NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf endRefresh];
            [LCProgressHUD showFailure: error];
        });
    } specialBlock:^{
        if (![UserSignData share].user.isLogin) {
            return;
        }
    }];
}

#pragma mark ------ Event Responds ------
/**
 添加钱包
 */
- (void)respondsToAddWalletBarButtonItem {
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
        return;
    }
    DBHShowAddWalletViewController *vc = [[DBHShowAddWalletViewController alloc] init];
    vc.nc = self.navigationController;

    MyNavigationController *naviVC = [[MyNavigationController alloc] initWithRootViewController:vc];
    naviVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:naviVC animated:NO completion:^{
        [vc animateShow:YES completion:nil];
    }];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.addWalletPromptView];
//
//    WEAKSELF
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakSelf.addWalletPromptView animationShow];
//    });
}

#pragma mark ------ Private Methods ------
/**
 添加刷新
 */
- (void)addRefresh {
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getWalletList];
    }];
}
/**
 结束刷新
 */
- (void)endRefresh {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark ------ Getters And Setters ------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(90);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHWalletManageListTableViewCell class] forCellReuseIdentifier:kDBHWalletManageListTableViewCellIdentifier];
    }
    return _tableView;
}
- (DBHAddWalletPromptView *)addWalletPromptView {
    if (!_addWalletPromptView) {
        _addWalletPromptView = [[DBHAddWalletPromptView alloc] init];
        
        WEAKSELF
        [_addWalletPromptView selectedBlock:^(NSInteger index) {
            if (!index) {
                // 添加新钱包
                weakSelf.type = 0;
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.selectWalletTypeOnePromptView];
                
                WEAKSELF
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.selectWalletTypeOnePromptView animationShow];
                });
            } else {
                // 导入钱包
                weakSelf.type = 1;
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.selectWalletTypeOnePromptView];
                
                WEAKSELF
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.selectWalletTypeOnePromptView animationShow];
                });
            }
        }];
    }
    return _addWalletPromptView;
}
- (DBHSelectWalletTypeOnePromptView *)selectWalletTypeOnePromptView {
    if (!_selectWalletTypeOnePromptView) {
        _selectWalletTypeOnePromptView = [[DBHSelectWalletTypeOnePromptView alloc] init];
        
        WEAKSELF
        [_selectWalletTypeOnePromptView selectedBlock:^(NSInteger index) {
            if (index == - 1) {
                // 返回
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.addWalletPromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.addWalletPromptView animateFromLeftShow]; //look
                });
            } else if (index == -2) {
                [weakSelf.addWalletPromptView boxViewAtInit];
            } else if (!index) {
                if (!weakSelf.type) {
                    // 添加NEO
                    weakSelf.walletType = 0;
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.selectWalletTypeTwoPromptView];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.selectWalletTypeTwoPromptView animationShow];
                    });
                } else {
                    [weakSelf.addWalletPromptView boxViewAtInit];
                    [weakSelf.selectWalletTypeOnePromptView boxViewAtInit];
                    // 导入NEO
                    DBHImportWalletViewController *importWalletViewController = [[DBHImportWalletViewController alloc] init];
                    [weakSelf.navigationController pushViewController:importWalletViewController animated:YES];
                }
            } else {
                if (!weakSelf.type) {
                    // 添加ETH
                    weakSelf.walletType = 1;
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.selectWalletTypeTwoPromptView];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.selectWalletTypeTwoPromptView animationShow];
                    });
                } else {
                    [weakSelf.addWalletPromptView boxViewAtInit];
                    [weakSelf.selectWalletTypeOnePromptView boxViewAtInit];
                    // 导入ETH
                    DBHImportWalletWithETHViewController *importWalletWithETHViewController = [[DBHImportWalletWithETHViewController alloc] init];
                    [weakSelf.navigationController pushViewController:importWalletWithETHViewController animated:YES];
                }
            }
        }];
    }
    return _selectWalletTypeOnePromptView;
}
- (DBHSelectWalletTypeTwoPromptView *)selectWalletTypeTwoPromptView {
    if (!_selectWalletTypeTwoPromptView) {
        _selectWalletTypeTwoPromptView = [[DBHSelectWalletTypeTwoPromptView alloc] init];
        
        WEAKSELF
        [_selectWalletTypeTwoPromptView selectedBlock:^(NSInteger index) {
            if (index == - 1) {
                // 返回
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.selectWalletTypeOnePromptView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.selectWalletTypeOnePromptView animateFromLeftShow];
                });
            } else if (index == -2) {
                [weakSelf.addWalletPromptView boxViewAtInit];
                [weakSelf.selectWalletTypeOnePromptView boxViewAtInit];
            } else {
                [weakSelf.addWalletPromptView boxViewAtInit];
                [weakSelf.selectWalletTypeOnePromptView boxViewAtInit];
                if (!index) {
                    // 热钱包
                    if (!self.walletType) {
                        // NEO
                        DBHCreateWalletViewController *createWalletViewController = [[DBHCreateWalletViewController alloc] init];
                        [weakSelf.navigationController pushViewController:createWalletViewController animated:YES];
                    } else {
                        // ETH
                        DBHCreateWalletWithETHViewController *createWalletWithETHViewController = [[DBHCreateWalletWithETHViewController alloc] init];
                        [weakSelf.navigationController pushViewController:createWalletWithETHViewController animated:YES];
                    }
                } else {
                    // 冷钱包
                    [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
                }
            }
        }];
    }
    return _selectWalletTypeTwoPromptView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)noWalletView {
    if (!_noWalletView) {
        _noWalletView = [[UIView alloc] init];
        _noWalletView.backgroundColor = WHITE_COLOR;
    }
    return _noWalletView;
}

- (UIImageView *)noWalletImgView {
    if (!_noWalletImgView) {
        _noWalletImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_wallet_tip"]];
        _noWalletImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noWalletImgView;
}

- (UILabel *)noWalletTipLabel {
    if (!_noWalletTipLabel) {
        _noWalletTipLabel = [[UILabel alloc] init];
        _noWalletTipLabel.numberOfLines = 0;
        _noWalletTipLabel.text = DBHGetStringWithKeyFromTable(@"No wallet, please go to 'Add Wallet' in the upper right corner to create wallet", nil);
        _noWalletTipLabel.font = FONT(12);
        _noWalletTipLabel.textColor = COLORFROM16(0xC1BEBE, 1);
        _noWalletTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noWalletTipLabel;
}

- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xEEEEEE, 1);
    }
    return _grayLineView;
}

@end
