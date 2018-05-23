//
//  YYEvaluateAnalysisTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYEvaluateAnalysisTableViewCell.h"
#import "YYEvaluateDetailAnalysisModel.h"

@interface YYEvaluateAnalysisTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downHeightConstraint;

@property (nonatomic, weak) YYEvaluateDetailAnalysisModel *model;
@property (nonatomic, weak) NSString *modelDate;

@end

@implementation YYEvaluateAnalysisTableViewCell

- (void)setModel:(YYEvaluateDetailAnalysisModel *)model withMax:(NSInteger)max {
    if ([_model isEqual:model]) {
        return;
    }
    
    _model = model;
    
    NSLog(@"like = %ld, dis = %ld, max = %ld", model.like, model.very_dissatisfied, (long)max);
    NSString *dateStr = model.date_range;
    
    NSString *resultDateStr = [NSDate dateStrFromStr:dateStr formatter:@"MM.dd"];
    self.timeLabel.text = resultDateStr;
    
    _modelDate = resultDateStr;
    
    CGFloat totalHeight = 49.5f;
    
    NSInteger up = (NSInteger)[NSString DecimalFuncWithOperatorType:3 first:@(model.like * totalHeight) secend:@(max) value:2].doubleValue;
    self.upHeightConstraint.constant = up;
    
    NSInteger down = (NSInteger)[NSString DecimalFuncWithOperatorType:3 first:@(model.very_dissatisfied * totalHeight) secend:@(max) value:2].doubleValue;
    self.downHeightConstraint.constant = down;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)respondsToUpBtn:(UIButton *)sender {
    NSLog(@"respondsToUpBtn");
    if (self.selectedBlock) {
        self.selectedBlock(_model.like, 0, _model.date_range);
    }
}

- (IBAction)respondsToDownBtn:(UIButton *)sender {
    NSLog(@"respondsToDownBtn");
    if (self.selectedBlock) {
        self.selectedBlock(_model.very_dissatisfied, 1, _model.date_range);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
