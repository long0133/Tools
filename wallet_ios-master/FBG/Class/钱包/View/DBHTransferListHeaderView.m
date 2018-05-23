//
//  DBHTransferListHeaderView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTransferListHeaderView.h"

@interface DBHTransferListHeaderView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation DBHTransferListHeaderView

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.numberLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.promptLabel];
    [self addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(74.5));
        make.centerX.equalTo(weakSelf);
        make.top.offset(AUTOLAYOUTSIZE(28));
    }];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomLineView);
        make.bottom.equalTo(weakSelf.bottomLineView.mas_top).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(48));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.bottom.equalTo(weakSelf);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setBalance:(NSString *)balance {
    _balance = balance;
    
    self.numberLabel.text = _balance;
}
- (void)setAsset:(NSString *)asset {
    _asset = asset;
    
    if ([NSObject isNulllWithObject:_asset]) {
        _asset = @"0.00";
    }
    self.priceLabel.text = [NSString stringWithFormat:@"%@%.2lf", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", _asset.doubleValue];
}
- (void)setHeadImageUrl:(NSString *)headImageUrl {
    _headImageUrl = headImageUrl;
    
    if ([_headImageUrl containsString:@"http:"]) {
        [self.iconImageView sdsetImageWithURL:_headImageUrl placeholderImage:[UIImage imageNamed:@"NEO_add"]];
    } else {
        self.iconImageView.image = [UIImage imageNamed:_headImageUrl];
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NEO_add"]];
        _iconImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _iconImageView;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = BOLDFONT(20);
        _numberLabel.textColor = COLORFROM16(0x158327, 1);
        _numberLabel.text = @"0.00000000";
    }
    return _numberLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = BOLDFONT(11);
        _priceLabel.textColor = COLORFROM16(0xC6C6C6, 1);
        _priceLabel.text = @"0.00";
    }
    return _priceLabel;
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.font = BOLDFONT(11);
        _promptLabel.text = DBHGetStringWithKeyFromTable(@"Transactions Records", nil);
        _promptLabel.textColor = COLORFROM16(0xC6C6C6, 1);
    }
    return _promptLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _bottomLineView;
}

@end
