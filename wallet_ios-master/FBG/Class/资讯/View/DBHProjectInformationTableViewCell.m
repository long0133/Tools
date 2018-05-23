//
//  DBHProjectInformationTableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/15.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectInformationTableViewCell.h"

@interface DBHProjectInformationTableViewCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation DBHProjectInformationTableViewCell

#pragma mark ------ Lifecycle ------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isHideBottomLineView = YES;
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.valueLabel];
    
    WEAKSELF
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(AUTOLAYOUTSIZE(22));
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).offset(-AUTOLAYOUTSIZE(22));
    }];
}

- (void)setName:(NSString *)name value:(NSString *)value {
    self.nameLabel.text = DBHGetStringWithKeyFromTable(name, nil);
    
    CGFloat width = [NSString getWidthtWithString:self.nameLabel.text fontSize:14];
    
    WEAKSELF
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(AUTOLAYOUTSIZE(width)));
        make.left.equalTo(weakSelf.contentView).offset(AUTOLAYOUTSIZE(22));
        make.centerY.equalTo(weakSelf.contentView);
    }];

    self.valueLabel.text = value;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(14);
        _nameLabel.text = DBHGetStringWithKeyFromTable(@"Rank", nil);
        _nameLabel.textColor = COLORFROM16(0x333333, 1);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = FONT(14);
        _valueLabel.textColor = COLORFROM16(0x333333, 1);
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel;
}
@end
