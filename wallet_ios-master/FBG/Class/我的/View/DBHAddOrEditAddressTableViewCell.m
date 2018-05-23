//
//  DBHAddOrEditAddressTableViewCell.m
//  Trinity
//
//  Created by 邓毕华 on 2017/12/28.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHAddOrEditAddressTableViewCell.h"

@interface DBHAddOrEditAddressTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, copy) ScanQrCodeBlock scanQrCodeBlock;

@end

@implementation DBHAddOrEditAddressTableViewCell

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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.nameTextField];
    [self.contentView addSubview:self.firstLineView];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.addressTextField];
    [self.contentView addSubview:self.scanButton];
    
    WEAKSELF
    CGFloat width = [NSString getWidthtWithString:weakSelf.nameLabel.text fontSize:13];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.width.equalTo(@(AUTOLAYOUTSIZE(width)));
        make.centerY.equalTo(weakSelf.nameTextField);
    }];
    [self.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(AUTOLAYOUTSIZE(18));
        make.right.equalTo(weakSelf.firstLineView);
        make.height.offset(AUTOLAYOUTSIZE(48.5));
        make.bottom.equalTo(weakSelf.firstLineView.mas_top);
    }];
    [self.firstLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.centerY.equalTo(weakSelf.addressTextField);
    }];
    [self.addressTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.nameTextField);
        make.left.equalTo(weakSelf.nameTextField);
        make.right.equalTo(weakSelf.scanButton.mas_left).offset(-AUTOLAYOUTSIZE(10));
        make.bottom.offset(- AUTOLAYOUTSIZE(1));
    }];
    [self.scanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(25));
        make.height.equalTo(weakSelf.addressTextField);
        make.right.equalTo(weakSelf.firstLineView);
        make.centerY.equalTo(weakSelf.addressTextField);
    }];
}

#pragma mark ------ Event Responds ------
/**
 扫描二维码
 */
- (void)respondsToScanButton {
    self.scanQrCodeBlock();
}

#pragma mark ------ Public Methods ------
- (void)scanQrCodeBlock:(ScanQrCodeBlock)scanQrCodeBlock {
    self.scanQrCodeBlock = scanQrCodeBlock;
}

#pragma mark ------ Getters And Setters ------
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(13);
        _nameLabel.text = DBHGetStringWithKeyFromTable(@"Name", nil);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameLabel;
}
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.font = FONT(13);
        _nameTextField.textColor = COLORFROM16(0x333333, 1);
    }
    return _nameTextField;
}
- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = COLORFROM16(0xF6F6F6, 1);
    }
    return _firstLineView;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT(13);
        _addressLabel.text = DBHGetStringWithKeyFromTable(@"Address", nil);
        _addressLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _addressLabel;
}
- (UITextField *)addressTextField {
    if (!_addressTextField) {
        _addressTextField = [[UITextField alloc] init];
        _addressTextField.font = FONT(13);
        _addressTextField.textColor = COLORFROM16(0x333333, 1);
        _addressTextField.keyboardType = UIKeyboardTypeURL;
    }
    return _addressTextField;
}
- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scanButton setImage:[UIImage imageNamed:@"Scan QR Code"] forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(respondsToScanButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}

@end
