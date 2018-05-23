
//
//  DBHMyQuotationReminderTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyQuotationReminderTableViewCell.h"

#import "DBHInformationDataModels.h"

@interface DBHMyQuotationReminderTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *abbreviationLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *aboceLabel;
@property (nonatomic, strong) UILabel *belowLabel;

@end

@implementation DBHMyQuotationReminderTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bottomLineWidth = SCREENWIDTH;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.abbreviationLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.changeLabel];
    [self.contentView addSubview:self.aboceLabel];
    [self.contentView addSubview:self.belowLabel];
    
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(20));
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.priceLabel);
    }];
    [self.abbreviationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.centerY.equalTo(weakSelf.changeLabel);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.top.offset(AUTOLAYOUTSIZE(14.5));
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.priceLabel);
        make.top.equalTo(weakSelf.priceLabel.mas_bottom).offset(AUTOLAYOUTSIZE(5));
    }];
    [self.aboceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.priceLabel);
    }];
    [self.belowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.aboceLabel);
        make.centerY.equalTo(weakSelf.changeLabel);
    }];
}

// 改变滑动删除按钮样式
- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            CGRect cRect = subView.frame;
            cRect.size.height = self.contentView.frame.size.height - 10;
            subView.frame = cRect;

            for (UIView *confirmView in subView.subviews) {
                for(UIView *sub in confirmView.subviews){
                    if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]){
                        UILabel *deleteLabel=(UILabel *)sub;
                        // 改删除按钮的字体
                        deleteLabel.font = FONT(13);
                    }
                }
            }
            break;
        }
    }
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHInformationModelData *)model {
    _model = model;
    
    [self.iconImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageNamed:@"NEO_add"]];
    self.nameLabel.text = _model.longName;
    self.abbreviationLabel.text = [NSString stringWithFormat:@"(%@)", _model.unit];
    self.priceLabel.text = [UserSignData share].user.walletUnitType == 1 ? [NSString stringWithFormat:@"¥%.2lf", _model.ico.priceCny.doubleValue] : [NSString stringWithFormat:@"$%.2lf", _model.ico.priceUsd.doubleValue];
    self.changeLabel.text = [NSString stringWithFormat:@"(%@%.2lf%%)", _model.ico.percentChange24h.doubleValue >= 0 ? @"+" : @"", _model.ico.percentChange24h.doubleValue];
    self.aboceLabel.text = [NSString stringWithFormat:@"%@ $%@", DBHGetStringWithKeyFromTable(@"Above", nil), _model.categoryUser.marketHige];
    self.belowLabel.text = [NSString stringWithFormat:@"%@ $%@", DBHGetStringWithKeyFromTable(@"Below", nil), _model.categoryUser.marketLost];
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
        _nameLabel.font = FONT(14);
        _nameLabel.textColor = COLORFROM16(0x262626, 1);
    }
    return _nameLabel;
}
- (UILabel *)abbreviationLabel {
    if (!_abbreviationLabel) {
        _abbreviationLabel = [[UILabel alloc] init];
        _abbreviationLabel.font = FONT(11);
        _abbreviationLabel.textColor = COLORFROM16(0xA5A5A5, 1);
    }
    return _abbreviationLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = FONT(14);
        _priceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _priceLabel;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = FONT(11);
        _changeLabel.textColor = COLORFROM16(0xFF680F, 1);
    }
    return _changeLabel;
}
- (UILabel *)aboceLabel {
    if (!_aboceLabel) {
        _aboceLabel = [[UILabel alloc] init];
        _aboceLabel.font = FONT(10);
        _aboceLabel.textColor = COLORFROM16(0xA3A3A3, 1);
    }
    return _aboceLabel;
}
- (UILabel *)belowLabel {
    if (!_belowLabel) {
        _belowLabel = [[UILabel alloc] init];
        _belowLabel.font = FONT(10);
        _belowLabel.textColor = COLORFROM16(0xA3A3A3, 1);
    }
    return _belowLabel;
}

@end
