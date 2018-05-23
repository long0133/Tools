//
//  DBHProjectHomeTypeTwoTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectHomeTypeTwoTableViewCell.h"

#import "DBHProjectHomeNewsModelData.h"
#import "DBHInformationDataModels.h"
#import "DBHProjectDetailInformationDataModels.h"

@interface DBHProjectHomeTypeTwoTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DBHProjectHomeTypeTwoTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLORFROM10(235, 235, 235, 1);
        self.isHideBottomLineView = YES;
        
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.boxView];
    [self.boxView addSubview:self.coverImageView];
    [self.contentView addSubview:self.titleLabel];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView);
        make.height.offset(AUTOLAYOUTSIZE(167.5));
        make.centerX.top.equalTo(weakSelf.boxView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(14));
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(14));
        make.top.equalTo(weakSelf.coverImageView.mas_bottom);
        make.bottom.equalTo(weakSelf.boxView);
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHProjectHomeNewsModelData *)model {
    _model = model;
    
    if (!_model.img.length) { // 长度为0
        self.coverImageView.image = [UIImage imageNamed:@"fenxiang_jietu"];
    }
    
    [self.coverImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageNamed:@"fenxiang_jietu"]];
    self.titleLabel.text = _model.title;
}
- (void)setProjectModel:(DBHInformationModelData *)projectModel {
    _projectModel = projectModel;
    
    if (!_model.img.length) {
        self.coverImageView.image = [UIImage imageNamed:@"fenxiang_jietu"];
    }
    
    [self.coverImageView sdsetImageWithURL:_projectModel.coverImg placeholderImage:[UIImage imageNamed:@"fenxiang_jietu"]];
    self.titleLabel.text = _projectModel.desc;
}
- (void)setLastModel:(DBHProjectDetailInformationModelLastArticle *)lastModel {
    _lastModel = lastModel;
    
//    [self.coverImageView sdsetImageWithURL:_lastModel.img placeholderImage:[UIImage imageNamed:@"fenxiang_jietu"]];
//    self.titleLabel.text = _lastModel.title;
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
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(14);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}

@end
