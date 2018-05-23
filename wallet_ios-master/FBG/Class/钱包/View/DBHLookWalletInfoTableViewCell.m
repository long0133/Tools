//
//  DBHLookWalletInfoTableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/14.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHLookWalletInfoTableViewCell.h"
#import "DBHInformationModelData.h"

@interface DBHLookWalletInfoTableViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *longNameLabel;

@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation DBHLookWalletInfoTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bottomLineWidth = SCREENWIDTH - AUTOLAYOUTSIZE(50);
        [self setUI];
    }
    return self;
}
#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.longNameLabel];
    [self.contentView addSubview:self.moreImageView];
    
    WEAKSELF
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.offset(- AUTOLAYOUTSIZE(25));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(20));
        make.left.offset(AUTOLAYOUTSIZE(25));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.longNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
        make.right.lessThanOrEqualTo(weakSelf.moreImageView.mas_left).offset(AUTOLAYOUTSIZE(-10));
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHInformationModelData *)model {
    _model = model;
    
    self.nameLabel.text = _model.name;
    
    if (![_model.img isKindOfClass:[NSString class]]) {
        return;
    }
    [self.iconImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageNamed:@"NEO_add"]];
    self.longNameLabel.text = [NSString stringWithFormat:@"(%@)", _model.longName];
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(13);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}

- (UILabel *)longNameLabel {
    if (!_longNameLabel) {
        _longNameLabel = [[UILabel alloc] init];
        _longNameLabel.font = FONT(13);
        _longNameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _longNameLabel;
}

- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _moreImageView;
}

@end

