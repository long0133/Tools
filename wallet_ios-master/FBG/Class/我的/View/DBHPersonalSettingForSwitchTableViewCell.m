//
//  DBHPersonalSettingForSwitchTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHPersonalSettingForSwitchTableViewCell.h"

#import <HyphenateLite/HyphenateLite.h>

@interface DBHPersonalSettingForSwitchTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *onSwitch;

@property (nonatomic, copy) ChangeSwitchBlock changeSwitchBlock;

@end

@implementation DBHPersonalSettingForSwitchTableViewCell

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
    [self.contentView addSubview:self.onSwitch];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.onSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

#pragma mark ------ Event Responds ------
- (void)respondsToOnSwitch {
    // 功能组件推送配置
    if (_functionalUnitType >= 0) {
        [UserSignData share].user.realTimeDeliveryArray[_functionalUnitType] = self.onSwitch.isOn ? @"1" : @"0";
        [[UserSignData share] storageData:[UserSignData share].user];        
    }
    if (![UserSignData share].user.isLogin) {
        self.onSwitch.on = NO;
        [[AppDelegate delegate] goToLoginVC:[self parentController]];
    } else {
        self.changeSwitchBlock(self.onSwitch.isOn);
    }
}

#pragma mark ------ Public Methods ------
- (void)changeSwitchBlock:(ChangeSwitchBlock)changeSwitchBlock {
    self.changeSwitchBlock = changeSwitchBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setFunctionalUnitType:(NSInteger)functionalUnitType {
    _functionalUnitType = functionalUnitType;
    
    if (_functionalUnitType < 0) {
        return;
    }
    self.onSwitch.on = [[UserSignData share].user.realTimeDeliveryArray[_functionalUnitType] isEqualToString:@"1"];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(_title, nil);
}
- (void)setIsStick:(BOOL)isStick {
    _isStick = isStick;
    
    self.onSwitch.on = _isStick;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(13);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UISwitch *)onSwitch {
    if (!_onSwitch) {
        _onSwitch = [[UISwitch alloc] init];
        _onSwitch.onTintColor = COLORFROM16(0xF46A00, 1);
        _onSwitch.backgroundColor = COLORFROM16(0xBFBFBF, 1);
        _onSwitch.layer.cornerRadius = AUTOLAYOUTSIZE(16);
        _onSwitch.clipsToBounds = YES;
        [_onSwitch addTarget:self action:@selector(respondsToOnSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _onSwitch;
}

@end
