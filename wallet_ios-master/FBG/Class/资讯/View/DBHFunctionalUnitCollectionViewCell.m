
//
//  DBHFunctionalUnitCollectionViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHFunctionalUnitCollectionViewCell.h"

@interface DBHFunctionalUnitCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *noReadLabel;

@end

@implementation DBHFunctionalUnitCollectionViewCell

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
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.noReadLabel];
    WEAKSELF
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(45));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.offset(AUTOLAYOUTSIZE(18));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).offset(AUTOLAYOUTSIZE(6));
    }];
    
    [self.noReadLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(16));
        make.centerX.equalTo(weakSelf.iconImageView.mas_right);
        make.centerY.equalTo(weakSelf.iconImageView.mas_top);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setNoReadMsgCount:(NSInteger)noReadMsgCount {
    _noReadMsgCount = noReadMsgCount;
    
    if (noReadMsgCount == 0) {
        _noReadLabel.hidden = YES;
    } else {
        _noReadLabel.hidden = NO;
        _noReadLabel.text = [NSString stringWithFormat:@"%@", @(noReadMsgCount)];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.iconImageView.image = [UIImage imageNamed:_title];
    self.titleLabel.text = DBHGetStringWithKeyFromTable(_title, nil);;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(12);
        _titleLabel.textColor = COLORFROM16(0xB1B1B1, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)noReadLabel {
    if (!_noReadLabel) {
        _noReadLabel = [[UILabel alloc] init];
        _noReadLabel.hidden = YES;
//        _noReadLabel.text = @"2";
        _noReadLabel.backgroundColor = [UIColor redColor];
        _noReadLabel.layer.cornerRadius = AUTOLAYOUTSIZE(8);
        _noReadLabel.clipsToBounds = YES;
        _noReadLabel.font = FONT(10);
        _noReadLabel.textColor = WHITE_COLOR;
        _noReadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noReadLabel;
}
@end
