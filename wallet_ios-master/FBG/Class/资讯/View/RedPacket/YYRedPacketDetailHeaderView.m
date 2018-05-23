//
//  YYRedPacketDetailHeaderView.m
//  FBG
//
//  Created by yy on 2018/4/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketDetailHeaderView.h"

@interface YYRedPacketDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@end

@implementation YYRedPacketDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    
    self.titleLabel.text = headerTitle;
}

- (void)setShowTotal:(BOOL)showTotal {
    _showTotal = showTotal;
    
    self.totalView.hidden = !showTotal;
}

- (void)setModel:(YYRedPacketDetailModel *)model {
    _model = model;
    
    self.totalTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Total", nil)];
    
    NSString *number = [NSString notRounding:model.redbag afterPoint:8];
    self.totalValueLabel.text = [NSString stringWithFormat:@"%.8lf%@", number.doubleValue, model.redbag_symbol];
}

@end
