//
//  DBHInformationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHInformationTableViewCell.h"

#import "DBHInformationDataModels.h"
#import "DBHInformationForICODataModels.h"

@interface DBHInformationTableViewCell ()

@property (nonatomic, strong) UIImageView *iconBackImageView;
@property (nonatomic, strong) UILabel *noReadLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation DBHInformationTableViewCell

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
    [self.contentView addSubview:self.iconBackImageView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.noReadLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.changeLabel];
    [self.contentView addSubview:self.timeLabel];
    
    WEAKSELF
    [self.iconBackImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(45));
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.noReadLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(8));
        make.centerX.equalTo(weakSelf.iconBackImageView.mas_right);
        make.centerY.equalTo(weakSelf.iconBackImageView.mas_top);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(AUTOLAYOUTSIZE(30));
        make.center.equalTo(weakSelf.iconBackImageView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconBackImageView.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.top.offset(AUTOLAYOUTSIZE(10));
//        make.width.lessThanOrEqualTo(@(AUTOLAYOUTSIZE(160)));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.width.equalTo(@(AUTOLAYOUTSIZE(170)));
        make.bottom.offset(- AUTOLAYOUTSIZE(10.5));
    }];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(weakSelf.titleLabel.mas_right).offset(AUTOLAYOUTSIZE(2));
        make.centerY.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf.changeLabel.mas_left).offset(- AUTOLAYOUTSIZE(10));
    }];
    [self.changeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([NSString getWidthtWithString:@"+11.09%" fontSize:AUTOLAYOUTSIZE(11)] + AUTOLAYOUTSIZE(4));
        make.height.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.titleLabel);
        make.right.offset(- AUTOLAYOUTSIZE(15));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.changeLabel);
        make.centerY.equalTo(weakSelf.contentLabel);
    }];
}

// 改变滑动删除按钮样式
- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            CGRect cRect = subView.frame;
            cRect.size.height = self.contentView.frame.size.height - 10;
            subView.frame = cRect;
            
            UIView *confirmView=(UIView *)[subView.subviews firstObject];
            // 改背景颜色
//            confirmView.backgroundColor=[UIColor colorWithRed:254/255.0 green:85/255.0 blue:46/255.0 alpha:1];
            for(UIView *sub in confirmView.subviews){
                if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]){
                    UILabel *deleteLabel=(UILabel *)sub;
                    // 改删除按钮的字体
                    deleteLabel.font = FONT(13);
                }
            }
            break;
        }
    }
}

#pragma mark ------ Getters And Setters ------

