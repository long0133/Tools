//
//  DBHRankListHeaderView.m
//  FBG
//
//  Created by yy on 2018/3/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHRankListHeaderView.h"

@interface DBHRankListHeaderView()

/**
 显示的标题
 */
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *rank;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *symbolLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation DBHRankListHeaderView

- (instancetype)initWithRank:(NSString *)rank icon:(NSString *)icon first:(NSString *)first second:(NSString *)second third:(NSString *)third {
    if (self = [super init]) {
        self.rank = rank;
        self.icon = icon;
        self.name = first;
        self.symbol = second;
        self.desc = third;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    self.backgroundColor = WHITE_COLOR;
    [self addSubview:self.button];
    
    WEAKSELF
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
        make.center.equalTo(weakSelf);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(0.5));
        make.height.right.centerY.equalTo(weakSelf);
    }];
    
    [self addSubview:self.rankLabel];
    CGFloat width = [NSString getWidthtWithString:self.rank fontSize:14];
    [self.rankLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf);
        make.left.offset(AUTOLAYOUTSIZE(18));
        make.width.offset(AUTOLAYOUTSIZE(width));
    }];
    
    if (self.icon) { // 不显示图片
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(AUTOLAYOUTSIZE(20));
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf.rankLabel.mas_right).offset(AUTOLAYOUTSIZE(8));
        }];
    }
    
    [self addSubview:self.nameLabel];
    width = [NSString getWidthtWithString:self.name fontSize:15];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.desc.length > 0) {
            make.top.offset(AUTOLAYOUTSIZE(12));
        } else {
            make.centerY.equalTo(weakSelf.rankLabel);
        }
        
        if (self.symbol.length > 0) {
            make.width.offset(AUTOLAYOUTSIZE(MIN(width, LIST_MIN_WIDTH - 78)));
        } else {
            make.right.equalTo(weakSelf).offset(-AUTOLAYOUTSIZE(5));
        }
        make.left.equalTo((weakSelf.icon.length > 0 ? weakSelf.iconImageView : weakSelf.rankLabel).mas_right).offset(AUTOLAYOUTSIZE(5));
    }];
    
    if (self.symbol.length > 0) {
        [self addSubview:self.symbolLabel];
        [self.symbolLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLabel.mas_right).offset(AUTOLAYOUTSIZE(3));
            make.right.equalTo(weakSelf).offset(-AUTOLAYOUTSIZE(5));
            make.bottom.equalTo(weakSelf.nameLabel);
        }];
    }
   
    if (self.desc.length > 0) {
        [self addSubview:self.descriptionLabel];
        width = [NSString getWidthtWithString:self.desc fontSize:13];
        [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLabel);
            make.right.equalTo(weakSelf).offset(-AUTOLAYOUTSIZE(5));
            make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(AUTOLAYOUTSIZE(0));
        }];
    }
}

- (void)respondsToButtonClick:(UIButton *)btn {
    if (self.clickBlock) {
        self.clickBlock(btn);
    }
}

#pragma mark ---- Getters and setters
- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = COLORFROM16(0xACACAC, 1);
        _rankLabel.font = BOLDFONT(14);
        _rankLabel.text = self.rank;
    }
    return _rankLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *imgUrlStr = self.icon;
        if (self.icon.length == 0) { // 显示默认图片
            imgUrlStr = @"";
        }
       [_iconImageView sdsetImageWithURL:imgUrlStr placeholderImage:[UIImage imageWithColor:WHITE_COLOR]];
    }
    return _iconImageView;
}

- (UILabel *)symbolLabel {
    if (!_symbolLabel) {
        _symbolLabel = [[UILabel alloc] init];
        _symbolLabel.textColor = COLORFROM16(0xD9D7D7, 1);
        _symbolLabel.font = FONT(13);
        _symbolLabel.text = self.symbol;
    }
    return _symbolLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = COLORFROM16(0X8B8B8B, 1);
        _nameLabel.font = FONT(15);
        _nameLabel.text = self.name;
    }
    return _nameLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = COLORFROM16(0xD9D7D7, 1);
        _descriptionLabel.font = FONT(13);
        _descriptionLabel.text = self.desc;
    }
    return _descriptionLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.backgroundColor = [UIColor clearColor];
        [_button addTarget:self action:@selector(respondsToButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        
        CGFloat width = AUTOLAYOUTSIZE(1);
        _lineView.frame = CGRectMake(CGRectGetMaxX(self.frame) - width, 0, width, CGRectGetHeight(self.frame));
        _lineView.backgroundColor = COLORFROM16(0xF3F3F3, 1);
    }
    return _lineView;
}

@end
