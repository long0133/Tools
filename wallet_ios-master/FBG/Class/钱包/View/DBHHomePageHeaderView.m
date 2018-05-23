//
//  DBHHomePageHeaderView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHHomePageHeaderView.h"

@interface DBHHomePageHeaderView ()

@property (nonatomic, strong) UIImageView *backGroundImageView;
@property (nonatomic, strong) UIButton *messageIconButton;
@property (nonatomic, strong) UIButton *messageTitleButton;
@property (nonatomic, strong) UILabel *totalBalanceLabel;
@property (nonatomic, strong) UILabel *totalBalanceValueLabel;
@property (nonatomic, strong) UIButton *showTotalBalanceButton;

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;

@end

@implementation DBHHomePageHeaderView

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        self.clipsToBounds = YES;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.backGroundImageView];
    [self addSubview:self.messageIconButton];
    [self addSubview:self.messageTitleButton];
    [self addSubview:self.totalBalanceLabel];
    [self addSubview:self.totalBalanceValueLabel];
    [self addSubview:self.showTotalBalanceButton];
    [self addSubview:self.assetButton];
    
    WEAKSELF
    [self.backGroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
        make.center.equalTo(weakSelf);
    }];
    [self.messageIconButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(34));
        make.left.offset(AUTOLAYOUTSIZE(17));
        make.top.offset(AUTOLAYOUTSIZE(45));
    }];
    [self.messageTitleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(209));
        make.height.equalTo(weakSelf.messageIconButton);
        make.left.equalTo(weakSelf.messageIconButton.mas_right).offset(AUTOLAYOUTSIZE(4.5));
        make.centerY.equalTo(weakSelf.messageIconButton);
    }];
    [self.totalBalanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(30.5));
        make.bottom.equalTo(weakSelf.totalBalanceValueLabel.mas_top);
    }];
   
    [self.totalBalanceValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalBalanceLabel);
        make.bottom.equalTo(weakSelf.assetButton.mas_top).offset(- AUTOLAYOUTSIZE(22));
    }];
    
    [self.showTotalBalanceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(weakSelf.totalBalanceValueLabel.mas_right);
        make.width.offset(AUTOLAYOUTSIZE(41.5));
        make.height.offset(AUTOLAYOUTSIZE(33));
        make.right.offset(- AUTOLAYOUTSIZE(17.5));
        make.centerY.equalTo(weakSelf.totalBalanceValueLabel);
    }];
    
    [self.assetButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(52));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(15));
    }];
    
    [self.messageTitleButton setTitle:@"NEO即将推出NEON0.07版本，登陆官网哈哈哈哈" forState:UIControlStateNormal];
}

#pragma mark ------ Event Responds ------
/**
 资讯
 */
- (void)respondsToMessageButton {
    self.clickButtonBlock(0);
}
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
- (void)respondsToAssetButton {
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
- (UIImageView *)backGroundImageView {
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle"]];
    }
    return _backGroundImageView;
}
- (UIButton *)messageIconButton {
    if (!_messageIconButton) {
        _messageIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageIconButton.hidden = YES;
        [_messageIconButton setImage:[UIImage imageNamed:@"NEO"] forState:UIControlStateNormal];
        [_messageIconButton addTarget:self action:@selector(respondsToMessageButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageIconButton;
}
- (UIButton *)messageTitleButton {
    if (!_messageTitleButton) {
        _messageTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageTitleButton.hidden = YES;
        _messageTitleButton.titleLabel.font = FONT(11);
        _messageTitleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _messageTitleButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        [_messageTitleButton addTarget:self action:@selector(respondsToMessageButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageTitleButton;
}
- (UILabel *)totalBalanceLabel {
    if (!_totalBalanceLabel) {
        _totalBalanceLabel = [[UILabel alloc] init];
        _totalBalanceLabel.font = FONT(16);
        _totalBalanceLabel.text = DBHGetStringWithKeyFromTable(@"Total Balance", nil);
        _totalBalanceLabel.textColor = COLORFROM16(0x3A9E7C, 1);
    }
    return _totalBalanceLabel;
}
- (UILabel *)totalBalanceValueLabel {
    if (!_totalBalanceValueLabel) {
        _totalBalanceValueLabel = [[UILabel alloc] init];
        _totalBalanceValueLabel.font = BOLDFONT(35);
        _totalBalanceValueLabel.textColor = COLORFROM16(0xFFFFFF, 1);
        _totalBalanceValueLabel.adjustsFontSizeToFitWidth = YES;
//        _totalBalanceValueLabel.minimumScaleFactor = 0.6;
    }
    return _totalBalanceValueLabel;
}
- (UIButton *)showTotalBalanceButton {
    if (!_showTotalBalanceButton) {
        _showTotalBalanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showTotalBalanceButton setImage:[UIImage imageNamed:@"睁眼"] forState:UIControlStateNormal];
        [_showTotalBalanceButton setImage:[UIImage imageNamed:@"闭眼1"] forState:UIControlStateSelected];
        [_showTotalBalanceButton addTarget:self action:@selector(respondsToShowTotalBalanceButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showTotalBalanceButton;
}
- (UIButton *)assetButton {
    if (!_assetButton) {
        _assetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_assetButton setImage:[UIImage imageNamed:@"Group 4"] forState:UIControlStateNormal];
        [_assetButton addTarget:self action:@selector(respondsToAssetButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _assetButton;
}

@end
