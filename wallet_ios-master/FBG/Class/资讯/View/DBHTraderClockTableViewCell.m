//
//  DBHTraderClockTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTraderClockTableViewCell.h"

@interface DBHTraderClockTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *numberValueLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIView *firstGrayLineView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *toAddressLabel;
@property (nonatomic, strong) UILabel *fromAddressLabel;
@property (nonatomic, strong) UILabel *walletLabel;
@property (nonatomic, strong) UIView *secondGrayLineView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation DBHTraderClockTableViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.numberValueLabel];
    [self.contentView addSubview:self.unitLabel];
    [self.contentView addSubview:self.firstGrayLineView];
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.toAddressLabel];
    [self.contentView addSubview:self.fromAddressLabel];
    [self.contentView addSubview:self.walletLabel];
    [self.contentView addSubview:self.secondGrayLineView];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.moreImageView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(14));
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(14));
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(14));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(4));
    }];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.numberValueLabel.mas_top).offset(- AUTOLAYOUTSIZE(18));
    }];
    [self.numberValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.unitLabel.mas_top).offset(- AUTOLAYOUTSIZE(4));
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.firstGrayLineView.mas_top).offset(- AUTOLAYOUTSIZE(16));
    }];
    [self.firstGrayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.secondGrayLineView);
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.secondGrayLineView.mas_top).offset(- AUTOLAYOUTSIZE(111.5));
    }];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstGrayLineView.mas_bottom);
        make.bottom.equalTo(weakSelf.secondGrayLineView.mas_top);
        make.width.equalTo(weakSelf.boxView);
        make.centerX.equalTo(weakSelf.boxView);
    }];
    [self.toAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.secondGrayLineView);
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.fromAddressLabel.mas_top).offset(- AUTOLAYOUTSIZE(14));
    }];
    [self.fromAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.secondGrayLineView);
        make.center.equalTo(weakSelf.backView);
    }];
    [self.walletLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.secondGrayLineView);
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.fromAddressLabel.mas_bottom).offset(AUTOLAYOUTSIZE(14));
    }];
    [self.secondGrayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(28));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.detailLabel.mas_top);
    }];
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.height.offset(AUTOLAYOUTSIZE(35.5));
        make.bottom.equalTo(weakSelf.boxView);
    }];
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.equalTo(weakSelf.firstGrayLineView);
        make.centerY.equalTo(weakSelf.detailLabel);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setMessage:(EMMessage *)message {
    _message = message;
    
    if (![_message isKindOfClass:[EMMessage class]]) {
        return;
    }
    
    self.titleLabel.text = _message.ext[@"title"];
    
    self.timeLabel.text = [NSString timeExchangeWithType:@"yyyy-MM-dd hh:mm" timestamp:_message.timestamp];
    
    self.numberLabel.text = DBHGetStringWithKeyFromTable(@"Amount", nil);
    if ([_message.ext[@"flag"] isEqualToString:@"ETH"]) {
        self.numberValueLabel.text = [NSString stringWithFormat:@"%@%@", [_message.ext[@"money"] substringToIndex:1], [NSString DecimalFuncWithOperatorType:3 first:[NSString numberHexString:[_message.ext[@"money"] substringFromIndex:3]] secend:@"1000000000000000000" value:4]];
    } else {
        self.numberValueLabel.text = _message.ext[@"money"];
    }
    self.unitLabel.text = [NSString stringWithFormat:@"(%@)", _message.ext[@"flag"]];
    
    NSString *toAddress = _message.ext[@"to"];
    if (toAddress.length) {
        NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@", DBHGetStringWithKeyFromTable(@"Collection Address", nil), toAddress]];
        [contentAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xBBBBBB, 1) range:NSMakeRange(0, DBHGetStringWithKeyFromTable(@"Collection Address", nil).length + 1)];
        self.toAddressLabel.attributedText = contentAttributedString;
    }
    
    NSString *fromAddress = _message.ext[@"from"];
    if (fromAddress.length) {
        NSMutableAttributedString *transferAddressAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@", DBHGetStringWithKeyFromTable(@"Transfer Address", nil), fromAddress]];
        [transferAddressAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xBBBBBB, 1) range:NSMakeRange(0, DBHGetStringWithKeyFromTable(@"Transfer Address", nil).length + 1)];
        self.fromAddressLabel.attributedText = transferAddressAttributedString;
    }
    
    NSString *walletName = _message.ext[@"wallet_name"];
    if (walletName.length) {
        NSMutableAttributedString *transferWalletAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@", DBHGetStringWithKeyFromTable(@"Transfer Wallet", nil), walletName]];
        [transferWalletAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xBBBBBB, 1) range:NSMakeRange(0, DBHGetStringWithKeyFromTable(@"Transfer Wallet", nil).length + 1)];
        self.walletLabel.attributedText = transferWalletAttributedString;   
    }
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
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(14);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT(10);
        _timeLabel.textColor = COLORFROM16(0xD8D8D8, 1);
    }
    return _timeLabel;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = FONT(11);
        _numberLabel.textColor = COLORFROM16(0xBBBBBB, 1);
    }
    return _numberLabel;
}
- (UILabel *)numberValueLabel {
    if (!_numberValueLabel) {
        _numberValueLabel = [[UILabel alloc] init];
        _numberValueLabel.font = BOLDFONT(20);
        _numberValueLabel.textColor = COLORFROM16(0x262626, 1);
    }
    return _numberValueLabel;
}
- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = FONT(10);
        _unitLabel.textColor = COLORFROM16(0xBBBBBB, 1);
    }
    return _unitLabel;
}
- (UIView *)firstGrayLineView {
    if (!_firstGrayLineView) {
        _firstGrayLineView = [[UIView alloc] init];
        _firstGrayLineView.backgroundColor = COLORFROM16(0xD2D2D2, 1);
    }
    return _firstGrayLineView;
}
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}
- (UILabel *)toAddressLabel {
    if (!_toAddressLabel) {
        _toAddressLabel = [[UILabel alloc] init];
        _toAddressLabel.font = FONT(13);
        _toAddressLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _toAddressLabel;
}
- (UILabel *)fromAddressLabel {
    if (!_fromAddressLabel) {
        _fromAddressLabel = [[UILabel alloc] init];
        _fromAddressLabel.font = FONT(13);
        _fromAddressLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _fromAddressLabel;
}
- (UILabel *)walletLabel {
    if (!_walletLabel) {
        _walletLabel = [[UILabel alloc] init];
        _walletLabel.font = FONT(13);
        _walletLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _walletLabel;
}
- (UIView *)secondGrayLineView {
    if (!_secondGrayLineView) {
        _secondGrayLineView = [[UIView alloc] init];
        _secondGrayLineView.backgroundColor = COLORFROM16(0xD2D2D2, 1);
    }
    return _secondGrayLineView;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = FONT(13);
        _detailLabel.text = DBHGetStringWithKeyFromTable(@"Details", nil);
        _detailLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _detailLabel;
}
- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _moreImageView;
}

@end
