//
//  DBHHomePageTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHHomePageTableViewCell.h"

#import "DBHWalletDetailTokenInfomationModelData.h"

@interface DBHHomePageTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *typeNameLabel;

@end

@implementation DBHHomePageTableViewCell

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
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeNameLabel];
    
    [self.contentView addSubview:self.numberLabel];
    
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(20));
        make.left.offset(AUTOLAYOUTSIZE(33));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.typeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(AUTOLAYOUTSIZE(5));
        make.centerY.equalTo(weakSelf.numberLabel);
    }];
    
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(33));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHWalletDetailTokenInfomationModelData *)model {
    _model = model;
    
    if ([_model.flag isEqualToString:@"NEO"] || [_model.flag isEqualToString:@"Gas"] || [_model.flag isEqualToString:@"ETH"]) {
        self.iconImageView.image = [UIImage imageNamed:_model.icon];
    } else {
        [self.iconImageView sdsetImageWithURL:_model.icon placeholderImage:[UIImage imageNamed:@"NEO_add"]];
    }
    self.nameLabel.text = _model.name;
    
    NSString *typeName = _model.typeName;
    if ([NSObject isNulllWithObject:typeName]) {
        typeName = @"";
    } else {
        typeName = [NSString stringWithFormat:@"(%@)", [typeName lowercaseString]];
    }
    self.typeNameLabel.text = typeName;
    self.numberLabel.text = [NSString stringWithFormat:@"%.4lf", _model.balance.doubleValue];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(14);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = FONT(13);
        _numberLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _numberLabel;
}

- (UILabel *)typeNameLabel {
    if (!_typeNameLabel) {
        _typeNameLabel = [[UILabel alloc] init];
        _typeNameLabel.font = FONT(10);
        _typeNameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _typeNameLabel;
}
@end
