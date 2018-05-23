//
//  DBHInformationTitleView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInformationTitleView.h"

@interface DBHInformationTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIImageView *searchImageView;

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;

@end

@implementation DBHInformationTitleView

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.searchButton];
    [self addSubview:self.searchImageView];
    [self addSubview:self.moreButton];
}

#pragma mark ------ Event Responds ------
/**
 搜索
 */
- (void)respondsToSearchButton {
    self.clickButtonBlock(0);
}
/**
 +号按钮
 */
- (void)respondsToMoreButton {
    self.clickButtonBlock(1);
}

#pragma mark ------ Public Methods ------
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock {
    self.clickButtonBlock = clickButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AUTOLAYOUTSIZE(7), 0, [@"InWeCrypto" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:BOLDFONT(20)} context:nil].size.width, 40)];
        _titleLabel.font = BOLDFONT(20);
        _titleLabel.text = @"InWeCrypto";
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + AUTOLAYOUTSIZE(13),
                                         (CGRectGetHeight(self.frame) - AUTOLAYOUTSIZE(30)) * 0.5,
                                         CGRectGetMinX(self.moreButton.frame) - CGRectGetMaxX(self.titleLabel.frame) - AUTOLAYOUTSIZE(13), AUTOLAYOUTSIZE(30));
        _searchButton.backgroundColor = LIGHT_WHITE_BGCOLOR;
        _searchButton.layer.cornerRadius = AUTOLAYOUTSIZE(15);
        [_searchButton addTarget:self action:@selector(respondsToSearchButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}
- (UIImageView *)searchImageView {
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhuye_sousuo_ico"]];
        _searchImageView.frame = CGRectMake(CGRectGetMinX(self.searchButton.frame) + AUTOLAYOUTSIZE(10), (CGRectGetHeight(self.frame) - AUTOLAYOUTSIZE(10)) * 0.5, AUTOLAYOUTSIZE(10), AUTOLAYOUTSIZE(10));
    }
    return _searchImageView;
}

- (BOOL)isReview {
    return [[NSUserDefaults standardUserDefaults] boolForKey:CHECK_STATUS];
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat x = CGRectGetWidth(self.frame) - AUTOLAYOUTSIZE(55);
        CGFloat width = AUTOLAYOUTSIZE(39);
        if ([self isReview]) {
            x = x + width - AUTOLAYOUTSIZE(7);
            _moreButton.hidden = YES;
        } else {
            _moreButton.hidden = NO;
        }
        _moreButton.frame = CGRectMake(x, 0, width, 40);
        [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
        _moreButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_moreButton setImage:[UIImage imageNamed:@"zhuye_right_icon"] forState:UIControlStateNormal]; //  zhuye_tianjia_ico
        [_moreButton addTarget:self action:@selector(respondsToMoreButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
