//
//  DBHSelectWalletTypeOnePromptView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSelectWalletTypeOnePromptView.h"

#import "DBHWalletManagerTableViewCell.h"
#define ANIMATE_DURATION 0.5f
static NSString *const kDBHWalletManagerTableViewCellIdentifier = @"kDBHWalletManagerTableViewCellIdentifier";

@interface DBHSelectWalletTypeOnePromptView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) SelectedBlock selectedBlock;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DBHSelectWalletTypeOnePromptView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0x000000, 0.4);
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
        [self setUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.boxView]) {
        self.selectedBlock(-2);
        [self clickEmptyZone];
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.quitButton];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.tableView];
    
    WEAKSELF
    [self boxViewAtInit];
    [self.quitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(44));
        make.left.equalTo(weakSelf.boxView);
        make.centerY.equalTo(weakSelf.titleLabel);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf);
        make.width.equalTo(weakSelf);
        make.right.offset(0);
        make.left.offset(0);
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
    DBHWalletManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHWalletManagerTableViewCellIdentifier forIndexPath:indexPath];
    cell.title = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark ------ UITableViewDelegate ------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self respondsToQuitButton];
    [self boxViewAtLeft];
    
    self.alpha = 0.0f;
    WEAKSELF         
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
    self.selectedBlock(indexPath.row);
}

#pragma mark ------ Event Responds ------
/**
 返回
 */
- (void)respondsToBackButton {
//    [self respondsToQuitButton];
    
    [self boxViewAtRight];
    
    self.alpha = 0.0f;
    WEAKSELF
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    self.selectedBlock(-1);
}
/**
 退出
 */
- (void)respondsToQuitButton {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(373.5));
    }];
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)clickEmptyZone {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(373.5));
    }];
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf boxViewAtInit];
        [weakSelf removeFromSuperview];
    }];
}

- (void)boxViewAtCenter {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
    }];
}

- (void)boxViewAtRight {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_right);
    }];
}

- (void)boxViewAtLeft {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_left).offset(-AUTOLAYOUTSIZE(weakSelf.width));
    }];
}

- (void)boxViewAtInit {
    [self boxViewAtRight];
}

- (void)animateFromLeftShow {
    [self boxViewAtLeft];
    [self boxViewAtCenter];
    
    self.alpha = 1.0f;
    WEAKSELF
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

#pragma mark ------ Public Methods ------
/**
 动画显示
 */
- (void)animationShow {
    WEAKSELF
    [self boxViewAtRight];
    [self boxViewAtCenter];
    
    self.alpha = 1.0f;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [weakSelf layoutIfNeeded];
    }];
}
- (void)selectedBlock:(SelectedBlock)selectedBlock {
    self.selectedBlock = selectedBlock;
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

