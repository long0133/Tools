//
//  DBHSearchInfomationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSearchInfomationTableViewCell.h"

#import "DBHProjectHomeNewsModelData.h"

@interface DBHSearchInfomationTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation DBHSearchInfomationTableViewCell

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
    [self.contentView addSubview:self.timeLabel];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.offset(AUTOLAYOUTSIZE(42));
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.timeLabel.mas_top).offset(- AUTOLAYOUTSIZE(5));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.offset(- AUTOLAYOUTSIZE(8));
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHProjectHomeNewsModelData *)model {
    _model = model;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:AUTOLAYOUTSIZE(4)];
    NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:_model.title attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    
    self.titleLabel.attributedText = titleAttributedString;
    self.timeLabel.text = [NSString formatTimeDelayEight:_model.createdAt];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(15);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT(12);
        _timeLabel.textColor = COLORFROM16(0xC9C6C6, 1);
    }
    return _timeLabel;
}

@end
