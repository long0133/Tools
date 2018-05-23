//
//  DBHTokenSaleConfirmationViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHTokenSaleConfirmationViewController.h"

@interface DBHTokenSaleConfirmationViewController ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *poundageLabel;
@property (nonatomic, strong) UILabel *originalPoundageLabel;
@property (nonatomic, strong) UILabel *collectionAddressLabel;
@property (nonatomic, strong) UILabel *collectionAddressValueLabel;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation DBHTokenSaleConfirmationViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DBHGetStringWithKeyFromTable(@"Token Sale Confirmation", nil);
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.unitLabel];
    [self.view addSubview:self.poundageLabel];
    [self.view addSubview:self.originalPoundageLabel];
    [self.view addSubview:self.collectionAddressLabel];
    [self.view addSubview:self.collectionAddressValueLabel];
    [self.view addSubview:self.grayLineView];
    [self.view addSubview:self.sureButton];
    
    WEAKSELF
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(47));
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.numberLabel.mas_right);
        make.bottom.equalTo(weakSelf.numberLabel).offset(- AUTOLAYOUTSIZE(5));
    }];
    [self.poundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(AUTOLAYOUTSIZE(8));
    }];
    [self.originalPoundageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.poundageLabel.mas_bottom).offset(AUTOLAYOUTSIZE(5));
    }];
    [self.collectionAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.bottom.equalTo(weakSelf.collectionAddressValueLabel.mas_top).offset(- AUTOLAYOUTSIZE(11.5));
    }];
    [self.collectionAddressValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.grayLineView);
        make.bottom.equalTo(weakSelf.grayLineView.mas_top).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(60));
        make.height.offset(AUTOLAYOUTSIZE(0.5));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.numberLabel.mas_bottom).offset(AUTOLAYOUTSIZE(150));
    }];
    [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.offset(- AUTOLAYOUTSIZE(47.5));
    }];
    
    self.numberLabel.text = @"1.0000000";
    self.unitLabel.text = @"（NEO）";
    self.poundageLabel.text = [NSString stringWithFormat:@"%@：0.000000000", DBHGetStringWithKeyFromTable(@"Fees", nil)];
    self.originalPoundageLabel.text = [NSString stringWithFormat:@"（%@：3.00000000Gas）", DBHGetStringWithKeyFromTable(@"Original Fees", nil)];
    self.collectionAddressValueLabel.text = @"Alxln4p9in21pi4nxlknfgrutalnf";
}

#pragma mark ------ Event Responds ------
/**
 提交
 */
- (void)respondsToSureButton {
    
}

#pragma mark ------ Getters And Setters ------
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = FONT(30);
        _numberLabel.textColor = COLORFROM16(0x008D55, 1);
    }
    return _numberLabel;
}
- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = FONT(8);
        _unitLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _unitLabel;
}
- (UILabel *)poundageLabel {
    if (!_poundageLabel) {
        _poundageLabel = [[UILabel alloc] init];
        _poundageLabel.font = FONT(11);
        _poundageLabel.textColor = COLORFROM16(0xF85803, 1);
    }
    return _poundageLabel;
}
- (UILabel *)originalPoundageLabel {
    if (!_originalPoundageLabel) {
        _originalPoundageLabel = [[UILabel alloc] init];
        _originalPoundageLabel.font = FONT(9);
        _originalPoundageLabel.textColor = COLORFROM16(0xD5D5D5, 1);
    }
    return _originalPoundageLabel;
}
- (UILabel *)collectionAddressLabel {
    if (!_collectionAddressLabel) {
        _collectionAddressLabel = [[UILabel alloc] init];
        _collectionAddressLabel.font = FONT(13);
        _collectionAddressLabel.text = DBHGetStringWithKeyFromTable(@"Intelligent Contract Address", nil);
        _collectionAddressLabel.textColor = COLORFROM16(0x8A8A8A, 1);
    }
    return _collectionAddressLabel;
}
- (UILabel *)collectionAddressValueLabel {
    if (!_collectionAddressValueLabel) {
        _collectionAddressValueLabel = [[UILabel alloc] init];
        _collectionAddressValueLabel.font = FONT(13);
        _collectionAddressValueLabel.textColor = COLORFROM16(0x3D3D3D, 1);
    }
    return _collectionAddressValueLabel;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xEAEAEA, 1);
    }
    return _grayLineView;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = MAIN_ORANGE_COLOR;
        _sureButton.titleLabel.font = FONT(14);
        [_sureButton setTitle:DBHGetStringWithKeyFromTable(@"Submit", nil) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
