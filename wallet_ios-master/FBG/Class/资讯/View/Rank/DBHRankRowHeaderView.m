//
//  DBHRankRowHeaderView.m
//  FBG
//
//  Created by yy on 2018/3/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHRankRowHeaderView.h"


@interface DBHRankRowHeaderView()

/**
 显示的标题
 */
@property (nonatomic, strong) NSString *titleStr;

/**
 是否可以点击
 */
@property (nonatomic, assign) BOOL isCanClick;

/**
 是否显示右侧的竖线
 */
@property (nonatomic, assign) BOOL isShowLine;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation DBHRankRowHeaderView

#pragma mark ------ Lifecycle ------
- (DBHRankRowHeaderView *)initWithFrame:(CGRect)frame title:(NSString *)titleStr isCanClick:(BOOL)isCanClick isShowLine:(BOOL)isShowLine index:(NSInteger)index isFirst:(BOOL)isFirst {
    if (self = [super initWithFrame:frame]) {
        self.titleStr = titleStr;
        self.isCanClick = isCanClick;
        self.isShowLine = isShowLine;
        self.index = index;
        self.isFirst = isFirst;
        [self setUI];
    }
    return self;
}

- (void)respondsToButtonClicked:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    self.backgroundColor = COLORFROM16(0xF8F8F8, 1);
    [self addSubview:self.button];
    
    if (self.isShowLine) {
        [self addSubview:self.lineView];
    }
}

- (void)setSelected:(BOOL)selected ordered:(NSInteger)ordered {
    self.button.selected = selected;
    
    if (ordered == 0) {
        return;
    }
    [self.button setImage:[UIImage imageNamed:ordered == 1 ? @"paixu_icon_as" : @"paixu_icon_des"] forState:UIControlStateSelected];
}
    
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *title = DBHGetStringWithKeyFromTable(self.titleStr, nil);
        [_button setTitle:title forState:UIControlStateNormal];
        
        _button.titleLabel.font = FONT(BUTTON_FONT_SIZE);
        _button.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        if (self.index == 4) {
            if (self.isFirst) {
                _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                _button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 10);
            } else {
                _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                _button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 20);
            }
        }
        
        _button.userInteractionEnabled = self.isCanClick;
        [_button setTitleColor:COLORFROM16(0x5F9E86, 1) forState:UIControlStateNormal];
        
        if (self.isCanClick) {
            [_button setImage:[UIImage imageNamed:@"paixu_icon"] forState:UIControlStateNormal];
            _button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            CGFloat value = AUTOLAYOUTSIZE(15);
            [_button setImageEdgeInsets:UIEdgeInsetsMake(value, 0, value, AUTOLAYOUTSIZE(5))];
            
            [_button addTarget:self action:@selector(respondsToButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _button;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        
        CGFloat width = AUTOLAYOUTSIZE(1);
        _lineView.frame = CGRectMake(CGRectGetMaxX(self.frame) - width, 0, width, CGRectGetHeight(self.frame));
        _lineView.backgroundColor = COLORFROM16(0xF3F3F3, 1);
    }
    return _lineView;
}

@end
