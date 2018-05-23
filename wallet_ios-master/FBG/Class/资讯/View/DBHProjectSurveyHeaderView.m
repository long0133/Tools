//
//  DBHProjectSurveyHeaderView.m
//  FBG
//
//  Created by yy on 2018/4/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectSurveyHeaderView.h"
#import "DBHGradeView.h"
#import "DBHSelectScrollView.h"
#import "DBHProjectDetailInformationDataModels.h"

@interface DBHProjectSurveyHeaderView ()

@property (nonatomic, strong) UIView *bgView;

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

@property (nonatomic, strong) DBHSelectScrollView *titleScrollView;

@end


@implementation DBHProjectSurveyHeaderView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.bgView];
    WEAKSELF
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.top.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(160));
    }];
    
    [self.bgView addSubview:self.iconImageView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.tagLabel];
    [self.bgView addSubview:self.priceLabel];
    [self.bgView addSubview:self.changeLabel];
    [self.bgView addSubview:self.volumeLabel];
    [self.bgView addSubview:self.grayLineView];
    [self.bgView addSubview:self.rankLabel];
    [self.bgView addSubview:self.hotAttentionLabel];
    [self.bgView addSubview:self.centerGrayLineView];
    [self.bgView addSubview:self.gradeView];
    [self.bgView addSubview:self.gradeLabel];
    [self.bgView addSubview:self.userGradeLabel];
    
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
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        make.width.equalTo(weakSelf.bgView).offset(- AUTOLAYOUTSIZE(44));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.bgView);
        make.bottom.offset(- AUTOLAYOUTSIZE(59));
    }];
    [self.rankLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(8));
        make.centerX.equalTo(weakSelf.hotAttentionLabel);
    }];
    [self.hotAttentionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rankLabel.mas_bottom).offset(AUTOLAYOUTSIZE(2));
        make.left.equalTo(weakSelf.bgView);
        make.right.equalTo(weakSelf.centerGrayLineView.mas_left);
    }];
    [self.centerGrayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.bgView);
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
        make.right.equalTo(weakSelf.bgView);
    }];
    
    [self addSubview:self.titleScrollView];
    [self.titleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView.mas_bottom);
        make.width.centerX.bottom.equalTo(weakSelf);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    [self.iconImageView sdsetImageWithURL:_projectDetailModel.img placeholderImage:nil];
    
    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@（%@）", _projectDetailModel.unit, _projectDetailModel.name]];
    [nameAttributedString addAttributes:@{NSFontAttributeName:BOLDFONT(16)} range:NSMakeRange(0, _projectDetailModel.unit.length)];
    self.nameLabel.attributedText = nameAttributedString;
    self.tagLabel.text = _projectDetailModel.industry;
    
    self.priceLabel.hidden = _projectDetailModel.type != 1;
    self.changeLabel.hidden = _projectDetailModel.type != 1;
    self.volumeLabel.hidden = _projectDetailModel.type != 1;
    if (_projectDetailModel.type == 1) {
        BOOL isZhUnit = [UserSignData share].user.walletUnitType == 1;
        NSString *price = isZhUnit ? _projectDetailModel.ico.priceCny : _projectDetailModel.ico.priceUsd;
        price = [NSString stringWithFormat:@"%@%.2lf", isZhUnit ? @"¥" : @"$", price.doubleValue];
        self.priceLabel.text =  price;
        
        self.volumeLabel.text = [NSString stringWithFormat:@"%@：%@", DBHGetStringWithKeyFromTable(@"Volume (24h)", nil), isZhUnit ? _projectDetailModel.ico.volumeCny24h : _projectDetailModel.ico.volumeUsd24h];
        
        self.changeLabel.text = [NSString stringWithFormat:@"(%@%.2lf%%)", _projectDetailModel.ico.percentChange24h.doubleValue >= 0 ? @"+" : @"", _projectDetailModel.ico.percentChange24h.doubleValue];
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

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (DBHSelectScrollView *)titleScrollView  {
    if (!_titleScrollView) {
        _titleScrollView = [[DBHSelectScrollView alloc] initWithTitles:self.titleStrArray currentSelectedIndex:0];
        _titleScrollView.backgroundViewColor = COLORFROM16(0xF6F6F6, 1);
        
        //        WEAKSELF
        [_titleScrollView setSelectedBlock:^(int index) {
            // TODO
        }];
    }
    return _titleScrollView;
}

- (NSMutableArray *)titleStrArray {
    if (!_titleStrArray) {
        _titleStrArray = [NSMutableArray arrayWithObjects:
                          DBHGetStringWithKeyFromTable(@"Information", nil),
                          DBHGetStringWithKeyFromTable(@"Evaluation", nil),
                          DBHGetStringWithKeyFromTable(@"Overview", nil), nil];
    }
    return _titleStrArray;
}

@end
