//
//  YYRedPacketSucessTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSucessTableViewCell.h"

#define OPENED_REDPACKET(name) [NSString stringWithFormat:@"%@%@%@", DBHGetStringWithKeyFromTable(@"Has opened ", nil), name, DBHGetStringWithKeyFromTable(@"'s Redpacket Successfully", nil)]

@interface YYRedPacketSucessTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation YYRedPacketSucessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _topHeight.constant = STATUS_HEIGHT;
    self.statusLabel.text = OPENED_REDPACKET(@"Grita");
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Opened in 24H, Please look over wallet", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
