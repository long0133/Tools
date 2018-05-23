//
//  DBHProjectHomeTypeOneTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeTypeOneTableViewCell.h"

#import "DBHInformationDataModels.h"

@interface DBHProjectHomeTypeOneTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *projectOverviewButton;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UILabel *realTimeQuotesLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UIButton *realTimeQuotesButton;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UILabel *tradingMarketLabel;
@property (nonatomic, strong) UIImageView *tradingMarketImageView;
@property (nonatomic, strong) UIButton *tradingMarketButton;

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;

@end

@implementation DBHProjectHomeTypeOneTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLORFROM10(235, 235, 235, 1);
        self.isHideBottomLineView = YES;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.projectOverviewButton];
    [self.contentView addSubview:self.firstLineView];
    [self.contentView addSubview:self.realTimeQuotesLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.changeLabel];
    [self.contentView addSubview:self.realTimeQuotesButton];
    [self.contentView addSubview:self.secondLineView];
    [self.contentView addSubview:self.tradingMarketLabel];
    [self.contentView addSubview:self.tradingMarketImageView];
    [self.contentView addSubview:self.tradingMarketButton];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(24));
        make.left.equalTo(weakSelf.firstLineView);
        make.centerY.equalTo(weakSelf.nameLabel);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(8));
        make.bottom.equalTo(weakSelf.contentLabel.mas_top).offset(- AUTOLAYOUTSIZE(4.5));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.bottom.equalTo(weakSelf.projectOverviewButton).offset(- AUTOLAYOUTSIZE(7.5));
    }];
    [self.projectOverviewButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(65));
        make.centerX.top.equalTo(weakSelf.boxView);
    }];
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.secondLineView);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.projectOverviewButton.mas_bottom);
    }];
    [self.realTimeQuotesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(18));
        make.top.equalTo(weakSelf.firstLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.secondLineView.mas_top);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(17));
        make.top.equalTo(weakSelf.firstLineView).offset(AUTOLAYOUTSIZE(14));
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.priceLabel);
        make.top.equalTo(weakSelf.priceLabel.mas_bottom);
    }];
    [self.realTimeQuotesButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.firstLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.secondLineView.mas_top);
    }];
    [self.secondLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(36));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.firstLineView.mas_bottom).offset(AUTOLAYOUTSIZE(60));
    }];
    [self.tradingMarketLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.realTimeQuotesLabel);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
    [self.tradingMarketImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(34.5));
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(17));
        make.centerY.equalTo(weakSelf.tradingMarketLabel);
    }];
    [self.tradingMarketButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.secondLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ Event Responds ------
/**
 项目全览
 */
- (void)respondsToProjectOverviewButton {
    self.clickButtonBlock(0);
}
/**
 实时行情
 */
- (void)respondsToRealTimeQuotesButton {
    self.clickButtonBlock(1);
}
/**
 交易市场
 */
- (void)respondsToTradingMarketButton {
    self.clickButtonBlock(2);
}

#pragma mark ------ Public Methods ------
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock {
    self.clickButtonBlock = clickButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectModel:(DBHInformationModelData *)projectModel {
    _projectModel = projectModel;
    
    [self.iconImageView sdsetImageWithURL:_projectModel.img placeholderImage:nil];
    
    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（%@）", _projectModel.unit, _projectModel.name]];
    [nameAttributedString addAttribute:NSFontAttributeName value:BOLDFONT(16) range:NSMakeRange(0, _projectModel.unit.length)];
    self.nameLabel.attributedText = nameAttributedString;
    
    self.contentLabel.text = _projectModel.industry;
    NSString *price = [UserSignData share].user.walletUnitType == 1 ? _projectModel.ico.priceCny : _projectModel.ico.priceUsd;
    self.priceLabel.text = [NSString stringWithFormat:@"%@%.2lf", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", price.doubleValue];
    self.changeLabel.text = [NSString stringWithFormat:@"%@%.2lf%%", _projectModel.ico.percentChange24h.doubleValue >= 0 ? @"+" : @"", _projectModel.ico.percentChange24h.doubleValue];
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIImageView alloc] init];
        _boxView.backgroundColor = WHITE_COLOR;
        _boxView.layer.cornerRadius = AUTOLAYOUTSIZE(5);
        _boxView.clipsToBounds = YES;
        _boxView.userInteractionEnabled = YES;
    }
    return _boxView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(13);
        _nameLabel.textColor = COLORFROM16(0x262626, 1);
    }
    return _nameLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT(11);
        _contentLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _contentLabel;
}
- (UIButton *)projectOverviewButton {
    if (!_projectOverviewButton) {
        _projectOverviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_projectOverviewButton addTarget:self action:@selector(respondsToProjectOverviewButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _projectOverviewButton;
}
- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = COLORFROM16(0xE4E4E4, 1);
    }
    return _firstLineView;
}
- (UILabel *)realTimeQuotesLabel {
    if (!_realTimeQuotesLabel) {
        _realTimeQuotesLabel = [[UILabel alloc] init];
        _realTimeQuotesLabel.font = FONT(13);
        _realTimeQuotesLabel.text = DBHGetStringWithKeyFromTable(@"Markets", nil);
        _realTimeQuotesLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _realTimeQuotesLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = BOLDFONT(15);
        _priceLabel.textColor = COLORFROM16(0xFF7624, 1);
    }
    return _priceLabel;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = FONT(10);
        _changeLabel.textColor = COLORFROM16(0xFF680F, 1);
    }
    return _changeLabel;
}
- (UIButton *)realTimeQuotesButton {
    if (!_realTimeQuotesButton) {
        _realTimeQuotesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_realTimeQuotesButton addTarget:self action:@selector(respondsToRealTimeQuotesButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _realTimeQuotesButton;
}
- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = COLORFROM16(0xD2D2D2, 1);
    }
    return _secondLineView;
}
- (UILabel *)tradingMarketLabel {
    if (!_tradingMarketLabel) {
        _tradingMarketLabel = [[UILabel alloc] init];
        _tradingMarketLabel.font = FONT(13);
        _tradingMarketLabel.text = DBHGetStringWithKeyFromTable(@"Exchanges", nil);
        _tradingMarketLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _tradingMarketLabel;
}
- (UIImageView *)tradingMarketImageView {
    if (!_tradingMarketImageView) {
        _tradingMarketImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_jiaoyishichang"]];
    }
    return _tradingMarketImageView;
}
- (UIButton *)tradingMarketButton {
    if (!_tradingMarketButton) {
        _tradingMarketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tradingMarketButton addTarget:self action:@selector(respondsToTradingMarketButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tradingMarketButton;
}

@end
