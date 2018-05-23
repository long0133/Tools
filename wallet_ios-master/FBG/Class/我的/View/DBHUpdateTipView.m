
//
//  DBHUpdateTipView.m
//  FBG
//
//  Created by yy on 2018/3/21.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHUpdateTipView.h"

@interface DBHUpdateTipView()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, assign) CGFloat bgHeight;
@property (nonatomic, copy) NSString *downloadURL;

@end

@implementation DBHUpdateTipView


#pragma mark ------ Lifecycle ------
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0x000000, 0.4);
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ Set UI ------
- (void)setUI {
    [self addSubview:self.bgView];
    WEAKSELF
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).offset(-AUTOLAYOUTSIZE(50));
        make.top.equalTo(weakSelf.mas_bottom);
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(@(AUTOLAYOUTSIZE(120)));
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(AUTOLAYOUTSIZE(20));
        make.width.equalTo(weakSelf.bgView).offset(-AUTOLAYOUTSIZE(50));
        make.centerX.equalTo(weakSelf.bgView);
        make.height.equalTo(@(AUTOLAYOUTSIZE(40)));
    }];
    
    [self.bgView addSubview:self.contentLabel];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.centerX.equalTo(weakSelf.bgView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(6));
        make.height.equalTo(@(AUTOLAYOUTSIZE(40)));
    }]; // 设置content后需要重新设置位置
    
    [self.bgView addSubview:self.cancelBtn];
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(25));
        make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(AUTOLAYOUTSIZE(40));
        make.height.equalTo(@(AUTOLAYOUTSIZE(44)));
        make.bottom.equalTo(weakSelf.bgView).offset(-AUTOLAYOUTSIZE(20));
    }];
    
    [self.bgView addSubview:self.okBtn];
    [self.okBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.cancelBtn.mas_right).offset(AUTOLAYOUTSIZE(40));
        make.height.width.centerY.equalTo(weakSelf.cancelBtn);
        make.right.offset(-AUTOLAYOUTSIZE(25));
    }];
}
#pragma mark ------ respondsToSelector ------
- (void)respondsToCancelBtn {
    [self animationHide];
}

- (void)respondsToOKBtn {
    [self animationHide];
    
    NSString *tempUrl = [self.downloadURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempUrl]];
}

- (void)animationHide {
    WEAKSELF
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).offset(-AUTOLAYOUTSIZE(50));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_bottom);
        make.height.equalTo(@(AUTOLAYOUTSIZE(self.bgHeight)));
    }];
    
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)animationShow {
    WEAKSELF
    [self layoutIfNeeded];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).offset(-AUTOLAYOUTSIZE(50));
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.height.equalTo(@(AUTOLAYOUTSIZE(self.bgHeight)));
    }];

    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

- (void)setTipString:(NSString *)tipStr isForce:(BOOL)isForceUpdate downloadUrl:(NSString *)downloadUrl {
    self.contentLabel.text = tipStr;
    self.downloadURL = downloadUrl;
    
   CGFloat height = [NSString getHeightWithString:tipStr width:CGRectGetWidth(self.bgView.frame) - AUTOLAYOUTSIZE(50) lineSpacing:0 fontSize:14] + 30;
    _bgHeight = height + 170;
    WEAKSELF
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.centerX.equalTo(weakSelf.bgView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(6));
        make.height.equalTo(@(AUTOLAYOUTSIZE(height)));
    }];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf).offset(-AUTOLAYOUTSIZE(50));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_bottom);
        make.height.equalTo(@(AUTOLAYOUTSIZE(self.bgHeight)));
    }];
    
    if (isForceUpdate) {
        self.cancelBtn.hidden = YES;
        [self.okBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(AUTOLAYOUTSIZE(25));
            make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(AUTOLAYOUTSIZE(40));
            make.height.equalTo(@(AUTOLAYOUTSIZE(44)));
            make.centerX.equalTo(weakSelf.bgView);
            make.bottom.equalTo(weakSelf.bgView).offset(-AUTOLAYOUTSIZE(20));
        }];
    }
}

#pragma mark ------ Getters and setters ------
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = WHITE_COLOR;
        
        _bgView.layer.cornerRadius = AUTOLAYOUTSIZE(5);
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(16);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
        _titleLabel.numberOfLines = 0;
        
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"Update Tip", nil);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT(14);
        _contentLabel.textColor = COLORFROM16(0x333333, 1);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [_cancelBtn setTitle:DBHGetStringWithKeyFromTable(@"Cancel", nil) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(respondsToCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = FONT(14);
        [_cancelBtn setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:COLORFROM16(0xF6F6F6, 1)];
        [_cancelBtn setBorderWidth:1.0f color:COLORFROM16(0xF6F6F6, 1)];
        
    }
    return _cancelBtn;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [_okBtn setTitle:DBHGetStringWithKeyFromTable(@"Update", nil) forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(respondsToOKBtn) forControlEvents:UIControlEventTouchUpInside];
        _okBtn.titleLabel.font = FONT(14);
        [_okBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        
        [_okBtn setBackgroundColor:MAIN_ORANGE_COLOR];
        
        [_okBtn setBorderWidth:1.0f color:MAIN_ORANGE_COLOR];
        
    }
    return _okBtn;
}

@end
