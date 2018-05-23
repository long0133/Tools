//
//  DBHSearchTypeView.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSearchTypeView.h"

@interface DBHSearchTypeView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *infomationButton;
@property (nonatomic, strong) UIButton *projectButton;

@property (nonatomic, copy) SelectedTypeBlock selectedTypeBlock;

@end

@implementation DBHSearchTypeView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.infomationButton];
    [self addSubview:self.projectButton];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.offset(AUTOLAYOUTSIZE(34));
    }];
    [self.infomationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(128));
        make.height.offset(AUTOLAYOUTSIZE(54));
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        make.right.equalTo(weakSelf.mas_centerX);
    }];
    [self.projectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.infomationButton);
        make.centerY.equalTo(weakSelf.infomationButton);
        make.left.equalTo(weakSelf.infomationButton.mas_right);
    }];
}

#pragma mark ------ Event Responds ------
/**
 类型选择
 */
- (void)respondsToTypeButton:(UIButton *)sender {
    NSInteger searchTag = self.infomationButton.isSelected ? 200 : 201;
    if (searchTag == sender.tag) {
        return;
    }
    
    self.infomationButton.selected = !self.infomationButton.isSelected;
    self.projectButton.selected = !self.infomationButton.isSelected;
    
    self.selectedTypeBlock(sender.tag - 200);
}

#pragma mark ------ Public Methods ------
- (void)selectedTypeBlock:(SelectedTypeBlock)selectedTypeBlock {
    self.selectedTypeBlock = selectedTypeBlock;
}

#pragma mark ------ Getters And Setters ------
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(13);
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"You want to search for content", nil);
        _titleLabel.textColor = COLORFROM16(0xACACAC, 1);
    }
    return _titleLabel;
}
- (UIButton *)infomationButton {
    if (!_infomationButton) {
        _infomationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _infomationButton.titleLabel.font = FONT(17);
        _infomationButton.tag = 200;
        _infomationButton.selected = YES;
        [_infomationButton setTitle:DBHGetStringWithKeyFromTable(@"News", nil) forState:UIControlStateNormal];
        [_infomationButton setTitleColor:COLORFROM16(0x9B9B9B, 1) forState:UIControlStateNormal];
        [_infomationButton setTitleColor:COLORFROM16(0x0A9234, 1) forState:UIControlStateSelected];
        [_infomationButton addTarget:self action:@selector(respondsToTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infomationButton;
}
- (UIButton *)projectButton {
    if (!_projectButton) {
        _projectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _projectButton.titleLabel.font = FONT(17);
        _projectButton.tag = 201;
        [_projectButton setTitle:DBHGetStringWithKeyFromTable(@"Project", nil) forState:UIControlStateNormal];
        [_projectButton setTitleColor:COLORFROM16(0x9B9B9B, 1) forState:UIControlStateNormal];
        [_projectButton setTitleColor:COLORFROM16(0x0A9234, 1) forState:UIControlStateSelected];
        [_projectButton addTarget:self action:@selector(respondsToTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _projectButton;
}

@end
