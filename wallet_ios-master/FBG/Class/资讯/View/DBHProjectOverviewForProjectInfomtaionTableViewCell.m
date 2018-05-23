//
//  DBHProjectOverviewForProjectInfomtaionTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectOverviewForProjectInfomtaionTableViewCell.h"

#import "DBHGradeView.h"

#import "DBHProjectDetailInformationDataModels.h"
#import "YYEvaluateSynthesisModel.h"

@interface DBHProjectOverviewForProjectInfomtaionTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *hotAttentionLabel;
@property (nonatomic, strong) UIView *centerGrayLineView;
@property (nonatomic, strong) DBHGradeView *gradeView;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UILabel *userGradeLabel;

@end

@implementation DBHProjectOverviewForProjectInfomtaionTableViewCell

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
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.changeLabel];
    [self.contentView addSubview:self.volumeLabel];
    [self.contentView addSubview:self.grayLineView];
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.hotAttentionLabel];
    [self.contentView addSubview:self.centerGrayLineView];
    [self.contentView addSubview:self.gradeView];
    [self.contentView addSubview:self.gradeLabel];
    [self.contentView addSubview:self.userGradeLabel];
    
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(24));
        make.left.offset(AUTOLAYOUTSIZE(17));
        make.top.offset(AUTOLAYOUTSIZE(24));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOLAYOUTSIZE(8));
        make.top.offset(AUTOLAYOUTSIZE(18));
    }];
    [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
        make.width.lessThanOrEqualTo(@(AUTOLAYOUTSIZE(160)));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(weakSelf.nameLabel.mas_right).offset(AUTOLAYOUTSIZE(6));
        make.centerY.equalTo(weakSelf.nameLabel);
        make.right.offset(- AUTOLAYOUTSIZE(21));
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceLabel.mas_bottom).offset(AUTOLAYOUTSIZE(1.5));
        make.right.equalTo(weakSelf.priceLabel);
    }];
    [self.volumeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.changeLabel.mas_bottom).offset(AUTOLAYOUTSIZE(4.5));
        make.right.equalTo(weakSelf.priceLabel);
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(44));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.offset(- AUTOLAYOUTSIZE(59));
    }];
    [self.rankLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(8));
        make.centerX.equalTo(weakSelf.hotAttentionLabel);
    }];
    [self.hotAttentionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rankLabel.mas_bottom).offset(AUTOLAYOUTSIZE(2));
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.centerGrayLineView.mas_left);
    }];
    [self.centerGrayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(13));
        make.bottom.offset(- AUTOLAYOUTSIZE(13));
    }];
    [self.gradeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(56.5));
        make.height.equalTo(weakSelf.gradeLabel);
        make.right.offset(- AUTOLAYOUTSIZE(86));
        make.centerY.equalTo(weakSelf.rankLabel);
    }];
    [self.gradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.rankLabel);
        make.left.equalTo(weakSelf.gradeView.mas_right).offset(AUTOLAYOUTSIZE(5));
    }];
    [self.userGradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.hotAttentionLabel);
        make.left.equalTo(weakSelf.centerGrayLineView.mas_right);
        make.right.equalTo(weakSelf.contentView);
    }];
}


#pragma mark ------ Getters And Setters ------
- (void)setModel:(YYEvaluateSynthesisModel *)model {
    if (_model.score_avg == model.score_avg) {
        return;
    }
    
    _model = model;
    
    self.gradeView.grade = model.score_avg;
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1lf%@", model.score_avg, DBHGetStringWithKeyFromTable(@"", nil)];
    
    self.projectDetailModel.categoryScore.value = model.score_avg;
}

- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    [self.iconImageView sdsetImageWithURL:_projectDetailModel.img placeholderImage:nil];
    
    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（%@）", _projectDetailModel.unit, _projectDetailModel.longName]];
    [nameAttributedString addAttributes:@{NSFontAttributeName:BOLDFONT(16)} range:NSMakeRange(0, _projectDetailModel.unit.length)];
    self.nameLabel.attributedText = nameAttributedString;
    self.tagLabel.text = _projectDetailModel.industry;
    
    self.priceLabel.hidden = _projectDetailModel.type != 1;
    self.changeLabel.hidden = _projectDetailModel.type != 1;
    self.volumeLabel.hidden = _projectDetailModel.type != 1;
    if (_projectDetailModel.type == 1) {
        BOOL isZhUnit = [UserSignData share].user.walletUnitType == 1;
        NSString *price = isZhUnit ? _projectDetailModel.ico.priceCny : _projectDetailModel.ico.priceUsd;
        
        if ([NSObject isNulllWithObject:price]) {
            price = @"0.00";
        }
        
        if (price.doubleValue < 0.01) {
            price = [NSString stringWithFormat:@"%@%@", isZhUnit ? @"¥" : @"$", price];
        } else {
            price = [NSString stringWithFormat:@"%@%.2lf", isZhUnit ? @"¥" : @"$", price.doubleValue];
        }
        
        self.priceLabel.text =  price;
        
        CGFloat width = [NSString getWidthtWithString:price fontSize:20] + 6;
        WEAKSELF
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(weakSelf.nameLabel.mas_right).offset(AUTOLAYOUTSIZE(6));
            make.centerY.equalTo(weakSelf.nameLabel);
            make.width.equalTo(@(width));
            make.right.offset(- AUTOLAYOUTSIZE(21));
        }];
        
        NSString *volume = isZhUnit ? _projectDetailModel.ico.volumeCny24h : _projectDetailModel.ico.volumeUsd24h;
        if ([NSObject isNulllWithObject:volume]) {
            volume = @"0";
        }
        self.volumeLabel.text = [NSString stringWithFormat:@"%@：%@", DBHGetStringWithKeyFromTable(@"Volume (24h)", nil), volume];
        
        if (_projectDetailModel.ico.percentChange24h.doubleValue >= 0) {
            self.changeLabel.text = [NSString stringWithFormat:@"(%@%.2lf%%)", @"+", _projectDetailModel.ico.percentChange24h.doubleValue];
            self.changeLabel.textColor = COLORFROM16(0x3CA316, 1);
        } else {
            self.changeLabel.text = [NSString stringWithFormat:@"(%@%.2lf%%)", @"", _projectDetailModel.ico.percentChange24h.doubleValue];
            self.changeLabel.textColor = MAIN_ORANGE_COLOR;
        }
    } else {
        
    }
    
    if ([[DBHLanguageTool sharedInstance].language isEqualToString:CNS]) {
        self.rankLabel.text = [NSString stringWithFormat:@"第%ld名", (NSInteger)_projectDetailModel.categoryScore.sort];
    } else {
        self.rankLabel.text = [NSString stringWithFormat:@"No.%ld", (NSInteger)_projectDetailModel.categoryScore.sort];
    }
    self.gradeView.grade = _projectDetailModel.categoryScore.value;
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1lf%@", _projectDetailModel.categoryScore.value, DBHGetStringWithKeyFromTable(@"", nil)];
    
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
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = FONT(11);
        _tagLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _tagLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = BOLDFONT(20);
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
- (UILabel *)volumeLabel {
    if (!_volumeLabel) {
        _volumeLabel = [[UILabel alloc] init];
        _volumeLabel.font = FONT(9);
        _volumeLabel.textColor = COLORFROM16(0xACACAC, 1);
    }
    return _volumeLabel;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _grayLineView;
}
- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.font = FONT(15);
        _rankLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _rankLabel;
}
- (UILabel *)hotAttentionLabel {
    if (!_hotAttentionLabel) {
        _hotAttentionLabel = [[UILabel alloc] init];
        _hotAttentionLabel.font = FONT(11);
        _hotAttentionLabel.text = DBHGetStringWithKeyFromTable(@"Rank", nil);
        _hotAttentionLabel.textColor = COLORFROM16(0xC5C5C5, 1);
        _hotAttentionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hotAttentionLabel;
}
- (UIView *)centerGrayLineView {
    if (!_centerGrayLineView) {
        _centerGrayLineView = [[UIView alloc] init];
        _centerGrayLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _centerGrayLineView;
}
- (DBHGradeView *)gradeView {
    if (!_gradeView) {
        _gradeView = [[DBHGradeView alloc] init];
    }
    return _gradeView;
}
- (UILabel *)gradeLabel {
    if (!_gradeLabel) {
        _gradeLabel = [[UILabel alloc] init];
        _gradeLabel.font = FONT(15);
        _gradeLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _gradeLabel;
}
- (UILabel *)userGradeLabel {
    if (!_userGradeLabel) {
        _userGradeLabel = [[UILabel alloc] init];
        _userGradeLabel.font = FONT(11);
        _userGradeLabel.text = DBHGetStringWithKeyFromTable(@"Rating", nil);
        _userGradeLabel.textColor = COLORFROM16(0xC5C5C5, 1);
        _userGradeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userGradeLabel;
}

@end
