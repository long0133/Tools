//
//  DBHMenuViewTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMenuViewTableViewCell.h"

@interface DBHMenuViewTableViewCell ()

@property (nonatomic, strong) UIImageView *menuImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DBHMenuViewTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bottomLineWidth = AUTOLAYOUTSIZE(123);
        self.bottomLineViewColor = COLORFROM16(0xF3F3F3, 1);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.menuImageView];
    [self.contentView addSubview:self.titleLabel];
    
    WEAKSELF
    [self.menuImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(15));
        make.left.offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.menuImageView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.menuImageView.image = [UIImage imageNamed:_title];
    self.titleLabel.text = DBHGetStringWithKeyFromTable(_title, nil);
}

- (UIImageView *)menuImageView {
    if (!_menuImageView) {
        _menuImageView = [[UIImageView alloc] init];
        _menuImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _menuImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(13);
        _titleLabel.textColor = COLORFROM16(0x3D3D3D, 1 );
    }
    return _titleLabel;
}

@end
