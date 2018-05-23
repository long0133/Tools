//
//  DBHProjectOverviewForRelevantInformationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectOverviewForRelevantInformationTableViewCell.h"

#import <WebKit/WKWebView.h>

#import "DBHProjectDetailInformationDataModels.h"

@interface DBHProjectOverviewForRelevantInformationTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *marketRankingLabel;
@property (nonatomic, strong) UILabel *marketRankingValueLabel;
@property (nonatomic, strong) UILabel *marketLabel;
@property (nonatomic, strong) UILabel *marketValueLabel;
@property (nonatomic, strong) UILabel *turnoverLabel;
@property (nonatomic, strong) UILabel *turnoverValueLabel;
@property (nonatomic, strong) UILabel *grossLabel;
@property (nonatomic, strong) UILabel *grossValueLabel;
@property (nonatomic, strong) UILabel *icoPriceLabel;
@property (nonatomic, strong) UILabel *icoPriceValueLabel;
@property (nonatomic, strong) UIView *grayLineView;

@end

@implementation DBHProjectOverviewForRelevantInformationTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isHideBottomLineView = YES;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.marketRankingLabel];
    [self.contentView addSubview:self.marketRankingValueLabel];
    [self.contentView addSubview:self.marketLabel];
    [self.contentView addSubview:self.marketValueLabel];
    [self.contentView addSubview:self.turnoverLabel];
    [self.contentView addSubview:self.turnoverValueLabel];
    [self.contentView addSubview:self.grossLabel];
    [self.contentView addSubview:self.grossValueLabel];
    [self.contentView addSubview:self.icoPriceLabel];
    [self.contentView addSubview:self.icoPriceValueLabel];
    [self.contentView addSubview:self.grayLineView];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.offset(AUTOLAYOUTSIZE(15));
    }];
    [self.marketRankingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(14));
    }];
    [self.marketRankingValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.marketRankingLabel);
        make.right.equalTo(weakSelf.grayLineView);
    }];
    [self.marketLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.marketRankingLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11));
    }];
    [self.marketValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.marketLabel);
        make.right.equalTo(weakSelf.grayLineView);
    }];
    [self.turnoverLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.marketLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11));
    }];
    [self.turnoverValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.turnoverLabel);
        make.right.equalTo(weakSelf.grayLineView);
    }];
    [self.grossLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.turnoverLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11));
    }];
    [self.grossValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.grossLabel);
        make.right.equalTo(weakSelf.grayLineView);
    }];
    [self.icoPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.top.equalTo(weakSelf.grossLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11));
    }];
    [self.icoPriceValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.icoPriceLabel);
        make.right.equalTo(weakSelf.grayLineView);
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(44));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    self.marketRankingValueLabel.text = _projectDetailModel.ico.rank;
    self.marketValueLabel.text = [NSString stringWithFormat:@"$%@", _projectDetailModel.ico.marketCapUsd];
    self.turnoverValueLabel.text = _projectDetailModel.ico.availableSupply;
    self.grossValueLabel.text = _projectDetailModel.ico.totalSupply;
    
    NSString *icoPrice = _projectDetailModel.icoPrice;
    if (![icoPrice containsString:@"-"]) {
        icoPrice = [NSString stringWithFormat:@"$%@", icoPrice];
    }
    self.icoPriceValueLabel.text = icoPrice;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(15);
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"Related Information", nil);
        _titleLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _titleLabel;
}
- (UILabel *)marketRankingLabel {
    if (!_marketRankingLabel) {
        _marketRankingLabel = [[UILabel alloc] init];
        _marketRankingLabel.font = FONT(13);
        _marketRankingLabel.text = DBHGetStringWithKeyFromTable(@"Rank", nil);
        _marketRankingLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _marketRankingLabel;
}
- (UILabel *)marketRankingValueLabel {
    if (!_marketRankingValueLabel) {
        _marketRankingValueLabel = [[UILabel alloc] init];
        _marketRankingValueLabel.font = FONT(13);
        _marketRankingValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _marketRankingValueLabel;
}
- (UILabel *)marketLabel {
    if (!_marketLabel) {
        _marketLabel = [[UILabel alloc] init];
        _marketLabel.font = FONT(13);
        _marketLabel.text = DBHGetStringWithKeyFromTable(@"Market Cap", nil);
        _marketLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _marketLabel;
}
- (UILabel *)marketValueLabel {
    if (!_marketValueLabel) {
        _marketValueLabel = [[UILabel alloc] init];
        _marketValueLabel.font = FONT(13);
        _marketValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _marketValueLabel;
}
- (UILabel *)turnoverLabel {
    if (!_turnoverLabel) {
        _turnoverLabel = [[UILabel alloc] init];
        _turnoverLabel.font = FONT(13);
        _turnoverLabel.text = DBHGetStringWithKeyFromTable(@"Circulating Supply", nil);
        _turnoverLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _turnoverLabel;
}
- (UILabel *)turnoverValueLabel {
    if (!_turnoverValueLabel) {
        _turnoverValueLabel = [[UILabel alloc] init];
        _turnoverValueLabel.font = FONT(13);
        _turnoverValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _turnoverValueLabel;
}
- (UILabel *)grossLabel {
    if (!_grossLabel) {
        _grossLabel = [[UILabel alloc] init];
        _grossLabel.font = FONT(13);
        _grossLabel.text = DBHGetStringWithKeyFromTable(@"Total Supply", nil);
        _grossLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _grossLabel;
}
- (UILabel *)grossValueLabel {
    if (!_grossValueLabel) {
        _grossValueLabel = [[UILabel alloc] init];
        _grossValueLabel.font = FONT(13);
        _grossValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _grossValueLabel;
}
- (UILabel *)icoPriceLabel {
    if (!_icoPriceLabel) {
        _icoPriceLabel = [[UILabel alloc] init];
        _icoPriceLabel.font = FONT(13);
        _icoPriceLabel.text = DBHGetStringWithKeyFromTable(@"ICO Price", nil);
        _icoPriceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _icoPriceLabel;
}
- (UILabel *)icoPriceValueLabel {
    if (!_icoPriceValueLabel) {
        _icoPriceValueLabel = [[UILabel alloc] init];
        _icoPriceValueLabel.font = FONT(13);
        _icoPriceValueLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _icoPriceValueLabel;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _grayLineView;
}

@end
