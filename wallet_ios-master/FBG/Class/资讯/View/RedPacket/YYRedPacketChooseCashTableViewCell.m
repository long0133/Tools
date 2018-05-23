//
//  YYRedPacketChooseCashTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketChooseCashTableViewCell.h"
#import "YYRedPacketEthTokenModel.h"

@interface YYRedPacketChooseCashTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation YYRedPacketChooseCashTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YYRedPacketEthTokenModel *)model {
    _model = model;
    
    [self.iconImgView sdsetImageWithURL:model.icon placeholderImage:[UIImage imageNamed:@"ETH"]];
    self.nameLabel.text = model.name;
    
}

@end
