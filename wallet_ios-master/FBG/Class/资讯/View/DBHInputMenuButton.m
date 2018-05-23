
//
//  DBHInputMenuButton.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInputMenuButton.h"

@interface DBHInputMenuButton ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation DBHInputMenuButton

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLORFROM10(249, 249, 249, 1);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.leftImageView];
    [self addSubview:self.valueLabel];
}

#pragma mark ------ Getters And Setters ------
- (void)setValue:(NSString *)value {
    _value = value;
    
    self.valueLabel.text = DBHGetStringWithKeyFromTable(_value, nil);
}
- (void)setIsMore:(BOOL)isMore {
    _isMore = isMore;
    
    WEAKSELF
    self.leftImageView.hidden = !_isMore;
    
    self.valueLabel.textAlignment = _isMore ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    if (_isMore) {
        [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(AUTOLAYOUTSIZE(13.5));
            make.height.offset(AUTOLAYOUTSIZE(10));
            make.centerY.equalTo(weakSelf);
            make.centerX.equalTo(weakSelf).multipliedBy(0.6);
        }];
        [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftImageView.mas_right).offset(AUTOLAYOUTSIZE(8));
            make.right.offset(- AUTOLAYOUTSIZE(5));
            make.centerY.equalTo(weakSelf);
        }];
    } else {
        [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(10));
            make.center.equalTo(weakSelf);
        }];
    }
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuzhuye_caidan"]];
    }
    return _leftImageView;
}
- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = FONT(14);
        _valueLabel.textColor = COLORFROM16(0x626262, 1);
        _valueLabel.numberOfLines = 2;
    }
    return _valueLabel;
}

@end
