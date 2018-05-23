
//
//  DBHWalletDetailTitleView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/12.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHWalletDetailTitleView.h"

@interface DBHWalletDetailTitleView ()

@property (nonatomic, strong) UILabel *assetLabel;
@property (nonatomic, strong) UIButton *showAssetButton;

@property (nonatomic, copy) ClickShowPriceBlock clickShowPriceBlock;

@end

@implementation DBHWalletDetailTitleView

#pragma mark ------ Lifecycle ------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.assetLabel];
    [self addSubview:self.showAssetButton];
    
    WEAKSELF
    [self.assetLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    [self.showAssetButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(30));
        make.height.equalTo(weakSelf);
        make.left.equalTo(weakSelf.assetLabel.mas_right);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark ------ Event Responds ------
/**
 显示/隐藏资产
 */
- (void)respondsToShowAssetButton {
    self.showAssetButton.selected = !self.showAssetButton.selected;
    [UserSignData share].user.isHideAsset = self.showAssetButton.isSelected;
    self.assetLabel.text = [NSString stringWithFormat:@"%@ %@", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", [UserSignData share].user.isHideAsset ? @"****" : self.totalAsset];
    
    self.clickShowPriceBlock();
}

#pragma mark ------ Public Methods ------
- (void)clickShowPriceBlock:(ClickShowPriceBlock)clickShowPriceBlock {
    self.clickShowPriceBlock = clickShowPriceBlock;
}
- (void)refreshAsset {
    self.showAssetButton.selected = [UserSignData share].user.isHideAsset;
    self.assetLabel.text = [NSString stringWithFormat:@"%@ %@", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", [UserSignData share].user.isHideAsset ? @"****" : self.totalAsset];
}

#pragma mark ------ Getters And Setters ------
- (void)setTotalAsset:(NSString *)totalAsset {
    _totalAsset = totalAsset;
    
    self.showAssetButton.selected = [UserSignData share].user.isHideAsset;
    self.assetLabel.text = [NSString stringWithFormat:@"%@ %@", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", [UserSignData share].user.isHideAsset ? @"****" : self.totalAsset];
}

- (UILabel *)assetLabel {
    if (!_assetLabel) {
        _assetLabel = [[UILabel alloc] init];
        _assetLabel.font = BOLDFONT(16);
        _assetLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _assetLabel;
}
- (UIButton *)showAssetButton {
    if (!_showAssetButton) {
        _showAssetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showAssetButton setImage:[UIImage imageNamed:@"睁眼1"] forState:UIControlStateNormal];
        [_showAssetButton setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateSelected];
        [_showAssetButton addTarget:self action:@selector(respondsToShowAssetButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showAssetButton;
}

@end
