//
//  DBHSearchProjectTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSearchProjectTableViewCell.h"

#import "DBHInformationDataModels.h"

@interface DBHSearchProjectTableViewCell ()

@property (nonatomic, strong) UIView *iconBackView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation DBHSearchProjectTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.iconBackView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.tagLabel];
    
    WEAKSELF
    [self.iconBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(26));
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.iconBackView);
        make.center.equalTo(weakSelf.iconBackView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconBackView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.top.offset(AUTOLAYOUTSIZE(17));
    }];
    [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHInformationModelData *)model {
    _model = model;
    
    [self.iconImageView sdsetImageWithURL:_model.img placeholderImage:nil];
    
    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（%@）", _model.unit, _model.longName]];
    [nameAttributedString addAttributes:@{NSFontAttributeName:BOLDFONT(15)} range:NSMakeRange(0, _model.unit.length)];
    self.nameLabel.attributedText = nameAttributedString;
    self.tagLabel.text = _model.industry;
}

- (UIView *)iconBackView {
    if (!_iconBackView) {
        _iconBackView = [[UIView alloc] init];
        _iconBackView.backgroundColor = COLORFROM16(0xD8D8D8, 1);
    }
    return _iconBackView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconBackView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(7);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = FONT(10);
        _tagLabel.textColor = COLORFROM16(0x9B9B9B, 1);
    }
    return _tagLabel;
}

@end
