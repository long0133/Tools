//
//  DBHSelectHotCodeWalletViewController.m
//  FBG
//
//  Created by yy on 2018/3/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSelectHotCodeWalletViewController.h"
#import "DBHAddWalletPromptViewTableViewCell.h"
#import "DBHCreateWalletViewController.h"
#import "DBHCreateWalletWithETHViewController.h"
#import "DBHShowAddWalletViewController.h"

#define ANIMATE_DURATION 0.5f
static NSString *const kDBHAddWalletPromptViewTableViewCellIdentifier = @"kDBHAddWalletPromptViewTableViewCellIdentifier";


@interface DBHSelectHotCodeWalletViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHSelectHotCodeWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    [self setUI];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShow = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShow animated:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.boxView]) {
        [self respondsToQuitButton];
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    self.view.backgroundColor = COLORFROM16(0x000000, 0.4);
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.quitButton];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.tableView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.bottom.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
    }];
    [self.quitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(44));
        make.left.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.titleLabel);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(15));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(27));
        make.bottom.equalTo(weakSelf.boxView);
    }];
}
#pragma mark ------ UITableViewDataSource ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBHAddWalletPromptViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHAddWalletPromptViewTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = DBHGetStringWithKeyFromTable(self.dataSource[indexPath.row], nil);
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    if (self.walletType == WalletTypeNEO) { // NEO 热钱包
        if (row == 0) {     // 热钱包
            DBHCreateWalletViewController *createWalletViewController = [[DBHCreateWalletViewController alloc] init];
            [self.nc pushViewController:createWalletViewController animated:YES];
        } else {    // 冷钱包
            [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)]; 
        }
    } else if (self.walletType == WalletTypeETH) { // ETH
        if (row == 0) { // 热钱包
            DBHCreateWalletWithETHViewController *createWalletWithETHViewController = [[DBHCreateWalletWithETHViewController alloc] init];
            [self.nc pushViewController:createWalletWithETHViewController animated:YES];
        } else { // 冷钱包
            [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Coming Soon", nil)];
        }
    }
}
#pragma mark ------ Event Responds ------
/**
 返回
 */
- (void)respondsToBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 退出
 */
- (void)respondsToQuitButton {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.bottom.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(373.5));
    }];
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf dismissPresentVC];
    }];
}

- (void)dismissPresentVC {
    UIViewController *vc = self.navigationController.viewControllers[0];
    if ([vc isKindOfClass:[DBHShowAddWalletViewController class]]) {
        [((DBHShowAddWalletViewController *)vc) animateShow:NO completion:^(BOOL isFinish) {
            [vc dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}

#pragma mark ------ Getters And Setters ------
- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = WHITE_COLOR;
    }
    return _boxView;
}
- (UIButton *)quitButton {
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitButton setImage:[UIImage imageNamed:@"返回-3"] forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(respondsToBackButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(18);
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"Select Wallet Type", nil);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = AUTOLAYOUTSIZE(60);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[DBHAddWalletPromptViewTableViewCell class] forCellReuseIdentifier:kDBHAddWalletPromptViewTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@"Hot Wallet"];
        [_dataSource addObject:@"Cold Wallet"];
    }
    return _dataSource;
}

@end
