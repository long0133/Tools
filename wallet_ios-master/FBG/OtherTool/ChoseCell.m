//
//  ChoseCell.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/16.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ChoseCell.h"

@implementation ChoseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WalletLeftListModel *)model
{
    _model = model;

    if ([model.category_name isEqualToString:@"ETH"])
    {
        self.headImageView.image = [UIImage imageNamed:@"ETH_add"];
    }
    else if ([model.category_name isEqualToString:@"BTC"])
    {
        self.headImageView.image = [UIImage imageNamed:@"BTC_add"];
    }
    else if ([model.category_name isEqualToString:@"NEO"])
    {
        self.headImageView.image = [UIImage imageNamed:@"NEO_add"];
    }
    else
    {
        self.headImageView.image = [UIImage imageNamed:@"tao"];
    }
        
    self.nameLB.text = model.name;
}

@end
