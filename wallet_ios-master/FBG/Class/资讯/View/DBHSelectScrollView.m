//
//  DBHSelectScrollView.m
//  FBG
//
//  Created by yy on 2018/3/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSelectScrollView.h"

#define kButtonHeight 48
#define kButtonWidth 60

#define kLineWidth 16
#define kLineHeight 2

@interface DBHSelectScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *botLineView;

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DBHSelectScrollView

- (DBHSelectScrollView *)initWithTitles:(NSArray *)titles currentSelectedIndex:(NSInteger)selectedIndex {
    if (self = [super init]) {
        [self setUI];
        
        self.titles = titles;
        self.currentSelectedIndex = selectedIndex;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUI]; 
    }
    return self;
}

#pragma mark ------ set UI ------
- (void)setUI {
    [self addSubview:self.topLineView];
    WEAKSELF
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.width.equalTo(weakSelf);
        make.height.offset(0.5);
    }];
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLineView.mas_bottom);
        make.width.centerX.equalTo(weakSelf);
    }];
    
    [self addSubview:self.botLineView];
    [self.botLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView.mas_bottom);
        make.centerX.bottom.width.equalTo(weakSelf);
        make.height.offset(0.5);
    }];
}

- (void)scrollToIndex:(NSInteger)index {
    UIButton *lastSelectedButton = [self viewWithTag:TITLEVIEW_TAG_START + self.currentSelectedIndex];
    lastSelectedButton.selected = NO;
    
    UIButton *sender = [self viewWithTag:TITLEVIEW_TAG_START + index];
    sender.selected = YES;
    self.currentSelectedIndex = index;
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(kLineWidth));
        make.height.offset(AUTOLAYOUTSIZE(kLineHeight));
        make.centerX.equalTo(sender);
        make.top.equalTo(sender.mas_bottom).offset(-AUTOLAYOUTSIZE(8));
    }];
    
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

- (void)respondsToButton:(UIButton *)sender {
    if (sender.tag - TITLEVIEW_TAG_START == self.currentSelectedIndex) {
        return;
    }
    
    [self scrollToIndex:sender.tag - TITLEVIEW_TAG_START];
    
//    UIButton *lastSelectedButton = [self viewWithTag:TITLEVIEW_TAG_START + self.currentSelectedIndex];
//    lastSelectedButton.selected = NO;
//
//    sender.selected = YES;
//    self.currentSelectedIndex = sender.tag - TITLEVIEW_TAG_START;
//
//    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(AUTOLAYOUTSIZE(kLineWidth));
//        make.height.offset(AUTOLAYOUTSIZE(kLineHeight));
//        make.centerX.equalTo(sender);
//        make.top.equalTo(sender.mas_bottom).offset(-AUTOLAYOUTSIZE(8));
//    }];
//
//    WEAKSELF
//    [UIView animateWithDuration:0.25 animations:^{
//        [weakSelf layoutIfNeeded];
//    }];
    
    if (self.selectedBlock) {
        self.selectedBlock((int)self.currentSelectedIndex);
    }
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    [self addOtherSubViews];
}

- (void)setTopLineColor:(UIColor *)topLineColor {
    _topLineColor = topLineColor;
    _topLineView.backgroundColor = topLineColor;
}

- (void)addOtherSubViews {
    for (int i = 0; i < self.titles.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = TITLEVIEW_TAG_START + i;
        
        [button setTitle:DBHGetStringWithKeyFromTable(self.titles[i], nil) forState:UIControlStateNormal];
        button.titleLabel.font = FONT(15);
        [button setTitleColor:COLORFROM16(0x8B8B8B, 1) forState:UIControlStateNormal];
        [button setTitleColor:COLORFROM16(0xF46A00, 1) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:button];
        WEAKSELF
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!i) {
                make.left.offset(AUTOLAYOUTSIZE(12));
            } else {
                make.left.equalTo([weakSelf viewWithTag:TITLEVIEW_TAG_START - 1 + i].mas_right).offset(AUTOLAYOUTSIZE(25));
            }
            make.top.equalTo(weakSelf);
            CGFloat width = [self.titles[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(15)} context:nil].size.width;
            make.width.offset(AUTOLAYOUTSIZE(width + 14));
            make.height.offset(AUTOLAYOUTSIZE(kButtonHeight));
        }];
        
        [self.scrollView addSubview:self.bottomLineView];
        if (i == self.currentSelectedIndex) {
            button.selected = YES;
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(AUTOLAYOUTSIZE(kLineWidth));
                make.height.offset(AUTOLAYOUTSIZE(kLineHeight));
                make.centerX.equalTo(button);
                make.top.equalTo(button.mas_bottom).offset(-AUTOLAYOUTSIZE(8));
            }];
        }
        
        if (i == self.titles.count - 1) {
            [self layoutIfNeeded];
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), 1);
        }
    }
}

#pragma mark ------ Getters and setters ------
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _topLineView;
}

- (UIView *)botLineView {
    if (!_botLineView) {
        _botLineView = [[UIView alloc] init];
        _botLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _botLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.layer.cornerRadius = AUTOLAYOUTSIZE(1);
        _bottomLineView.backgroundColor = COLORFROM16(0xFF6806, 1);
    }
    return _bottomLineView;
}

- (void)setBackgroundViewColor:(UIColor *)backgroundViewColor {
    _backgroundViewColor = backgroundViewColor;
    
    self.scrollView.backgroundColor = backgroundViewColor;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = COLORFROM16(0xFFFFFF, 1);
        
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end

