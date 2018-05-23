//
//  DBHProjectHomeNoTradingTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeNoTradingTableViewCell.h"

#import "DBHInformationDataModels.h"

@interface DBHProjectHomeNoTradingTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DBHProjectHomeNoTradingTableViewCell

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
    [self.contentView addSubview:self.firstLineView];
    [self.contentView addSubview:self.titleLabel];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(24));
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(22));
        make.centerY.equalTo(weakSelf.nameLabel);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(8));
        make.bottom.equalTo(weakSelf.contentLabel.mas_top).offset(- AUTOLAYOUTSIZE(4.5));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.bottom.equalTo(weakSelf.firstLineView.mas_top).offset(- AUTOLAYOUTSIZE(7.5));
    }];
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(48));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(14));
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(14));
        make.top.equalTo(weakSelf.firstLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectModel:(DBHInformationModelData *)projectModel {
    _projectModel = projectModel;
    
    [self.iconImageView sdsetImageWithURL:_projectModel.img placeholderImage:nil];
    
    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（%@）", _projectModel.unit, _projectModel.name]];
    [nameAttributedString addAttribute:NSFontAttributeName value:BOLDFONT(16) range:NSMakeRange(0, _projectModel.unit.length)];
    self.nameLabel.attributedText = nameAttributedString;
    
    self.contentLabel.text = _projectModel.industry;
    self.titleLabel.text = _projectModel.desc;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIImageView alloc] init];
        _boxView.backgroundColor = WHITE_COLOR;
        _boxView.layer.cornerRadius = AUTOLAYOUTSIZE(5);
        _boxView.clipsToBounds = YES;
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
- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = COLORFROM16(0xE4E4E4, 1);
    }
    return _firstLineView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(14);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}

@end
