
//
//  DBHCandyBowlTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCandyBowlTableViewCell.h"

#import "DBHCandyBowlModelData.h"

@interface DBHCandyBowlTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIView *iconBackView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation DBHCandyBowlTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        self.isHideBottomLineView = YES;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
//    [self.contentView addSubview:self.iconBackView];
//    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.moreImageView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(64));
        make.height.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(10));
        make.center.equalTo(weakSelf.contentView);
    }];
//    [self.iconBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(AUTOLAYOUTSIZE(45));
//        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(12));
//        make.centerY.equalTo(weakSelf.boxView);
//    }];
//    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(AUTOLAYOUTSIZE(24));
//        make.center.equalTo(weakSelf.iconBackView);
//    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(12));
//        make.left.equalTo(weakSelf.iconBackView.mas_right).offset(AUTOLAYOUTSIZE(17.5));
        make.right.equalTo(weakSelf.moreImageView.mas_left).offset(- AUTOLAYOUTSIZE(45));
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(18));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(19.5));
    }];
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHCandyBowlModelData *)model {
    _model = model;
    
    [self.iconImageView sdsetImageWithURL:_model.img placeholderImage:nil];
    self.titleLabel.text = _model.name;
    self.contentLabel.text = _model.desc;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM16(0xFAFAFA, 1);
        _boxView.layer.cornerRadius = AUTOLAYOUTSIZE(7.5);
    }
    return _boxView;
}
- (UIView *)iconBackView {
    if (!_iconBackView) {
        _iconBackView = [[UIView alloc] init];
        _iconBackView.backgroundColor = COLORFROM16(0xF8F4F4, 1);
        _iconBackView.layer.cornerRadius = AUTOLAYOUTSIZE(5);
    }
    return _iconBackView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(14);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT(13);
        _contentLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _contentLabel;
}
- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _moreImageView;
}

@end
