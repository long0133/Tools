//
//  DBHInputView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInputView.h"

#import "DBHInputMenuButton.h"

@interface DBHInputView ()

@property (nonatomic, strong) UIButton *keyboardButton;

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;

@end

@implementation DBHInputView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0xDEDEDE, 1);
        
//        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
//    [self addSubview:self.keyboardButton];
//
//    WEAKSELF
//    [self.keyboardButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(AUTOLAYOUTSIZE(43.5));
//        make.height.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(0.5));
//        make.left.equalTo(weakSelf);
//        make.top.offset(AUTOLAYOUTSIZE(0.5));
//    }];
}

#pragma mark ------ Event Responds ------
/**
 子菜单选择
 */
- (void)respondsToTypeButton:(UIButton *)sender {
    self.clickButtonBlock(sender.tag - 200);
}

#pragma mark ------ Public Methods ------
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock {
    self.clickButtonBlock = clickButtonBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    for (NSInteger i = 0; i < _dataSource.count; i++) {
        DBHInputMenuButton *menuButton = [DBHInputMenuButton buttonWithType:UIButtonTypeCustom];
        menuButton.tag = 201 + i;
        menuButton.value = _dataSource[i][VALUE];
        menuButton.isMore = [_dataSource[i][@"isMore"] isEqualToString:@"1"];
        [menuButton addTarget:self action:@selector(respondsToTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:menuButton];
        
        WEAKSELF
        [menuButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.offset((SCREENWIDTH /*- AUTOLAYOUTSIZE(43.5)*/ - AUTOLAYOUTSIZE(0.5) * _dataSource.count) / _dataSource.count);
            make.height.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(0.5));
//            make.left.equalTo(!i ? weakSelf.keyboardButton.mas_right : [self viewWithTag:200 + i].mas_right).offset(AUTOLAYOUTSIZE(0.5));
            if (!i) {
                make.left.equalTo(weakSelf);
            } else {
                make.left.equalTo([self viewWithTag:200 + i].mas_right).offset(AUTOLAYOUTSIZE(0.5));
            }
//            make.centerY.equalTo(weakSelf.keyboardButton);
            make.top.offset(AUTOLAYOUTSIZE(0.5));
        }];
    }
}

- (UIButton *)keyboardButton {
    if (!_keyboardButton) {
        _keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _keyboardButton.tag = 200;
        _keyboardButton.backgroundColor = COLORFROM10(249, 249, 249, 1);
        [_keyboardButton setImage:[UIImage imageNamed:@"xiangmuzhuye_jianpan"] forState:UIControlStateNormal];
        [_keyboardButton addTarget:self action:@selector(respondsToTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keyboardButton;
}

@end
