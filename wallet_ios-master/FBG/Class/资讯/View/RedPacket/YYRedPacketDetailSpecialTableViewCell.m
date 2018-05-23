//
//  YYRedPacketDetailSpecialTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailSpecialTableViewCell.h"

#define FEES_TEXT(fees) [NSString stringWithFormat:@"%@：%@ETH", DBHGetStringWithKeyFromTable(@"Fees", nil), fees]

#define TIPLABEL_HEIGHT 29

@interface YYRedPacketDetailSpecialTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *feesLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderAddrTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *txidLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelHeight;

@property (nonatomic, assign) BOOL canShare;
@property (nonatomic, assign) RedBagStatus status;

@end

@implementation YYRedPacketDetailSpecialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _topHeight.constant = STATUS_HEIGHT;
    
    self.feesLabel.text = FEES_TEXT(@0);
    self.senderAddrTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Sender's Wallet Address", nil)];
    self.createTimeTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Create Time", nil)];
    
    NSString *text = DBHGetStringWithKeyFromTable(@"Money in expired red packet will be saved to your Balance After 24H", nil);
    
    NSRange range = [text localizedStandardRangeOfString:@"24H"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0xE24C0A, 1) range:range];
    
    self.tipLabel.attributedText = attributedString;
    
    [self.lookBtn setCorner:2];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToCopyAddressLabel:)];
    [self.senderAddrLabel addGestureRecognizer:longPressGR];
}

- (void)setModel:(YYRedPacketDetailModel *)model {
    _model = model;
    
    NSString *number = [NSString notRounding:model.redbag afterPoint:8];
    self.priceLabel.text = [NSString stringWithFormat:@"%.8lf%@", number.doubleValue, model.redbag_symbol];
    switch (model.status) {
        case RedBagStatusDone: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Done", nil));
            break;
        }
        case RedBagStatusCashPackaging: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Cash Packaging", nil));
            break;
        }
        case RedBagStatusCreating: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Red Packet Creating", nil));
            break;
        }
            
        case RedBagStatusOpening: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Sending", nil));
            break;
        }
            
        case RedBagStatusCashPackageFailed: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Cash Package Failed", nil));
            break;
        }
            
        case RedBagStatusCreateFailed: {
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"RedPacket Create Failed", nil));
            break;
        }
    }
    
    self.canShare = (model.status == RedBagStatusOpening);
    
    NSString *fee = model.fee;
    if ([NSObject isNulllWithObject:fee]) {
        fee = @"0.0";
    }
    self.feesLabel.text = FEES_TEXT(fee);
    
    self.senderAddrLabel.text = model.redbag_addr;
    self.txidLabel.text = model.auth_tx_id;
    self.createTimeLabel.text = [NSString formatTimeDelayEight:model.created_at];
    
    if (model.status == RedBagStatusOpening || model.status == RedBagStatusDone) {
        _tipLabelHeight.constant = 29;
    } else {
        _tipLabelHeight.constant = 0;
    }
}

- (void)setCanShare:(BOOL)canShare {
    _canShare = canShare;
    
    NSString *title = DBHGetStringWithKeyFromTable(@"Look Up Red Packet", nil);
    if (canShare) {
        title = DBHGetStringWithKeyFromTable(@"Look Up And Share Red Packet", nil);
    }
    [self.lookBtn setTitle:title forState:UIControlStateNormal];
    
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToLookBtn:(UIButton *)sender {
    if (self.block) {
        self.block(self.status);
    }
}

/**
 长按地址复制
 */
- (void)respondsToCopyAddressLabel:(UILongPressGestureRecognizer *)recognizer {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    UILabel *label = (UILabel *)recognizer.view;
    
    pasteboard.string = label.text;
    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Copy success, you can send it to friends", nil)];
}
@end
