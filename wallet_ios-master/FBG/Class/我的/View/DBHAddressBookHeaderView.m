//
//  DBHAddressBookHeaderView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHAddressBookHeaderView.h"

@interface DBHAddressBookHeaderView ()

@property (nonatomic, strong) UIButton *ethButton;
@property (nonatomic, strong) UIButton *neoButton;
@property (nonatomic, strong) UIButton *btcButton;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, copy) SelectedTypeBlock selectedTypeBlock;

@end

@implementation DBHAddressBookHeaderView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.ethButton];
    [self addSubview:self.neoButton];
    [self addSubview:self.btcButton];
    [self addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.ethButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(45));
        make.height.equalTo(weakSelf);
        make.right.equalTo(weakSelf.neoButton.mas_left);
        make.centerY.equalTo(weakSelf.neoButton);
    }];
    [self.neoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.ethButton);
        make.center.equalTo(weakSelf);
    }];
    [self.btcButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.ethButton);
        make.centerY.equalTo(weakSelf.neoButton);
        make.left.equalTo(weakSelf.neoButton.mas_right);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(10));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.bottom.equalTo(weakSelf.ethButton).offset(- AUTOLAYOUTSIZE(18));
        make.centerX.equalTo(weakSelf.ethButton);
    }];
}

#pragma mark ------ Event Responds ------
/**
 选择类型
 */
- (void)respondsToTypeButton:(UIButton *)sender {
    self.selectedTypeBlock(sender.tag - 200);
    
    if (sender.tag - 200 == self.currentSelectedIndex) {
        return;
    }
    
    UIButton *lastSelectedButton = [self viewWithTag:self.currentSelectedIndex + 200];
    lastSelectedButton.selected = NO;
    
    sender.selected = YES;
    self.currentSelectedIndex = sender.tag - 200;
    
    WEAKSELF
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(10));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.bottom.equalTo(weakSelf.ethButton).offset(- AUTOLAYOUTSIZE(18));
        make.centerX.equalTo(sender);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

#pragma mark ------ Public Methods ------
/**
 选中类型
 */
- (void)selectedType:(NSInteger)type {
    if (type == self.currentSelectedIndex) {
        return;
    }
    
    UIButton *lastSelectedButton = [self viewWithTag:self.currentSelectedIndex + 200];
    lastSelectedButton.selected = NO;
    
    UIButton *currentSelectedButton = [self viewWithTag:type + 200];
    currentSelectedButton.selected = YES;
    self.currentSelectedIndex = type;
    
    WEAKSELF
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(10));
        make.height.offset(AUTOLAYOUTSIZE(1.5));
        make.bottom.equalTo(weakSelf.ethButton).offset(- AUTOLAYOUTSIZE(18));
        make.centerX.equalTo(currentSelectedButton);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}
- (void)selectedTypeBlock:(SelectedTypeBlock)selectedTypeBlock {
    self.selectedTypeBlock = selectedTypeBlock;
}

#pragma mark ------ Getters And Setters ------
- (UIButton *)ethButton {
    if (!_ethButton) {
        _ethButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ethButton.tag = 200;
        _ethButton.titleLabel.font = BOLDFONT(12);
        _ethButton.selected = YES;
        [_ethButton setTitle:@"ETH" forState:UIControlStateNormal];
        [_ethButton setTitleColor:COLORFROM16(0xD8D8D8, 1) forState:UIControlStateNormal];
        [_ethButton setTitleColor:COLORFROM16(0xFF6806, 1) forState:UIControlStateSelected];
        [_ethButton addTarget:self action:@selector(respondsToTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ethButton;
}
- (UIButton *)neoButton {
    if (!_neoButton) {
        _neoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _neoButton.tag = 201;
        _neoButton.titleLabel.font = BOLDFONT(12);
        [_neoButton setTitle:@"NEO" forState:UIControlStateNormal];
        [_neoButton setTitleColor:COLORFROM16(0xD8D8D8, 1) forState:UIControlStateNormal];
        [_neoButton setTitleColor:COLORFROM16(0xFF6806, 1) forState:UIControlStateSelected];
        [_neoButton addTarget:self action:@selector(respondsToTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _neoButton;
}
- (UIButton *)btcButton {
    if (!_btcButton) {
        _btcButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _btcButton.tag = 202;
        _btcButton.titleLabel.font = BOLDFONT(12);
        [_btcButton setTitle:@"BTC" forState:UIControlStateNormal];
        [_btcButton setTitleColor:COLORFROM16(0xD8D8D8, 1) forState:UIControlStateNormal];
        [_btcButton setTitleColor:COLORFROM16(0xFF6806, 1) forState:UIControlStateSelected];
        [_btcButton addTarget:self action:@selector(respondsToTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btcButton;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xFF6806, 1);
    }
    return _bottomLineView;
}

@end
