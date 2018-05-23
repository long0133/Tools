//
//  DBHRankDetailSection1TableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHRankDetailSection1TableViewCell.h"
#import "DBHRankDetailModel.h"

@interface DBHRankDetailSection1TableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UILabel *rankValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *capLabel;
@property (weak, nonatomic) IBOutlet UILabel *capValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fluxLabel;
@property (weak, nonatomic) IBOutlet UILabel *fluxValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@end

@implementation DBHRankDetailSection1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rankLabel.text = DBHGetStringWithKeyFromTable(@"Rank", nil);
    self.capLabel.text = DBHGetStringWithKeyFromTable(@"Market Cap", nil);
    self.fluxLabel.text = DBHGetStringWithKeyFromTable(@"Circulating Supply", nil);
    self.totalLabel.text = DBHGetStringWithKeyFromTable(@"Total Supply", nil);
    
}

- (void)setDetailModel:(DBHRankDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.rankValueLabel.text = [NSString stringWithFormat:@"%.02d", detailModel.rank.intValue];
    
    double value = [self isCny] ? detailModel.market_cny.doubleValue : detailModel.market.doubleValue;
    
    NSString *first = [NSString stringWithFormat:@"%@", @(value)];
    NSString *second = [NSString stringWithFormat:@"%@", @(pow(10, 6))];
    NSString *result = [NSString DecimalFuncWithOperatorType:3 first:first secend:second value:8];
    
    NSString *content = [self isCny] ? [NSString stringWithFormat:@"￥%.02f million", result.doubleValue] : [NSString stringWithFormat:@"$%.02f million", result.doubleValue];
    self.capValueLabel.text = content;
    
    // 流通量
    value = detailModel.liquidity.doubleValue;
    
    first = [NSString stringWithFormat:@"%@", @(value)];
    result = [NSString DecimalFuncWithOperatorType:3 first:first secend:second value:8];
    
    content = [NSString stringWithFormat:@"%.02f million %@", result.doubleValue, detailModel.symbol];
    self.fluxValueLabel.text = content;
    
    // 总量
    value = detailModel.circulation.doubleValue;
    
    first = [NSString stringWithFormat:@"%@", @(value)];
    result = [NSString DecimalFuncWithOperatorType:3 first:first secend:second value:8];
    
    content = [NSString stringWithFormat:@"%.02f million %@", result.doubleValue, detailModel.symbol];
    self.totalValueLabel.text = content;
}

- (BOOL)isCny {
    return ([UserSignData share].user.walletUnitType == 1);
}
@end
