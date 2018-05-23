//
//  DBHProjectOtherSectionTableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/16.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectOtherSectionTableViewCell.h"

@interface DBHProjectOtherSectionTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation DBHProjectOtherSectionTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bottomLineViewColor = COLORFROM16(0xF5F5F5, 1);
        self.bottomLineWidth = SCREENWIDTH - AUTOLAYOUTSIZE(44);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moreImageView];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(AUTOLAYOUTSIZE(22));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.offset(- AUTOLAYOUTSIZE(22));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

- (void)setTitle:(NSString *)titleStr isShowArrow:(BOOL)isShow {
    self.titleLabel.text = titleStr;
    self.moreImageView.hidden = !isShow;
}

#pragma mark ------ Getters And Setters ------

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(14);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}

- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _moreImageView;
}

@end
