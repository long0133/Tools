//
//  DBHSelectWalletTypeViewController.m
//  FBG
//
//  Created by yy on 2018/3/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSelectWalletTypeViewController.h"

#define ANIMATE_DURATION 0.25f
static NSString *const kDBHWalletManagerTableViewCellIdentifier = @"kDBHWalletManagerTableViewCellIdentifier";



@interface DBHSelectWalletTypeViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHSelectWalletTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    [self setUI];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShow = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShow animated:NO];
}

- (void)setUI {
    self.view.backgroundColor = COLORFROM16(0x000000, 0.4);
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.quitButton];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.tableView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
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
    DBHWalletManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHWalletManagerTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (self.type == NewWalletTypeAdd) {
        DBHSelectHotCodeWalletViewController *vc = [[DBHSelectHotCodeWalletViewController alloc] init];
        vc.walletType = (int)row + 1;
        vc.nc = self.nc;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.type == NewWalletTypeImport) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        if (row == 0) { // 导入NEO
            DBHImportWalletViewController *importWalletViewController = [[DBHImportWalletViewController alloc] init];
            [self.nc pushViewController:importWalletViewController animated:YES];
        } else { // 导入ETH
            DBHImportWalletWithETHViewController *importWalletWithETHViewController = [[DBHImportWalletWithETHViewController alloc] init];
            [self.nc pushViewController:importWalletWithETHViewController animated:YES];
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
        
        [_tableView registerClass:[DBHWalletManagerTableViewCell class] forCellReuseIdentifier:kDBHWalletManagerTableViewCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@"NEO"];
        [_dataSource addObject:@"ETH"];
    }
    return _dataSource;
}
@end
