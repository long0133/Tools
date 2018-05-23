//
//  DBHUnLoginView.m
//  FBG
//
//  Created by yy on 2018/3/20.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHUnLoginView.h"

@interface DBHUnLoginView()

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *tipBtn;

@end

@implementation DBHUnLoginView

#pragma mark ------ Lifecycle ------
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = WHITE_COLOR;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.tipLabel];
    WEAKSELF
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.offset(AUTOLAYOUTSIZE(25));
        make.top.offset(AUTOLAYOUTSIZE(88));
    }];
    
    [self addSubview:self.tipBtn];
    [self.tipBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tipLabel.mas_bottom).offset(AUTOLAYOUTSIZE(16));
        make.height.equalTo(@(AUTOLAYOUTSIZE(44)));
        make.centerX.equalTo(weakSelf);
        make.left.offset(AUTOLAYOUTSIZE(60));
    }];
}

- (void)respondsToTipBtn {
    if (self.btnBlock) {
        self.btnBlock();
    }
}

- (void)setTipTitle:(NSString *)tipTitle {
    _tipTitle = tipTitle;
    
    self.tipLabel.text = DBHGetStringWithKeyFromTable(tipTitle, nil);
}

- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    
    [self.tipBtn setTitle:DBHGetStringWithKeyFromTable(btnTitle, nil) forState:UIControlStateNormal];
}

#pragma mark ------ Getters and setters ------
- (UIButton *)tipBtn {
    if (!_tipBtn) {
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_tipBtn setTitle:DBHGetStringWithKeyFromTable(@"Login / Register", nil) forState:UIControlStateNormal];
        [_tipBtn addTarget:self action:@selector(respondsToTipBtn) forControlEvents:UIControlEventTouchUpInside];
        _tipBtn.titleLabel.font = FONT(14);
        [_tipBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [_tipBtn setBackgroundColor:MAIN_ORANGE_COLOR];
        [_tipBtn setBorderWidth:1 color:MAIN_ORANGE_COLOR];
    }
    return _tipBtn;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = COLORFROM16(0xB1B1B1, 1);
        _tipLabel.font = FONT(13);
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = DBHGetStringWithKeyFromTable(@"Pay attention to the project of interest and check the progress of the project", nil);
    }
    return _tipLabel;
}
@end
