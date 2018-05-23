//
//  DBHProjectOverviewNoTradingForRelevantInformationTableViewCell.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectOverviewNoTradingForRelevantInformationTableViewCell.h"

#import "DBHProjectDetailInformationDataModels.h"

@interface DBHProjectOverviewNoTradingForRelevantInformationTableViewCell ()

@property (nonatomic, strong) UIImageView *dateImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DBHProjectOverviewNoTradingForRelevantInformationTableViewCell

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
    [self.contentView addSubview:self.dateImageView];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.contentLabel];
    
    WEAKSELF
    [self.dateImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(10));
        make.height.offset(AUTOLAYOUTSIZE(10.5));
        make.left.offset(AUTOLAYOUTSIZE(16));
        make.top.offset(AUTOLAYOUTSIZE(15));
    }];
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.dateImageView.mas_right).offset(AUTOLAYOUTSIZE(5));
        make.centerY.equalTo(weakSelf.dateImageView);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView).offset(- AUTOLAYOUTSIZE(30));
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.dateImageView.mas_bottom).offset(AUTOLAYOUTSIZE(13.5));
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    self.dateLabel.text = _projectDetailModel.categoryDesc.startAt;
    
    NSAttributedString *htmlString = [[NSAttributedString alloc] initWithData:[_projectDetailModel.categoryDesc.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.contentLabel.attributedText = htmlString;
}

- (UIImageView *)dateImageView {
    if (!_dateImageView) {
        _dateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmugaikuang_shijian"]];
    }
    return _dateImageView;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = BOLDFONT(14);
        _dateLabel.textColor = COLORFROM16(0xFF571F, 1);
    }
    return _dateLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
