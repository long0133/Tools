//
//  DBHPersonalSettingForHeadTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHPersonalSettingForHeadTableViewCell.h"

@interface DBHPersonalSettingForHeadTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation DBHPersonalSettingForHeadTableViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.moreImageView];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.headImageView);
    }];
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(55));
        make.right.equalTo(weakSelf.moreImageView.mas_left).offset(- AUTOLAYOUTSIZE(10));
        make.bottom.offset(- AUTOLAYOUTSIZE(13));
    }];
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.headImageView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(14);
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"Profile photo", nil);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxiang"]];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.cornerRadius = AUTOLAYOUTSIZE(27.5);
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}
- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _moreImageView;
}

@end
