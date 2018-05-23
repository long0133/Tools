//
//  YYRedPacketDetailTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailTableViewCell.h"

@interface YYRedPacketDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@end

@implementation YYRedPacketDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YYRedPacketDetailModel *)model section:(NSInteger)section {
    self.addressLabel.text = model.redbag_addr;
    
    NSString *number = [NSString notRounding:model.redbag afterPoint:8];
    self.priceLabel.text = [NSString stringWithFormat:@"%@%.8lf%@", section == 3 ? @"" : @"-", number.doubleValue, model.redbag_symbol];
    
    self.timeLabel.text = [NSString formatTimeDelayEight:model.created_at]; //YYTODO
    RedBagStatus status = model.status;
    if (status == RedBagStatusOpening) {
        self.statusLabel.hidden = YES;
    } else {
        self.statusLabel.hidden = NO;
        
        NSString *statusStr = @"Success";
        if (status == RedBagStatusCashPackaging) {
            statusStr = @"In the packaging";
        } else if (status == RedBagStatusCashPackageFailed || status == RedBagStatusCreateFailed) {
            statusStr = @"Failed";
        } else if (status == RedBagStatusCreating) {
            if (section == 2) {
                statusStr = @"In the payment";
            }
        }
        self.statusLabel.text = DBHGetStringWithKeyFromTable(statusStr, nil);
    }
}

- (void)setIsLastCellInSection:(BOOL)isLastCellInSection {
    if (_isLastCellInSection == isLastCellInSection) {
        return;
    }
    
    _isLastCellInSection = isLastCellInSection;
    self.bottomLineView.hidden = isLastCellInSection;
}

@end
