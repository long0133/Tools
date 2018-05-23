//
//  DBHWalletManageListTableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletManageListTableViewCell.h"


@interface DBHWalletManageListTableViewCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation DBHWalletManageListTableViewCell


#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.bottomLineWidth = SCREENWIDTH - AUTOLAYOUTSIZE(50);
        self.isHideBottomLineView = YES;
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.bgImageView];
    [self.bgView addSubview:self.iconImageView];
    
    [self.bgView addSubview:self.boxView];
    [self.boxView addSubview:self.addressLabel];
    [self.boxView addSubview:self.nameLabel];
    
    WEAKSELF
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(AUTOLAYOUTSIZE(2));
        make.left.offset(AUTOLAYOUTSIZE(20));
        make.center.equalTo(weakSelf.contentView);
        make.height.equalTo(weakSelf.contentView).offset(-AUTOLAYOUTSIZE(4));
    }];
    
    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.bgView);
        make.center.equalTo(weakSelf.bgView);
    }];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(44));
        make.left.offset(AUTOLAYOUTSIZE(12));
        make.centerY.equalTo(weakSelf.bgView);
    }];
    
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImageView);
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.height.equalTo(weakSelf.iconImageView).offset(AUTOLAYOUTSIZE(-6));
        make.right.equalTo(weakSelf.bgView).offset(AUTOLAYOUTSIZE(10));
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(weakSelf.boxView);
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
//        make.right.equalTo(weakSelf.bgImageView).offset(-AUTOLAYOUTSIZE(10));
        make.bottom.equalTo(weakSelf.boxView);
    }];
    
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.nameLabel.text = _title;
    self.iconImageView.image = [UIImage imageNamed:_title];
}
- (void)setModel:(DBHWalletManagerForNeoModelList *)model {
    _model = model;
    
    self.nameLabel.text = _model.name;
    self.iconImageView.image = [UIImage imageNamed:_model.category.name];
    self.addressLabel.text = _model.address;
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
        _nameLabel.font = FONT(14);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle 8"]];
    }
    return _bgImageView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT(10);
        _addressLabel.textColor = COLORFROM16(0xB5B5B5, 1); // 0xC1BEBE
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _addressLabel;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
    }
    return _boxView;
}

@end
