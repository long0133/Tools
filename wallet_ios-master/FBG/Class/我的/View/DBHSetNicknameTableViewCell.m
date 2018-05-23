//
//  DBHSetNicknameTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSetNicknameTableViewCell.h"

@implementation DBHSetNicknameTableViewCell

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
    [self.contentView addSubview:self.nicknameTextField];
    
    WEAKSELF
    [self.nicknameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (UITextField *)nicknameTextField {
    if (!_nicknameTextField) {
        _nicknameTextField = [[UITextField alloc] init];
        _nicknameTextField.font = FONT(15);
        _nicknameTextField.text = [UserSignData share].user.nickname;
        _nicknameTextField.textColor = COLORFROM16(0x333333, 1);
        _nicknameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AUTOLAYOUTSIZE(15), 0)];
        _nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _nicknameTextField;
}

@end
