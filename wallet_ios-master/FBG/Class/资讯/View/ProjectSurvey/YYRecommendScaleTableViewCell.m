//
//  YYRecommendScaleTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRecommendScaleTableViewCell.h"
#import "YYEvaluateSynthesisModel.h"

@interface YYRecommendScaleTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendValueLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disRecommendWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *scaleView;
@property (weak, nonatomic) IBOutlet UILabel *disRecommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *disRecommendValueLabel;

@end

@implementation YYRecommendScaleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(@"Recommendation Percent", nil);
    self.recommendLabel.text = DBHGetStringWithKeyFromTable(@"Recommend", nil);
    self.disRecommendLabel.text = DBHGetStringWithKeyFromTable(@"Not Recommend ", nil);
    
    [self.contentView layoutIfNeeded];
    CGFloat widthValue = CGRectGetWidth(self.scaleView.frame) / 2;
    self.recommendWidthConstraint.constant = widthValue;
    self.disRecommendWidthConstraint.constant = widthValue;
    
    self.scaleView.layer.cornerRadius = AUTOLAYOUTSIZE(3);
    self.scaleView.layer.masksToBounds = YES;
    self.recommendValueLabel.text = [NSString stringWithFormat:@"0%@, 0%%", DBHGetStringWithKeyFromTable(@"Comment", nil)];
     self.disRecommendValueLabel.text = [NSString stringWithFormat:@"0%@, 0%%", DBHGetStringWithKeyFromTable(@"Comment", nil)];
}

- (void)setModel:(YYEvaluateSynthesisModel *)model {
    _model = model;
    NSInteger recommendCount = model.recommend + model.like;
    NSInteger disRecommendCount = model.dissatisfied + model.very_dissatisfied;
    
    NSInteger normal = model.total - model.good;
    CGFloat recommendPercent = [self setValueLabel:self.recommendValueLabel count:recommendCount total:normal];
    CGFloat disRecommendPercent = [self setValueLabel:self.disRecommendValueLabel count:disRecommendCount total:normal];
    
    CGFloat totalWidth = CGRectGetWidth(self.scaleView.frame);
    if (recommendPercent == disRecommendPercent) {
        recommendPercent = 0.5;
        disRecommendPercent = 0.5;
    }
    self.recommendWidthConstraint.constant = totalWidth * recommendPercent;
    self.disRecommendWidthConstraint.constant = totalWidth * disRecommendPercent;
}

- (CGFloat)setValueLabel:(UILabel *)label count:(NSInteger)count total:(NSInteger)total {
    CGFloat percentFloat = [NSString DecimalFuncWithOperatorType:3 first:@(count) secend:@(total) value:1].doubleValue;
   label.text = [NSString stringWithFormat:@"%@%@, %.0f%%", @(count), DBHGetStringWithKeyFromTable(@"Comment", nil), percentFloat * 100];
    
    return percentFloat;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
