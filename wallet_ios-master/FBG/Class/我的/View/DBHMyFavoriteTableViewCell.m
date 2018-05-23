//
//  DBHMyFavoriteTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyFavoriteTableViewCell.h"

#import "DBHHistoricalInformationModelData.h"
#import "DBHProjectHomeNewsModelData.h"
#import "DBHExchangeNoticeModelData.h"
#import "DBHCandyBowlModelData.h"
#import "DBHInfomationModelData.h"

@interface DBHMyFavoriteTableViewCell ()

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *originalLabel;

@end

@implementation DBHMyFavoriteTableViewCell

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
    [self.contentView addSubview:self.pictureImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.originalLabel];
    
    WEAKSELF
    [self.pictureImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(83.5));
        make.height.offset(AUTOLAYOUTSIZE(55.5));
        make.left.offset(AUTOLAYOUTSIZE(15));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.pictureImageView.mas_right).offset(AUTOLAYOUTSIZE(12));
        make.right.offset(- AUTOLAYOUTSIZE(15));
        make.top.offset(AUTOLAYOUTSIZE(13));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.offset(- AUTOLAYOUTSIZE(22.5));
    }];
    [self.originalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset([NSString getWidthtWithString:DBHGetStringWithKeyFromTable(@"Originality", nil) fontSize:AUTOLAYOUTSIZE(10)] + AUTOLAYOUTSIZE(5));
        make.height.offset(AUTOLAYOUTSIZE(10));
        make.left.equalTo(weakSelf.timeLabel.mas_right).offset(AUTOLAYOUTSIZE(7));
        make.centerY.equalTo(weakSelf.timeLabel);
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
- (void)setModel:(DBHHistoricalInformationModelData *)model {
    _model = model;
    
    [self.pictureImageView sdsetImageWithURL:_model.img placeholderImage:[UIImage imageNamed:@"fenxiang_jietu"]];
    self.titleLabel.text = _model.title;
    
    self.timeLabel.text = [NSString formatTimeDelayEight:_model.updatedAt];
    self.originalLabel.hidden = !_model.isSole;
}
- (void)setInfomationModel:(DBHProjectHomeNewsModelData *)infomationModel {
    _infomationModel = infomationModel;
    
    [self.pictureImageView sdsetImageWithURL:_infomationModel.img placeholderImage:[UIImage imageNamed:@"fenxiang_jietu"]];
    self.titleLabel.text = _infomationModel.title;
    self.timeLabel.text = [NSString formatTimeDelayEight:_infomationModel.updatedAt];
    self.originalLabel.hidden = !_infomationModel.isSole;
}
- (void)setExchangeNoticeModel:(DBHExchangeNoticeModelData *)exchangeNoticeModel {
    _exchangeNoticeModel = exchangeNoticeModel;
    
    self.titleLabel.text = _exchangeNoticeModel.sourceName;
    self.timeLabel.text = [NSString formatTimeDelayEight:_exchangeNoticeModel.updatedAt];
    self.originalLabel.hidden = YES;
}
- (void)setCandyBowlModel:(DBHCandyBowlModelData *)candyBowlModel {
    _candyBowlModel = candyBowlModel;
    
    [self.pictureImageView sdsetImageWithURL:_candyBowlModel.img placeholderImage:nil];
    self.titleLabel.text = _candyBowlModel.name;
    self.timeLabel.text = [NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld", (NSInteger)_candyBowlModel.year, (NSInteger)_candyBowlModel.month, (NSInteger)_candyBowlModel.day];
    self.originalLabel.hidden = YES;
}
- (void)setArticleModel:(DBHInfomationModelData *)articleModel {
    _articleModel = articleModel;
    
    [self.pictureImageView sdsetImageWithURL:_articleModel.img placeholderImage:nil];
    self.titleLabel.text = _articleModel.title;
    self.timeLabel.text = [NSString formatTimeDelayEight:_articleModel.createdAt];
    self.originalLabel.hidden = !_articleModel.isSole;
}
- (void)setMessage:(EMMessage *)message {
    _message = message;
    
    self.titleLabel.text = _message.ext[@"title"];
    self.timeLabel.text = [NSString timeExchangeWithType:@"yyyy-MM-dd hh:mm" timestamp:_message.timestamp];
}
- (void)setIsNoImage:(BOOL)isNoImage {
    _isNoImage = isNoImage;
    
    self.pictureImageView.hidden = _isNoImage;
    [self.pictureImageView sdsetImageWithURL:_model.img placeholderImage:nil];
    if (_isNoImage) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(AUTOLAYOUTSIZE(15));
            make.right.offset(- AUTOLAYOUTSIZE(15));
            make.top.offset(AUTOLAYOUTSIZE(13));
        }];
    } else {
        WEAKSELF
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.pictureImageView.mas_right).offset(AUTOLAYOUTSIZE(12));
            make.right.offset(- AUTOLAYOUTSIZE(15));
            make.top.offset(AUTOLAYOUTSIZE(13));
        }];
    }
}

- (UIImageView *)pictureImageView {
    if (!_pictureImageView) {
        _pictureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fenxiang_jietu"]];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
    }
    return _pictureImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(13);
        _titleLabel.textColor = COLORFROM16(0x000000, 1);
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT(11);
        _timeLabel.textColor = COLORFROM16(0xA3A3A3, 1);
    }
    return _timeLabel;
}
- (UILabel *)originalLabel {
    if (!_originalLabel) {
        _originalLabel = [[UILabel alloc] init];
        _originalLabel.font = FONT(10);
        _originalLabel.hidden = YES;
        _originalLabel.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        _originalLabel.layer.borderWidth = AUTOLAYOUTSIZE(0.5);
        _originalLabel.layer.borderColor = COLORFROM16(0xA1C7B5, 1).CGColor;
        _originalLabel.text = DBHGetStringWithKeyFromTable(@"Originality", nil);
        _originalLabel.textColor = COLORFROM16(0xA1C7B5, 1);
        _originalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _originalLabel;
}

@end
