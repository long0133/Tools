//
//  DBHIotificationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHIotificationTableViewCell.h"

#import "DBHProjectHomeNewsModelData.h"


@interface DBHIotificationTableViewCell ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *grayLineView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation DBHIotificationTableViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.grayLineView];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.moreImageView];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.height.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(14));
        make.right.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(14));
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(14));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(4));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(28));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(AUTOLAYOUTSIZE(10));
    }];
    [self.grayLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentLabel);
        make.height.offset(AUTOLAYOUTSIZE(1));
        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.detailLabel.mas_top);
    }];
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.height.offset(AUTOLAYOUTSIZE(35.5));
        make.bottom.equalTo(weakSelf.boxView);
    }];
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(4.5));
        make.height.offset(AUTOLAYOUTSIZE(8.5));
        make.right.equalTo(weakSelf.grayLineView);
        make.centerY.equalTo(weakSelf.detailLabel);
    }];
}

#pragma mark ------ Private Methods ------
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

#pragma mark ------ Getters And Setters ------
- (void)setModel:(DBHProjectHomeNewsModelData *)model {
    _model = model;
    
    self.titleLabel.text = _model.title;
    self.timeLabel.text = [NSString formatTimeDelayEight:_model.updatedAt];
    
    NSString *content = [self filterHTML:_model.desc];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:AUTOLAYOUTSIZE(5)];
    NSAttributedString *contentAttributedString = [[NSAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    self.contentLabel.attributedText = contentAttributedString;
}
- (void)setMessage:(EMMessage *)message {
    _message = message;
    
    EMTextMessageBody *content = (EMTextMessageBody *)_message.body;
    
    self.timeLabel.text = [NSString timeExchangeWithType:@"yyyy-MM-dd hh:mm" timestamp:_message.timestamp];
    
    self.titleLabel.text = _message.ext[@"title"];
    if (content.text.length) {
        NSString *changeContent = [content.text stringByReplacingOccurrencesOfString:@":date" withString:self.timeLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:AUTOLAYOUTSIZE(5)];
        NSAttributedString *contentAttributedString = [[NSAttributedString alloc] initWithString:changeContent attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
        self.contentLabel.attributedText = contentAttributedString;
    }
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
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT(10);
        _timeLabel.textColor = COLORFROM16(0xD8D8D8, 1);
    }
    return _timeLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT(13);
        _contentLabel.textColor = COLORFROM16(0x333333, 1);
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}
- (UIView *)grayLineView {
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = COLORFROM16(0xD2D2D2, 1);
    }
    return _grayLineView;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = FONT(13);
        _detailLabel.text = DBHGetStringWithKeyFromTable(@"Details", nil);
        _detailLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _detailLabel;
}
- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmuchakan_fanhui"]];
    }
    return _moreImageView;
}

@end
