//
//  DBHFunctionalUnitLookTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHFunctionalUnitLookTableViewCell.h"

@interface DBHFunctionalUnitLookTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *historicalInformationLabel;
@property (nonatomic, strong) UIImageView *secondMoreImageView;
@property (nonatomic, strong) UIButton *historicalInformationButton;
@property (nonatomic, strong) UIView *communityProjectBackView;
@property (nonatomic, strong) UILabel *communityProjectLabel;

@property (nonatomic, copy) ClickTypeButtonBlock clickTypeButtonBlock;
@property (nonatomic, copy) NSArray *menuArray; // 项目状态

@end

@implementation DBHFunctionalUnitLookTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.historicalInformationLabel];
    [self.contentView addSubview:self.secondMoreImageView];
    [self.contentView addSubview:self.historicalInformationButton];
    [self.contentView addSubview:self.communityProjectBackView];
    [self.contentView addSubview:self.communityProjectLabel];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(81.5));
        make.centerX.top.equalTo(weakSelf.contentView);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(45));
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(9.5));
        make.centerY.equalTo(weakSelf.iconImageView);
    }];
    [self.historicalInformationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView);
        make.centerY.equalTo(weakSelf.historicalInformationButton);
    }];
    [self.secondMoreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.historicalInformationLabel);
    }];
    [self.historicalInformationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(48.5));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.boxView.mas_bottom);
    }];
    [self.communityProjectBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.height.offset(AUTOLAYOUTSIZE(37));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.historicalInformationButton.mas_bottom);
    }];
    [self.communityProjectLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView);
        make.centerY.equalTo(weakSelf.communityProjectBackView);
    }];
}

#pragma mark ------ Event Responds ------
/**
 历史资讯
 */
- (void)respondsToHistoricalInformationButton {
    self.clickTypeButtonBlock();
}

#pragma mark ------ Public Methods ------
- (void)clickTypeButtonBlock:(ClickTypeButtonBlock)clickTypeButtonBlock {
    self.clickTypeButtonBlock = clickTypeButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.iconImageView.image = [UIImage imageNamed:_title];
    self.nameLabel.text = DBHGetStringWithKeyFromTable(_title, nil);
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
    }
    return _boxView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = BOLDFONT(14);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)historicalInformationLabel {
    if (!_historicalInformationLabel) {
        _historicalInformationLabel = [[UILabel alloc] init];
        _historicalInformationLabel.font = FONT(13);
        _historicalInformationLabel.text = DBHGetStringWithKeyFromTable(@"History", nil);
        _historicalInformationLabel.textColor = COLORFROM16(0x34A21F, 1);
    }
    return _historicalInformationLabel;
}
- (UIImageView *)secondMoreImageView {
    if (!_secondMoreImageView) {
        _secondMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _secondMoreImageView;
}
- (UIButton *)historicalInformationButton {
    if (!_historicalInformationButton) {
        _historicalInformationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_historicalInformationButton addTarget:self action:@selector(respondsToHistoricalInformationButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historicalInformationButton;
}
- (UIView *)communityProjectBackView {
    if (!_communityProjectBackView) {
        _communityProjectBackView = [[UIView alloc] init];
        _communityProjectBackView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
    }
    return _communityProjectBackView;
}
- (UILabel *)communityProjectLabel {
    if (!_communityProjectLabel) {
        _communityProjectLabel = [[UILabel alloc] init];
        _communityProjectLabel.font = FONT(13);
        _communityProjectLabel.text = DBHGetStringWithKeyFromTable(@"Community", nil);
        _communityProjectLabel.textColor = COLORFROM16(0x838383, 1);
    }
    return _communityProjectLabel;
}

@end
