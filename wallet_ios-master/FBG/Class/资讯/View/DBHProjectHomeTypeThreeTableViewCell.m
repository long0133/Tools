
//
//  DBHProjectHomeTypeThreeTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeTypeThreeTableViewCell.h"

#import "DBHProjectHomeNewsDataModels.h"

@interface DBHProjectHomeTypeThreeTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UIView *grayLineView;
//@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DBHProjectHomeTypeThreeTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isHideBottomLineView = YES;
        self.backgroundColor = COLORFROM10(235, 235, 235, 1);
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.contentView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.grayLineView];
//    [self.contentView addSubview:self.contentLabel];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(28));
//        make.height.offset(AUTOLAYOUTSIZE(51));
        make.centerX.top.bottom.equalTo(weakSelf.boxView);
    }];
//    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.titleLabel);
//        make.height.offset(AUTOLAYOUTSIZE(1));
//        make.centerX.equalTo(weakSelf.boxView);
//        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
//    }];
//    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.titleLabel);
//        make.centerX.equalTo(weakSelf.boxView);
//        make.top.equalTo(weakSelf.grayLineView.mas_bottom).offset(AUTOLAYOUTSIZE(14));
//        make.bottom.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(14));
//    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHProjectHomeNewsModelData *)model {
    _model = model;
    
    self.titleLabel.text = _model.title;
//    self.contentLabel.text = _model.desc;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIImageView alloc] init];
        _boxView.backgroundColor = WHITE_COLOR;
        _boxView.layer.cornerRadius = AUTOLAYOUTSIZE(5);
        _boxView.clipsToBounds = YES;
    }
    return _boxView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(14);
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
//- (UIView *)grayLineView {
//    if (!_grayLineView) {
//        _grayLineView = [[UIView alloc] init];
//        _grayLineView.backgroundColor = COLORFROM16(0xD2D2D2, 1);
//    }
//    return _grayLineView;
//}
//- (UILabel *)contentLabel {
//    if (!_contentLabel) {
//        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.font = FONT(14);
//        _contentLabel.textColor = COLORFROM16(0x333333, 1);
//        _contentLabel.numberOfLines = 2;
//    }
//    return _contentLabel;
//}

@end
