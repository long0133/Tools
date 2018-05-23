//
//  DBHCandyBowlHeaderView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCandyBowlHeaderView.h"

#import "Daysquare.h"

@interface DBHCandyBowlHeaderView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *boxImageView;
@property (nonatomic, strong) DAYCalendarView *calendarView;
@property (nonatomic, strong) UILabel* dateLabel;
@property (nonatomic, strong) UILabel *noCandyBowlLabel;

@property (nonatomic, copy) MonthChangeBlock monthChangeBlock;
@property (nonatomic, copy) SelectedDateBlock selectedDateBlock;

@end

@implementation DBHCandyBowlHeaderView

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.backImageView];
    [self addSubview:self.boxImageView];
    [self addSubview:self.calendarView];
    [self addSubview:self.dateLabel];
    [self addSubview:self.noCandyBowlLabel];
    
    WEAKSELF
    [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(192.5));
        make.centerX.top.equalTo(weakSelf);
    }];
    [self.boxImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(64));
        make.height.offset(AUTOLAYOUTSIZE(288));
        make.centerX.equalTo(weakSelf);
        make.top.offset(AUTOLAYOUTSIZE(48.5));
    }];
    [self.calendarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxImageView).offset(- AUTOLAYOUTSIZE(30));
        make.centerX.equalTo(weakSelf.boxImageView);
        make.top.equalTo(weakSelf.boxImageView).offset(AUTOLAYOUTSIZE(14.5));
        make.bottom.equalTo(weakSelf.boxImageView).offset(- AUTOLAYOUTSIZE(27));
    }];
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.boxImageView);
        make.bottom.offset(- AUTOLAYOUTSIZE(12));
    }];
    [self.noCandyBowlLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.dateLabel.mas_bottom).offset(AUTOLAYOUTSIZE(7));
    }];
}

#pragma mark ------ Event Responds ------
/**
 日历选中日期更改
 */
- (void)calendarViewDidChange:(DAYCalendarView *)calendarView {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    self.dateLabel.text = [dateFormatter stringFromDate:calendarView.selectedDate];
    self.selectedDateBlock(calendarView.selectedDate);
}

#pragma mark ------ Public Methods ------
- (void)selectedDateBlock:(SelectedDateBlock)selectedDateBlock {
    self.selectedDateBlock = selectedDateBlock;
}
- (void)monthChangeBlock:(MonthChangeBlock)monthChangeBlock {
    self.monthChangeBlock = monthChangeBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setMonthArray:(NSArray *)monthArray {
    _monthArray = monthArray;
    
    self.calendarView.monthArray = [_monthArray copy];
}
- (void)setIsNoData:(BOOL)isNoData {
    _isNoData = isNoData;
    
    self.noCandyBowlLabel.hidden = !_isNoData;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"candyzhuye_beijing"]];
    }
    return _backImageView;
}
- (UIImageView *)boxImageView {
    if (!_boxImageView) {
        _boxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"candyzhuye_rilikuang"]];
    }
    return _boxImageView;
}
- (DAYCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[DAYCalendarView alloc] init];
        _calendarView.weekdayHeaderTextColor = COLORFROM16(0x121212, 1);
        _calendarView.weekdayHeaderWeekendTextColor = COLORFROM16(0x121212, 1);
        _calendarView.highlightedComponentTextColor = COLORFROM16(0xFFFFFF, 1);
        _calendarView.selectedIndicatorColor = COLORFROM16(0xFF7800, 1);
        _calendarView.indicatorRadius = AUTOLAYOUTSIZE(13);
        _calendarView.boldPrimaryComponentText = NO;
        [_calendarView addTarget:self action:@selector(calendarViewDidChange:) forControlEvents:UIControlEventValueChanged];
        
        WEAKSELF
        [_calendarView monthChangeBlock:^{
            weakSelf.monthChangeBlock();
        }];
    }
    return _calendarView;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [ [UILabel alloc] init];
        _dateLabel.font = BOLDFONT(20);
        _dateLabel.textColor = COLORFROM16(0x333333, 1);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd"];
        _dateLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    }
    return _dateLabel;
}
- (UILabel *)noCandyBowlLabel {
    if (!_noCandyBowlLabel) {
        _noCandyBowlLabel = [ [UILabel alloc] init];
        _noCandyBowlLabel.font = FONT(13);
        _noCandyBowlLabel.text = DBHGetStringWithKeyFromTable(@"No CandyBowl", nil);
        _noCandyBowlLabel.textColor = COLORFROM16(0x939393, 1);
        _noCandyBowlLabel.hidden = YES;
    }
    return _noCandyBowlLabel;
}

@end
