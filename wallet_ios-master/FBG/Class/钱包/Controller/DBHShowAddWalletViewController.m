//
//  DBHShowAddWalletViewController.m
//  FBG
//
//  Created by yy on 2018/3/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHShowAddWalletViewController.h"

#import "DBHAddWalletPromptViewTableViewCell.h"
#import "DBHSelectWalletTypeViewController.h"
#import "DBHSelectHotCodeWalletViewController.h"

#define ANIMATE_DURATION 0.25f
static NSString *const kDBHAddWalletPromptViewTableViewCellIdentifier = @"kDBHAddWalletPromptViewTableViewCellIdentifier";

@interface DBHShowAddWalletViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHShowAddWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    [self setUI];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShow = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShow animated:NO];
}

- (void)animateShow:(BOOL)isShow completion:(void (^)(BOOL isFinish))completion {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf.view);
        if (isShow) {
            make.bottom.equalTo(weakSelf.view);
        } else {
            make.bottom.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(373.5));
        }
    }];
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:completion];
}

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
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(373.5));
    }];
    
    [self.quitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(44));
        make.top.right.equalTo(weakSelf.boxView);
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.boxView]) {
        [self respondsToQuitButton];
    }
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
    switch (self.type) {
        case WalletTypeNEO: {
            if (row == 0) { // 添加NEO
                DBHSelectHotCodeWalletViewController *vc = [[DBHSelectHotCodeWalletViewController alloc] init];
                vc.walletType = self.type;
                vc.nc = self.nc;
                [self.navigationController pushViewController:vc animated:YES];
            } else { // 导入NEO
                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                DBHImportWalletViewController *importWalletViewController = [[DBHImportWalletViewController alloc] init];
                [self.nc pushViewController:importWalletViewController animated:YES];
            }
        }
            
            break;
            
        case WalletTypeETH: {
            if (row == 0) { // 添加ETH
                DBHSelectHotCodeWalletViewController *vc = [[DBHSelectHotCodeWalletViewController alloc] init];
                vc.walletType = self.type;
                vc.nc = self.nc;
                [self.navigationController pushViewController:vc animated:YES];
            } else { // 导入ETH
                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                DBHImportWalletWithETHViewController *importWalletWithETHViewController = [[DBHImportWalletWithETHViewController alloc] init];
                [self.nc pushViewController:importWalletWithETHViewController animated:YES];
            }
        }
            
            break;
            
        default: { // 未知类型
            DBHSelectWalletTypeViewController *selectVC = [[DBHSelectWalletTypeViewController alloc] init];
            selectVC.type = (int)indexPath.row;
            selectVC.nc = self.nc;
            [self.navigationController pushViewController:selectVC animated:YES];
        }
            
            break;
    }
   
    
    //    [self respondsToQuitButton];
//    [self boxViewAtLeft];
//    self.alpha = 0.0f;
//    WEAKSELF
//    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
//        [weakSelf layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        [weakSelf removeFromSuperview];
//    }];
//
//    self.selectedBlock(indexPath.row);
}

#pragma mark ------ Event Responds ------
/**
 退出
 */
- (void)respondsToQuitButton {
    [self animateShow:NO completion:^(BOOL isFinish) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }];
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
        [_quitButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(respondsToQuitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(18);
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"Add Wallets", nil);
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
        [_dataSource addObject:@"Add New Wallet"];
        [_dataSource addObject:@"Import Wallet"];
    }
    return _dataSource;
}

@end
