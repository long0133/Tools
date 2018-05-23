//
//  DBHSelectFaceOrTouchViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSelectFaceOrTouchViewController.h"

@interface DBHSelectFaceOrTouchViewController ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *shortcutLoginLabel;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UIButton *nowOpenButton;
@property (nonatomic, strong) UIButton *noOpenButton;

@end

@implementation DBHSelectFaceOrTouchViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    self.navigationController.navigationItem.hidesBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.typeLabel];
    [self.view addSubview:self.shortcutLoginLabel];
    [self.view addSubview:self.boxView];
    [self.view addSubview:self.typeImageView];
    [self.view addSubview:self.nowOpenButton];
    [self.view addSubview:self.noOpenButton];
    
    WEAKSELF
    [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(73.5));
        make.right.bottom.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(173));
    }];
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(AUTOLAYOUTSIZE(2));
        make.left.offset(AUTOLAYOUTSIZE(35));
    }];
    [self.shortcutLoginLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.typeLabel);
        make.top.equalTo(weakSelf.typeLabel.mas_bottom).offset(AUTOLAYOUTSIZE(15));
    }];
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.shortcutLoginLabel.mas_bottom).offset(AUTOLAYOUTSIZE(10));
        make.bottom.equalTo(weakSelf.nowOpenButton.mas_top);
    }];
    [self.typeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(93));
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.boxView);
    }];
    [self.nowOpenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(70));
        make.height.offset(AUTOLAYOUTSIZE(39));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(214.5));
    }];
    [self.noOpenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(80));
        make.height.offset(AUTOLAYOUTSIZE(42.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.nowOpenButton.mas_bottom);
    }];
}

#pragma mark ------ Event Responds ------
/**
 现在开启
 */
- (void)respondsToNowOpenButton {
    [self.target dismissViewControllerAnimated:YES completion:nil];
    [UserSignData share].user.isOpenFaceId = self.faceOrTouchViewControllerType == DBHFaceViewControllerType;
    [UserSignData share].user.isOpenTouchId = self.faceOrTouchViewControllerType == DBHTouchViewControllerType;
    [[UserSignData share] storageData:[UserSignData share].user];
    [[AppDelegate delegate] goToTabbar];
}
/**
 暂不开启
 */
- (void)respondsToNoOpenButton {
    [self.target dismissViewControllerAnimated:YES completion:nil];
    [[AppDelegate delegate] goToTabbar];
}

#pragma mark ------ Getters And Setters ------
- (void)setFaceOrTouchViewControllerType:(DBHSelectFaceOrTouchViewControllerType)faceOrTouchViewControllerType {
    _faceOrTouchViewControllerType = faceOrTouchViewControllerType;
    
    self.typeLabel.text = [NSString stringWithFormat:@"%@%@", DBHGetStringWithKeyFromTable(@"Use", nil), _faceOrTouchViewControllerType == DBHTouchViewControllerType ? @"Touch ID" : @"Face ID"];
    self.typeImageView.image = [UIImage imageNamed:_faceOrTouchViewControllerType == DBHTouchViewControllerType ? @"denglu_zhiwen" : @"faceid"];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglu_bg"]];
    }
    return _backImageView;
}
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = BOLDFONT(25);
        _typeLabel.textColor = MAIN_ORANGE_COLOR;
    }
    return _typeLabel;
}
- (UILabel *)shortcutLoginLabel {
    if (!_shortcutLoginLabel) {
        _shortcutLoginLabel = [[UILabel alloc] init];
        _shortcutLoginLabel.font = BOLDFONT(25);
        _shortcutLoginLabel.text = DBHGetStringWithKeyFromTable(@"Quick Unlock", nil);
        _shortcutLoginLabel.textColor = MAIN_ORANGE_COLOR;
    }
    return _shortcutLoginLabel;
}
- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
    }
    return _boxView;
}
- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
    }
    return _typeImageView;
}
- (UIButton *)nowOpenButton {
    if (!_nowOpenButton) {
        _nowOpenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nowOpenButton.backgroundColor = MAIN_ORANGE_COLOR;
        _nowOpenButton.titleLabel.font = BOLDFONT(14);
        _nowOpenButton.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        _nowOpenButton.clipsToBounds = YES;
        
        [_nowOpenButton setTitle:DBHGetStringWithKeyFromTable(@"Use", nil) forState:UIControlStateNormal];
        [_nowOpenButton addTarget:self action:@selector(respondsToNowOpenButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nowOpenButton;
}
- (UIButton *)noOpenButton {
    if (!_noOpenButton) {
        _noOpenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _noOpenButton.titleLabel.font = BOLDFONT(12);
        [_noOpenButton setTitle:DBHGetStringWithKeyFromTable(@"No Now", nil) forState:UIControlStateNormal];
        [_noOpenButton setTitleColor:COLORFROM16(0x888888, 1) forState:UIControlStateNormal];
        [_noOpenButton addTarget:self action:@selector(respondsToNoOpenButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noOpenButton;
}

@end
