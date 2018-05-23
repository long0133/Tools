//
//  DBHHomePageView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHHomePageView.h"

@interface DBHHomePageView ()

@property (nonatomic, strong) UILabel *totalBalanceLabel;
@property (nonatomic, strong) UILabel *totalBalanceValueLabel;
@property (nonatomic, strong) UIButton *showTotalBalanceButton;
@property (nonatomic, strong) UIImageView *assetImageView;

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;

@end

@implementation DBHHomePageView

#pragma mark ------ Lifecycle ------
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.totalBalanceLabel];
    [self addSubview:self.totalBalanceValueLabel];
    [self addSubview:self.showTotalBalanceButton];
    [self addSubview:self.assetImageView];
    
    WEAKSELF
    [self.totalBalanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(21));
        make.bottom.equalTo(weakSelf.totalBalanceValueLabel.mas_top).offset(- AUTOLAYOUTSIZE(3));
    }];
    [self.totalBalanceValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalBalanceLabel);
        make.bottom.offset(- AUTOLAYOUTSIZE(12));
    }];
    [self.showTotalBalanceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(41.5));
        make.height.offset(AUTOLAYOUTSIZE(33));
        make.left.equalTo(weakSelf.totalBalanceValueLabel.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.totalBalanceValueLabel);
    }];
    [self.assetImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(38));
        make.right.offset(- AUTOLAYOUTSIZE(17));
        make.bottom.offset(- AUTOLAYOUTSIZE(11.5));
    }];
}

#pragma mark ------ Event Responds ------
/**
 个人中心
 */
- (void)respondsToPersonalCenterImageView {
    self.clickButtonBlock(1);
}
/**
 显示/隐藏资产
 */
- (void)respondsToShowTotalBalanceButton {
    self.showTotalBalanceButton.selected = !self.showTotalBalanceButton.selected;
    UserModel *user = [UserSignData share].user;
    user.isHideAsset = self.showTotalBalanceButton.isSelected;
    
    [[UserSignData share] storageData:user];
    
    self.totalBalanceValueLabel.text = [NSString stringWithFormat:@"%@%@", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", [UserSignData share].user.isHideAsset ? @"****" : self.totalAsset];
    self.clickButtonBlock(3);
}
/**
 资产
 */
- (void)respondsToAssetImageView {
    self.clickButtonBlock(2);
}

#pragma mark ------ Public Methods ------
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock {
    self.clickButtonBlock = clickButtonBlock;
}
- (void)refreshAsset {
    self.showTotalBalanceButton.selected = [UserSignData share].user.isHideAsset;
    self.totalBalanceValueLabel.text = [NSString stringWithFormat:@"%@%@", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", [UserSignData share].user.isHideAsset ? @"****" : self.totalAsset];
}

#pragma mark ------ Getters And Setters ------
- (void)setTotalAsset:(NSString *)totalAsset {
    _totalAsset = totalAsset;
    
    self.showTotalBalanceButton.selected = [UserSignData share].user.isHideAsset;
    self.totalBalanceValueLabel.text = [NSString stringWithFormat:@"%@%@", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", [UserSignData share].user.isHideAsset ? @"****" : self.totalAsset];
}

- (UILabel *)totalBalanceLabel {
    if (!_totalBalanceLabel) {
        _totalBalanceLabel = [[UILabel alloc] init];
        _totalBalanceLabel.font = FONT(12);
        _totalBalanceLabel.text = DBHGetStringWithKeyFromTable(@"Total Balance", nil);
        _totalBalanceLabel.textColor = COLORFROM16(0x9D9F9E, 1);
    }
    return _totalBalanceLabel;
}
- (UILabel *)totalBalanceValueLabel {
    if (!_totalBalanceValueLabel) {
        _totalBalanceValueLabel = [[UILabel alloc] init];
        _totalBalanceValueLabel.font = BOLDFONT(17);
        _totalBalanceValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _totalBalanceValueLabel;
}
- (UIButton *)showTotalBalanceButton {
    if (!_showTotalBalanceButton) {
        _showTotalBalanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showTotalBalanceButton setImage:[UIImage imageNamed:@"睁眼1"] forState:UIControlStateNormal];
        [_showTotalBalanceButton setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateSelected];
        [_showTotalBalanceButton addTarget:self action:@selector(respondsToShowTotalBalanceButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showTotalBalanceButton;
}
- (UIImageView *)assetImageView {
    if (!_assetImageView) {
        _assetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 2"]];
        _assetImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAssetImageView)];
        [_assetImageView addGestureRecognizer:tapGR];
    }
    return _assetImageView;
}

@end
