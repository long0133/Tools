
//
//  DBHNotificationDetailViewController.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHNotificationDetailViewController.h"

@interface DBHNotificationDetailViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DBHNotificationDetailViewController

#pragma mark ------ Lifecycle ------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.contentLabel];
    
    WEAKSELF
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view).offset(- AUTOLAYOUTSIZE(30));
        make.centerX.equalTo(weakSelf.view);
        make.top.offset(AUTOLAYOUTSIZE(24));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(18));
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(11));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.titleLabel);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(AUTOLAYOUTSIZE(16));
    }];
}

#pragma mark ------ Getters And Setters ------
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(15);
        _titleLabel.textColor = COLORFROM16(0x000000, 1);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT(11);
        _timeLabel.textColor = COLORFROM16(0x9C9C9C, 1);
    }
    return _timeLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT(13);
        _contentLabel.textColor = COLORFROM16(0x333333, 1);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
