//
//  DBHPieChartFormTableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/21.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHPieChartFormTableViewCell.h"

@interface DBHPieChartFormTableViewCell()

@property (nonatomic, strong) UIImageView *formImageView;
@property (nonatomic, strong) UILabel *percentLabel;
//@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DBHPieChartFormTableViewCell

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
    [self.contentView addSubview:self.formImageView];
    WEAKSELF
    [self.formImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(25));
        make.centerY.equalTo(weakSelf.contentView);
        make.height.width.equalTo(@(AUTOLAYOUTSIZE(12)));
    }];
    
    [self.contentView addSubview:self.percentLabel];
    [self.percentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.formImageView.mas_right).offset(AUTOLAYOUTSIZE(6));
        make.right.equalTo(weakSelf.contentView).offset(-AUTOLAYOUTSIZE(25));
    }];
    
//    [self.contentView addSubview:self.contentLabel];
//    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.percentLabel.mas_right).offset(AUTOLAYOUTSIZE(6));
//        make.right.equalTo(weakSelf.contentView).offset(-AUTOLAYOUTSIZE(25));
//        make.height.centerY.equalTo(weakSelf.contentView);
//    }];
}

- (void)setColor:(UIColor *)color percent:(NSString *)percent content:(NSString *)content {
    [self.formImageView setImage:[UIImage imageWithColor:color]];
    
    NSString *percentStr = [percent stringByAppendingString:@"%"];
    self.percentLabel.text = [percentStr stringByAppendingFormat:@"   %@", content];
//    self.contentLabel.text = content;
}

- (UIImageView *)formImageView {
    if (!_formImageView) {
        _formImageView = [[UIImageView alloc] init];
    }
    return _formImageView;
}

- (UILabel *)percentLabel {
    if (!_percentLabel) {
        _percentLabel = [[UILabel alloc] init];
        _percentLabel.textColor = COLORFROM16(0x333333, 1);
        _percentLabel.font = FONT(12);
        
    }
    return _percentLabel;
}

//- (UILabel *)contentLabel {
//    if (!_contentLabel) {
//        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.textColor = COLORFROM16(0x333333, 1);
//        _contentLabel.font = FONT(12);
//
//    }
//    return _contentLabel;
//}

@end
