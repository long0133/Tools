//
//  DBHChangePasswordTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHChangePasswordTableViewCell.h"

@interface DBHChangePasswordTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *showPasswordButton;

@property (nonatomic, copy) GetVerificationCodeBlock getVerificationCodeBlock;

@end

@implementation DBHChangePasswordTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueTextField];
    [self.contentView addSubview:self.showPasswordButton];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.valueTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(140));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.height.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.showPasswordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(34.5));
        make.height.equalTo(weakSelf.valueTextField);
        make.right.offset(- AUTOLAYOUTSIZE(25));
        make.centerY.equalTo(weakSelf.valueTextField);
    }];
}

#pragma mark ------ Event Responds ------
/**
 显示/隐藏密码
 */
- (void)respondsToShowPasswordButton:(UIButton *)button {
    button.selected = !button.selected;
    self.getVerificationCodeBlock(button.isSelected);
}

#pragma mark ------ Public Methods ------
- (void)getVerificationCodeBlock:(GetVerificationCodeBlock)getVerificationCodeBlock {
    self.getVerificationCodeBlock = getVerificationCodeBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(_title, nil);
    self.showPasswordButton.hidden = ![_title isEqualToString:@"New Password"];
    
    WEAKSELF
    if (self.showPasswordButton.hidden) {
        [self.valueTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(AUTOLAYOUTSIZE(140));
            make.right.offset(- AUTOLAYOUTSIZE(15));
            make.height.equalTo(weakSelf.contentView);
            make.centerY.equalTo(weakSelf.contentView);
        }];
    } else {
        [self.valueTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(AUTOLAYOUTSIZE(140));
            make.right.equalTo(weakSelf.showPasswordButton.mas_left);
            make.height.equalTo(weakSelf.contentView);
            make.centerY.equalTo(weakSelf.contentView);
        }];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(13);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UITextField *)valueTextField {
    if (!_valueTextField) {
        _valueTextField = [[UITextField alloc] init];
        _valueTextField.font = FONT(13);
        _valueTextField.textColor = COLORFROM16(0x333333, 1);
        _valueTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _valueTextField.secureTextEntry = YES;
    }
    return _valueTextField;
}
- (UIButton *)showPasswordButton {
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPasswordButton setImage:[UIImage imageNamed:@"denglu_eyes_close"] forState:UIControlStateNormal];
        [_showPasswordButton setImage:[UIImage imageNamed:@"denglu_eyes_open"] forState:UIControlStateSelected];
        [_showPasswordButton addTarget:self action:@selector(respondsToShowPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}

@end
