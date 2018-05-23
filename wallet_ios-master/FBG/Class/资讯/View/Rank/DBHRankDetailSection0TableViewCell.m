//
//  DBHRankDetailSection0TableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHRankDetailSection0TableViewCell.h"
#import "DBHRankDetailModel.h"

@interface DBHRankDetailSection0TableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;

@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *highValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeValueLabel;

@end

@implementation DBHRankDetailSection0TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.highLabel.text = DBHGetStringWithKeyFromTable(@"High (24h)", nil);
    self.lowLabel.text = DBHGetStringWithKeyFromTable(@"Low (24h)", nil);
    self.volumeLabel.text = DBHGetStringWithKeyFromTable(@"Volume (24h) ", nil);
}

- (void)setDetailModel:(DBHRankDetailModel *)detailModel {
    _detailModel = detailModel;
    [self.iconImgView sdsetImageWithURL:detailModel.img placeholderImage:[UIImage imageNamed:@"NEO_add"]];
    self.nameLabel.text = detailModel.symbol;
    self.symbolLabel.text = [NSString stringWithFormat:@"(%@)", detailModel.name];
    
    // 涨跌幅
    CGFloat value = detailModel.change.doubleValue;
    NSString *content = nil;
    if (value >= 0) {
        content = [NSString stringWithFormat:@"+%.02f%%", value];
        self.changeLabel.textColor = COLORFROM16(0x3CA316, 1);
    } else {
        content = [NSString stringWithFormat:@"%.02f%%", value];
        self.changeLabel.textColor = MAIN_ORANGE_COLOR;
    }
    self.changeLabel.text = content;
    
    NSString *price = nil;
    NSString *high = nil;
    NSString *low = nil;
    NSString *volume = nil;
    if ([self isCny]) {
        price = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.02f", detailModel.price_cny.doubleValue]];
        price = [NSString stringWithFormat:@"￥%@", price];
        
        high = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.02f", detailModel.high_price_cny.doubleValue]];
        high = [NSString stringWithFormat:@"￥%@", high];
        
        low = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.02f", detailModel.low_price_cny.doubleValue]];
        low = [NSString stringWithFormat:@"￥%@", low];
        
        volume = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.02f", detailModel.volume_cny.doubleValue]];
        volume = [NSString stringWithFormat:@"￥%@", volume];
    } else {
        price = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.02f", detailModel.price.doubleValue]];
        price = [NSString stringWithFormat:@"$%@", price];
        
        high = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.02f", detailModel.high_price.doubleValue]];
        high = [NSString stringWithFormat:@"$%@", high];
        
        low = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.02f", detailModel.low_price.doubleValue]];
        low = [NSString stringWithFormat:@"$%@", low];
        
        volume = [NSString getDealNumwithstring:[NSString stringWithFormat:@"%.02f", detailModel.volume.doubleValue]];
        volume = [NSString stringWithFormat:@"$%@", volume];
    }
    self.priceLabel.text = price;
    self.highValueLabel.text = high;
    self.lowValueLabel.text = low;
    self.volumeValueLabel.text = volume;
}

- (BOOL)isCny {
    return ([UserSignData share].user.walletUnitType == 1);
}

@end