- (void)setModel:(DBHInformationModelData *)model {
    _model = model;
    
    self.iconBackImageView.image = nil;
    self.iconImageView.hidden = NO;
    [self.iconImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageWithColor:WHITE_COLOR]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@（%@）", _model.name, _model.longName];
    self.contentLabel.text = _model.lastArticle.title;
    self.timeLabel.text = [NSString formatTimeDelayEight:_model.lastArticle.createdAt];
    
    NSString *price = [UserSignData share].user.walletUnitType == 1 ? _icoModel.priceCny : _icoModel.priceUsd;
    if ([NSObject isNulllWithObject:price] || [price isEqualToString:@"-"]) {
        self.priceLabel.hidden = YES;
        self.changeLabel.hidden = YES;
    } else {
        self.priceLabel.hidden = _model.type != 1;
        self.changeLabel.hidden = _model.type != 1;
    }

    if (self.currentSelectedTitleIndex == 0) { // 自选如果有未读消息才显示
        self.isNoRead = _model.categoryUser.isFavoriteDot;
    } else { // 项目不会显示
        self.isNoRead = NO;
    }
}
- (void)setIcoModel:(DBHInformationModelIco *)icoModel {
    _icoModel = icoModel;
    
    NSString *price = [UserSignData share].user.walletUnitType == 1 ? _icoModel.priceCny : _icoModel.priceUsd;
    if ([NSObject isNulllWithObject:price] || [price isEqualToString:@"-"]) {
        self.priceLabel.hidden = YES;
        self.changeLabel.hidden = YES;
    } else {
        if (price.doubleValue < 0.01) {
            self.priceLabel.text = [NSString stringWithFormat:@"%@%@", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", price];
        } else {
            self.priceLabel.text = [NSString stringWithFormat:@"%@%.2lf", [UserSignData share].user.walletUnitType == 1 ? @"¥" : @"$", price.doubleValue];
        }
        WEAKSELF
        CGFloat width = [NSString getWidthtWithString:self.priceLabel.text fontSize:11];
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(weakSelf.titleLabel.mas_right).offset(AUTOLAYOUTSIZE(2));
            make.centerY.equalTo(weakSelf.titleLabel);
            make.width.equalTo(@(width));
            make.right.equalTo(weakSelf.changeLabel.mas_left).offset(- AUTOLAYOUTSIZE(10));
        }];
        
        float percentChange24h = _icoModel.percentChange24h.doubleValue;
        if (percentChange24h == 0) { // -0的情况
            percentChange24h = 0;
        }
        self.changeLabel.text = [NSString stringWithFormat:@"%@%.2lf%%", percentChange24h >= 0 ? @"+" : @"", percentChange24h];
        self.changeLabel.backgroundColor = percentChange24h >= 0 ? COLORFROM16(0x008C55, 1) : MAIN_ORANGE_COLOR;
    }
}
- (void)setFunctionalUnitTitle:(NSString *)functionalUnitTitle {
    _functionalUnitTitle = functionalUnitTitle;
    
    self.iconImageView.hidden = YES;
    self.iconBackImageView.image = [UIImage imageNamed:_functionalUnitTitle];
    self.titleLabel.text = DBHGetStringWithKeyFromTable(_functionalUnitTitle, nil);
    self.priceLabel.hidden = YES;
    self.changeLabel.hidden = YES;
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    self.contentLabel.text = _content;
}

- (void)setTime:(NSString *)time {
    _time = time;
    
    self.timeLabel.text = _time;
}

- (void)setIsNoRead:(BOOL)isNoRead {
    _isNoRead = isNoRead;
    
    self.noReadLabel.text = @" ";
    self.noReadLabel.hidden = !_isNoRead;
}

- (UIImageView *)iconBackImageView {
    if (!_iconBackImageView) {
        _iconBackImageView = [[UIImageView alloc] init];
        _iconBackImageView.backgroundColor = COLORFROM16(0xF8F4F4, 1);
        _iconBackImageView.layer.cornerRadius = AUTOLAYOUTSIZE(6);
    }
    return _iconBackImageView;
}
- (UILabel *)noReadLabel {
    if (!_noReadLabel) {
        _noReadLabel = [[UILabel alloc] init];
        _noReadLabel.hidden = YES;
        _noReadLabel.backgroundColor = [UIColor redColor];
        _noReadLabel.layer.cornerRadius = AUTOLAYOUTSIZE(4);
        _noReadLabel.clipsToBounds = YES;
        _noReadLabel.font = FONT(10);
        _noReadLabel.textColor = WHITE_COLOR;
        _noReadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noReadLabel;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(14);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT(13);
        _contentLabel.textColor = COLORFROM16(0xA5A5A5, 1);
    }
    return _contentLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = FONT(11);
        _priceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _priceLabel;
}
- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.backgroundColor = COLORFROM16(0x008C55, 1);
        _changeLabel.font = FONT(11);
        _changeLabel.text = @"0.00";
        _changeLabel.textColor = COLORFROM16(0xFFFFFF, 1);
        _changeLabel.textAlignment = NSTextAlignmentCenter;
        _changeLabel.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        _changeLabel.clipsToBounds = YES;
    }
    return _changeLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT(10);
        _timeLabel.textColor = COLORFROM16(0xD8D8D8, 1);
    }
    return _timeLabel;
}

@end
