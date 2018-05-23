//
//  YYChoosePayStyleTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYChoosePayStyleTableViewCell.h"

#define MAX_USE(balance, name) [NSString stringWithFormat:@"%@：%.8lf %@", DBHGetStringWithKeyFromTable(@"Amount Available", nil), balance, name]

@interface YYChoosePayStyleTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxUseLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation YYChoosePayStyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(DBHWalletManagerForNeoModelList *)model currentWalletID:(NSInteger)currentWalletID tokenName:(NSString *)tokenName {
    self.addressLabel.text = model.address;
    NSString *balance = [model.tokenStatistics objectForKey:tokenName];
    NSString *number = [NSString notRounding:balance afterPoint:8];
    self.maxUseLabel.text = MAX_USE(number.doubleValue, tokenName);
    
    if (currentWalletID == model.listIdentifier) {
        self.selectBtn.selected = YES;
    } else {
        self.selectBtn.selected = NO;
    }
    
    
}


@end
