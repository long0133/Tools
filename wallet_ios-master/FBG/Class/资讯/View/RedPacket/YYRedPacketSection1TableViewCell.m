//
//  YYRedPacketSection1TableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSection1TableViewCell.h"
#import "YYRedPacketReceiveProgressView.h"
#import "YYRedPacketMySentListModel.h"

@interface YYRedPacketSection1TableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *redPacketNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet YYRedPacketReceiveProgressView *progessView;
@property (weak, nonatomic) IBOutlet UILabel *ingLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingHeightConstraint;

@end

@implementation YYRedPacketSection1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.statusLabel setBorderWidth:1 color:COLORFROM16(0xED7421, 1)];
}

- (void)setModel:(id)model from:(CellFrom)from {
    if (from == CellFromSentHistory && [model isKindOfClass:[YYRedPacketMySentListModel class]]) {
        YYRedPacketMySentListModel *sentModel = model;
        self.redPacketNoLabel.text = sentModel.redbag_addr;
        
        NSString *number = [NSString notRounding:sentModel.redbag afterPoint:8];
        self.priceLabel.text = [NSString stringWithFormat:@"%.8lf%@", number.doubleValue, sentModel.redbag_symbol];
        
        switch (sentModel.status) {
            case RedBagStatusDone: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Done", nil));
                break;
            }
            case RedBagStatusCashPackaging: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Cash Packaging", nil));
                break;
            }
            case RedBagStatusCreating: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Red Packet Creating", nil));
                break;
            }
                
            case RedBagStatusOpening: {
                [self showProgressView:YES];
                self.ingLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Openning", nil));
                [self.progessView setProgress:sentModel.draw_redbag_number total:sentModel.redbag_number];
                break;
            }
                
                
            case RedBagStatusCashPackageFailed: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Cash Package Failed", nil));
                break;
            }
                
            case RedBagStatusCreateFailed: {
                [self showProgressView:NO];
                self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"RedPacket Create Failed", nil));
                break;
            }
        }
    } else if (from == CellFromOpenedHistory && [model isKindOfClass:[YYRedPacketOpenedModel class]]) {
        YYRedPacketOpenedModel *openedModel = model;
        
        self.redPacketNoLabel.text = openedModel.draw_addr;
        
        NSString *openedRedBag = openedModel.model.redbag;
        
        [self showProgressView:NO];
        if (openedModel.model.done) { // 已开奖
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Awarded Prize", nil));
            
            NSString *number = [NSString notRounding:openedRedBag afterPoint:8];
            self.priceLabel.text = [NSString stringWithFormat:@"%.8lf%@", number.doubleValue, openedModel.model.redbag_symbol];
        } else { // 待开奖
            self.statusLabel.text = HAS_EMPTY(DBHGetStringWithKeyFromTable(@"Waitting Award", nil));
            self.priceLabel.text = [NSString stringWithFormat:@"???%@", openedModel.model.redbag_symbol];
        }
    }
}

- (void)showProgressView:(BOOL)isShow {
    self.progressBgView.hidden = YES;
    
    self.statusLabel.hidden = NO;
}

- (void)setModel:(id)model showIng:(BOOL)showIng {
    _ingHeightConstraint.constant = showIng ? 15 : 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
