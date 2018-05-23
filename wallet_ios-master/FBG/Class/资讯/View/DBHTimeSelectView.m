//
//  DBHTimeSelectView.m
//  FBG
//
//  Created by 邓毕华 on 2017/12/5.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "DBHTimeSelectView.h"

#import "DBHMarketDetailKLineViewModelData.h"

#define OPEN DBHGetStringWithKeyFromTable(@"Open ", nil)
#define HIGH DBHGetStringWithKeyFromTable(@"High ", nil)
#define LOW DBHGetStringWithKeyFromTable(@"Low ", nil)
#define CLOSE DBHGetStringWithKeyFromTable(@"Close ", nil)
#define VOLUME DBHGetStringWithKeyFromTable(@"Volume ", nil)

@interface DBHTimeSelectView ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *openLabel;
@property (nonatomic, strong) UILabel *heightLabel;
@property (nonatomic, strong) UILabel *lowLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, copy) ClickTimeBlock clickTimeBlock;
@property (nonatomic, copy) NSArray *timeTitleArray;

@end

@implementation DBHTimeSelectView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        self.currentSelectedIndex = 2;
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    WEAKSELF
    for (NSInteger i = 0; i < self.timeTitleArray.count; i++) {
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        timeButton.tag = 200 + i;
        timeButton.titleLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        timeButton.selected = i == self.currentSelectedIndex;
        [timeButton setTitle:DBHGetStringWithKeyFromTable(self.timeTitleArray[i], nil) forState:UIControlStateNormal];
        [timeButton setTitleColor:COLORFROM16(0x262626, 1) forState:UIControlStateNormal];
        [timeButton setTitleColor:COLORFROM16(0x2D9518, 1) forState:UIControlStateSelected];
        [timeButton addTarget:self action:@selector(respondsToTimeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:timeButton];
        
        [timeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf).multipliedBy(1.0 / weakSelf.timeTitleArray.count);
            make.height.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf);
            if (!i) {
                make.left.equalTo(weakSelf);
            } else {
                make.left.equalTo([weakSelf viewWithTag:199 + i].mas_right);
            }
        }];
    }
    
    [self addSubview:self.bottomLineView];
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.openLabel];
    [self.boxView addSubview:self.heightLabel];
    [self.boxView addSubview:self.lowLabel];
    [self.boxView addSubview:self.incomeLabel];
    [self.boxView addSubview:self.amountLabel];
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(14));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo([weakSelf viewWithTag:200 + self.currentSelectedIndex]);
        make.bottom.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(3));
    }];
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf);
        make.center.equalTo(weakSelf);
    }];
    [self.openLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.boxView);
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(6));
        make.centerY.equalTo(weakSelf);
    }];
    [self.heightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.openLabel);
        make.left.equalTo(weakSelf.openLabel.mas_right);
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.lowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.openLabel);
        make.left.equalTo(weakSelf.heightLabel.mas_right);
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.incomeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.openLabel);
        make.left.equalTo(weakSelf.lowLabel.mas_right);
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.openLabel);
        if ([[DBHLanguageTool sharedInstance].language isEqualToString:CNS]) {
            make.width.equalTo(weakSelf.openLabel);
        } else {
            make.width.equalTo(weakSelf.openLabel).offset(AUTOLAYOUTSIZE(25));
        }
        make.left.equalTo(weakSelf.incomeLabel.mas_right);
        make.centerY.equalTo(weakSelf.boxView);
        make.right.equalTo(weakSelf.boxView).offset(-AUTOLAYOUTSIZE(6));
    }];
}

#pragma mark ------ Event Responds ------
/**
 选择时间
 */
- (void)respondsToTimeButton:(UIButton *)timeButton {
    if (timeButton.tag - 200 == self.currentSelectedIndex) {
        return;
    }
    
    self.clickTimeBlock(self.timeValueArray[timeButton.tag - 200]);
    
    UIButton *lastSelectedButton = [self viewWithTag:200 + self.currentSelectedIndex];
    lastSelectedButton.selected = NO;
    
    timeButton.selected = YES;
    self.currentSelectedIndex = timeButton.tag - 200;
    
    WEAKSELF
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(14));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo([weakSelf viewWithTag:200 + self.currentSelectedIndex]);
        make.bottom.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(3));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

