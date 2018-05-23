//
//  DBHLineValueView.m
//  FBG
//
//  Created by yy on 2018/3/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHLineValueView.h"

@interface DBHLineValueView()

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thridLabel;

@end

@implementation DBHLineValueView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.firstLabel];
    [self addSubview:self.secondLabel];
    [self addSubview:self.thridLabel];
    
    WEAKSELF
    [self.firstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.height.equalTo(weakSelf);
    }];
    
    [self.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf);
        make.left.equalTo(weakSelf.firstLabel.mas_right).offset(AUTOLAYOUTSIZE(5));
    }];
    
    [self.firstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf);
        make.left.equalTo(weakSelf.secondLabel.mas_right).offset(AUTOLAYOUTSIZE(5));
        make.right.equalTo(weakSelf);
    }];
}

- (void)setLabels:(NSArray *)labels {
    self.firstLabel.text = labels.count > 0 ? labels[0] : @"";
    self.secondLabel.text = labels.count > 1 ? labels[1] : @"";
    self.thridLabel.text = labels.count > 2 ? labels[2] : @"";
    
    WEAKSELF
    CGFloat width = [NSString getWidthtWithString:weakSelf.firstLabel.text fontSize:12];
    [self.firstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(5));
        make.width.equalTo(@(AUTOLAYOUTSIZE(width)));
    }];
    
    width = [NSString getWidthtWithString:weakSelf.secondLabel.text fontSize:12];
    [self.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf);
        make.left.equalTo(weakSelf.firstLabel.mas_right).offset(AUTOLAYOUTSIZE(5));
        make.width.equalTo(@(AUTOLAYOUTSIZE(width)));
    }];
    
    [self.thridLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf);
        make.left.equalTo(weakSelf.secondLabel.mas_right).offset(AUTOLAYOUTSIZE(5));
        make.right.equalTo(weakSelf);
    }];
}

- (UILabel *)firstLabel {
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.font = FONT(12);
        _firstLabel.textColor = COLORFROM16(0x1AA2F6, 1);
    }
    return _firstLabel;
}

- (UILabel *)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.font = FONT(12);
        _secondLabel.textColor = COLORFROM16(0xFFE000, 1);
    }
    return _secondLabel;
}

- (UILabel *)thridLabel {
    if (!_thridLabel) {
        _thridLabel = [[UILabel alloc] init];
        _thridLabel.font = FONT(12);
        _thridLabel.textColor = COLORFROM16(0xF600FF, 1);
    }
    return _thridLabel;
}
@end
