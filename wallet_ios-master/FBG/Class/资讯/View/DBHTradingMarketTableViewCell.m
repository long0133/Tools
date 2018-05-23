//
//  DBHTradingMarketTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTradingMarketTableViewCell.h"

#import "DBHTradingMarketModelData.h"

@interface DBHTradingMarketTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *volumeLabel;

@end

@implementation DBHTradingMarketTableViewCell

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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.volumeLabel];
    
    WEAKSELF
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.top.offset(AUTOLAYOUTSIZE(19));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(17));
        make.centerY.equalTo(weakSelf.nameLabel);
    }];
    [self.volumeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(AUTOLAYOUTSIZE(5));
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHTradingMarketModelData *)model {
    _model = model;
    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)", _model.source, _model.pair]];
    [nameAttributedString addAttribute:NSFontAttributeName value:FONT(13) range:NSMakeRange(0, [_model.source length])];
    self.nameLabel.attributedText = nameAttributedString;
    self.priceLabel.text = _model.pairce;
    self.volumeLabel.text = [NSString stringWithFormat:@"%@：%@", DBHGetStringWithKeyFromTable(@"Volume (24h)", nil), _model.volum24];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(11);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = FONT(13);
        _priceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _priceLabel;
}
- (UILabel *)volumeLabel {
    if (!_volumeLabel) {
        _volumeLabel = [[UILabel alloc] init];
        _volumeLabel.font = FONT(11);
        _volumeLabel.textColor = COLORFROM16(0xACACAC, 1);
    }
    return _volumeLabel;
}

@end