#pragma mark ------ Public Methods ------
- (void)clickTimeBlock:(ClickTimeBlock)clickTimeBlock {
    self.clickTimeBlock = clickTimeBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setIsShowData:(BOOL)isShowData {
    _isShowData = isShowData;
    
    self.boxView.hidden = !_isShowData;
 }
- (void)setModel:(DBHMarketDetailKLineViewModelData *)model {
    _model = model;
    
    NSString *openStr = [NSString stringWithFormat:@"%@%0.2f", OPEN, _model.openedPrice.doubleValue];
    NSString *maxStr = [NSString stringWithFormat:@"%@%0.2f", HIGH, _model.maxPrice.doubleValue];
    NSString *minStr = [NSString stringWithFormat:@"%@%0.2f", LOW, _model.minPrice.doubleValue];
    NSString *closeStr = [NSString stringWithFormat:@"%@%0.2f", CLOSE, _model.closedPrice.doubleValue];
    NSString *volumeStr = [NSString stringWithFormat:@"%@%0.2f", VOLUME, _model.volume.doubleValue];
    
    self.openLabel.text = openStr;
    self.heightLabel.text = maxStr;
    self.lowLabel.text = minStr;
    self.incomeLabel.text = closeStr;
    self.amountLabel.text = volumeStr;
    
//    NSString *openString = [NSString stringWithFormat:@"%.2lf", _model.openedPrice.doubleValue];
//    NSMutableAttributedString *openAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", DBHGetStringWithKeyFromTable(@"Open", nil), openString]];
//    [openAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0x333333, 1) range:NSMakeRange(3, openString.length)];
    
//    NSString *heightString = [NSString stringWithFormat:@"%.2lf", _model.maxPrice.doubleValue];
//    NSMutableAttributedString *heightAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",DBHGetStringWithKeyFromTable(@"Max", nil), heightString]];
//    [heightAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0x333333, 1)  range:NSMakeRange(3, heightString.length)];
    
//    NSString *lowString = [NSString stringWithFormat:@"%.2lf", _model.minPrice.doubleValue];
//    NSMutableAttributedString *lowAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", DBHGetStringWithKeyFromTable(@"Min", nil), lowString]];
//    [lowAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0x333333, 1)  range:NSMakeRange(3, lowString.length)];
    
//    NSString *incomeString = [NSString stringWithFormat:@"%.2lf", _model.closedPrice.doubleValue];
//    NSMutableAttributedString *incomeAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", DBHGetStringWithKeyFromTable(@"Close", nil), incomeString]];
//    [incomeAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0x333333, 1)  range:NSMakeRange(3, incomeString.length)];
    
//    NSString *amountString = [NSString stringWithFormat:@"%.2lf", _model.volume.doubleValue];
//    NSMutableAttributedString *amountAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", DBHGetStringWithKeyFromTable(@"Volume", nil), amountString]];
//    [amountAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0x333333, 1)  range:NSMakeRange(3, amountString.length)];
    
//    self.openLabel.attributedText = openAttributedString;
//    self.heightLabel.attributedText = heightAttributedString;
//    self.lowLabel.attributedText = lowAttributedString;
//    self.incomeLabel.attributedText = incomeAttributedString;
//    self.amountLabel.attributedText = amountAttributedString;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
        _boxView.hidden = YES;
    }
    return _boxView;
}
- (UILabel *)openLabel {
    if (!_openLabel) {
        _openLabel = [[UILabel alloc] init];
        _openLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _openLabel.textColor = COLORFROM16(0x333333, 1);
        _openLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    return _openLabel;
}
- (UILabel *)heightLabel {
    if (!_heightLabel) {
        _heightLabel = [[UILabel alloc] init];
        _heightLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _heightLabel.textColor = COLORFROM16(0x333333, 1);
        _heightLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    return _heightLabel;
}
- (UILabel *)lowLabel {
    if (!_lowLabel) {
        _lowLabel = [[UILabel alloc] init];
        _lowLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _lowLabel.textColor = COLORFROM16(0x333333, 1);
        _lowLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    return _lowLabel;
}
- (UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _incomeLabel.textColor = COLORFROM16(0x333333, 1);
        _incomeLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    return _incomeLabel;
}
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:AUTOLAYOUTSIZE(11)];
        _amountLabel.textColor = COLORFROM16(0x333333, 1);
        _amountLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    return _amountLabel;
}
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0x2D9518, 1);
    }
    return _bottomLineView;
}

- (NSArray *)timeTitleArray {
    if (!_timeTitleArray) {
        _timeTitleArray = @[@"1min",
                            @"5min",
                            @"15min",
                            @"30min",
                            @"1 hour",
                            @"1 Day",
                            @"1 Week"];
    }
    return _timeTitleArray;
}
- (NSArray *)timeValueArray {
    if (!_timeValueArray) {
        _timeValueArray = @[@"1m",
                            @"5m",
                            @"15m",
                            @"30m",
                            @"1h",
                            @"1d",
                            @"1w"];
    }
    return _timeValueArray;
}

@end
