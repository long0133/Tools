
//
//  DBHMyForUserInfomationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyForUserInfomationTableViewCell.h"

@interface DBHMyForUserInfomationTableViewCell ()


@end

@implementation DBHMyForUserInfomationTableViewCell

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
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.accountLabel];
    [self.contentView addSubview:self.moreImageView];
    [self.contentView addSubview:self.tipLoginLabel];
    
    WEAKSELF
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(55));
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headImageView.mas_right).offset(AUTOLAYOUTSIZE(14));
        make.top.offset(AUTOLAYOUTSIZE(24.5));
    }];
    [self.accountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.bottom.offset(- AUTOLAYOUTSIZE(25));
    }];
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.tipLoginLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.moreImageView);
        make.left.equalTo(weakSelf.nameLabel);
    }];
}

#pragma mark ------ Getters And Setters ------
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxiang"]];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.cornerRadius = AUTOLAYOUTSIZE(27.5);
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(14);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.font = FONT(13);
        _accountLabel.textColor = COLORFROM16(0xB9B9B9, 1);
    }
    return _accountLabel;
}
- (UILabel *)tipLoginLabel {
    if (!_tipLoginLabel) {
        _tipLoginLabel = [[UILabel alloc] init];
        _tipLoginLabel.font = FONT(13);
        _tipLoginLabel.textColor = COLORFROM16(0xB9B9B9, 1);
        [_tipLoginLabel sizeToFit];
    }
    return _tipLoginLabel;
}
- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _moreImageView;
}

@end
