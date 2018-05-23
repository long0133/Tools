//
//  DBHProjectHomeHeaderView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeHeaderView.h"

@interface DBHProjectHomeHeaderView ()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation DBHProjectHomeHeaderView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM10(235, 235, 235, 1);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.timeLabel];
    
    WEAKSELF
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(AUTOLAYOUTSIZE(14));
        make.center.equalTo(weakSelf);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setTime:(NSString *)time {
    _time = time;
    
    if (self.isAdd) {
        self.timeLabel.text = [NSString formatTimeDelayEight:_time];
    } else {
        self.timeLabel.text = _time;
    }
    
    
    WEAKSELF
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([NSString getWidthtWithString:_time fontSize:AUTOLAYOUTSIZE(9)] + AUTOLAYOUTSIZE(8));
        make.height.offset(AUTOLAYOUTSIZE(14));
        make.center.equalTo(weakSelf);
    }];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = COLORFROM10(202, 202, 202, 1);
        _timeLabel.font = FONT(9);
        _timeLabel.textColor = WHITE_COLOR;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.layer.cornerRadius = AUTOLAYOUTSIZE(2.5);
        _timeLabel.clipsToBounds = YES;
    }
    return _timeLabel;
}

@end
