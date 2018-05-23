//
//  DBHBaseTableViewCell.m
//  Trinity
//
//  Created by 邓毕华 on 2017/12/26.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@interface DBHBaseTableViewCell ()

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation DBHBaseTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addBottomLineView];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)addBottomLineView {
    [self.contentView addSubview:self.bottomLineView];
    
    WEAKSELF
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setIsHideBottomLineView:(BOOL)isHideBottomLineView {
    _isHideBottomLineView = isHideBottomLineView;
    
    self.bottomLineView.hidden = _isHideBottomLineView;
}
- (void)setBottomLineWidth:(CGFloat)bottomLineWidth {
    _bottomLineWidth = bottomLineWidth;
    
    WEAKSELF
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(_bottomLineWidth);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.bottom.equalTo(weakSelf.contentView);
    }];
}
- (void)setBottomLineViewColor:(UIColor *)bottomLineViewColor {
    _bottomLineViewColor = bottomLineViewColor;
    
    self.bottomLineView.backgroundColor = _bottomLineViewColor;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _bottomLineView;
}

@end
