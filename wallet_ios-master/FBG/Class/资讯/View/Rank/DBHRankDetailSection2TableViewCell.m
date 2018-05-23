//
//  DBHRankDetailSection2TableViewCell.m
//  FBG
//
//  Created by yy on 2018/3/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHRankDetailSection2TableViewCell.h"
#import "DBHTradingMarketModelData.h"

@interface DBHRankDetailSection2TableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeValueLabel;

@end

@implementation DBHRankDetailSection2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.volumeLabel.text = [NSString stringWithFormat:@"%@:", DBHGetStringWithKeyFromTable(@"Volume (24h)", nil)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DBHTradingMarketModelData *)model {
    _model = model;
    NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)", _model.source, _model.pair]];
    [nameAttributedString addAttribute:NSFontAttributeName value:FONT(13) range:NSMakeRange(0, [_model.source length])];
    self.nameLabel.attributedText = nameAttributedString;
    self.priceLabel.text = _model.pairce;
    self.volumeValueLabel.text =  _model.volum24;
}

@end
