//
//  DBHProjectHomeMenuTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeMenuTableViewCell.h"

@interface DBHProjectHomeMenuTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DBHProjectHomeMenuTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLORFROM16(0xF9F9F9, 1);
        self.bottomLineWidth = (SCREENWIDTH - AUTOLAYOUTSIZE(43.5) - AUTOLAYOUTSIZE(0.5) * 3) / 3;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(_title, nil);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(14);
        _titleLabel.textColor = COLORFROM16(0x626262, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
