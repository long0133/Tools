//
//  YYEvaluateGradeTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYEvaluateGradeTableViewCell.h"
#import "DBHGradeView.h"
#import "YYEvaluateSynthesisModel.h"
#import "DBHProjectCommentModel.h"

#define PERCENT_LEFT_DEFAULT 12
#define GRADE_WIDTH_TOTAL 125

@interface YYEvaluateGradeTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *myGradeBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myGradeBgHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *myGradeTitleLabel;
@property (weak, nonatomic) IBOutlet DBHGradeView *myGradeView;
@property (weak, nonatomic) IBOutlet UILabel *myGradeValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeUnitLabel;

@property (weak, nonatomic) IBOutlet DBHGradeView *gradeView;
@property (weak, nonatomic) IBOutlet UILabel *gradeTipLabel;

@property (weak, nonatomic) IBOutlet UILabel *fiveTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *fivePercentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveLeftConstraint;

@property (weak, nonatomic) IBOutlet UILabel *fourTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *fourPercentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourLeftConstraint;


@property (weak, nonatomic) IBOutlet UILabel *threeTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *threePercentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeLeftConstraint;

@property (weak, nonatomic) IBOutlet UILabel *twoTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *twoPercentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLeftConstraint;

@property (weak, nonatomic) IBOutlet UILabel *oneTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *onePercentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLeftConstraint;

@end

@implementation YYEvaluateGradeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.gradeUnitLabel.text = DBHGetStringWithKeyFromTable(@"", nil);
    self.gradeTipLabel.text = [NSString stringWithFormat:@"%d%@", 0, DBHGetStringWithKeyFromTable(@"Commented", nil)];
    
    self.myGradeTitleLabel.text = DBHGetStringWithKeyFromTable(@"My Rating", nil);
    
    self.fiveTitleLabel.text = self.gradeView.titlesArr[4];
    self.fourTitleLabel.text = self.gradeView.titlesArr[3];
    self.threeTitleLabel.text = self.gradeView.titlesArr[2];
    self.twoTitleLabel.text = self.gradeView.titlesArr[1];
    self.oneTitleLabel.text = self.gradeView.titlesArr[0];
    
    self.gradeView.grade = 0;
    
    self.myGradeBgView.hidden = YES;
    self.myGradeBgHeightConstraint.constant = 0;
    
    
}

- (void)setModel:(YYEvaluateSynthesisModel *)model {
    _model = model;
    
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1f", model.score_avg];
    self.gradeView.grade = model.score_avg;
    self.gradeTipLabel.text = [NSString stringWithFormat:@"%@%@", @(model.total), DBHGetStringWithKeyFromTable(@"Commented", nil)];
    
    CGFloat value = model.total;
    self.onePercentLabel.text = [NSString stringWithFormat:@"%.1f%%", [NSString DecimalFuncWithOperatorType:3 first:@(model.very_dissatisfied * 100) secend:@(value) value:1].doubleValue];
    self.twoPercentLabel.text = [NSString stringWithFormat:@"%.1f%%", [NSString DecimalFuncWithOperatorType:3 first:@(model.dissatisfied * 100) secend:@(value) value:1].doubleValue];
    self.threePercentLabel.text = [NSString stringWithFormat:@"%.1f%%", [NSString DecimalFuncWithOperatorType:3 first:@(model.good * 100) secend:@(value) value:1].doubleValue];
    self.fourPercentLabel.text = [NSString stringWithFormat:@"%.1f%%", [NSString DecimalFuncWithOperatorType:3 first:@(model.recommend * 100) secend:@(value) value:1].doubleValue];
    self.fivePercentLabel.text = [NSString stringWithFormat:@"%.1f%%", [NSString DecimalFuncWithOperatorType:3 first:@(model.like * 100) secend:@(value) value:1].doubleValue];
    
    self.oneLeftConstraint.constant = model.very_dissatisfied > 0 ? PERCENT_LEFT_DEFAULT : 0;
    self.twoLeftConstraint.constant = model.dissatisfied > 0 ? PERCENT_LEFT_DEFAULT : 0;
    self.threeLeftConstraint.constant = model.good > 0 ? PERCENT_LEFT_DEFAULT : 0;
    self.fourLeftConstraint.constant = model.recommend > 0 ? PERCENT_LEFT_DEFAULT : 0;
    self.fiveLeftConstraint.constant = model.like > 0 ? PERCENT_LEFT_DEFAULT : 0;
    
    self.oneWidthConstraint.constant = [NSString DecimalFuncWithOperatorType:3 first:@(model.very_dissatisfied) secend:@(model.total) value:1].doubleValue * AUTOLAYOUTSIZE(GRADE_WIDTH_TOTAL);
    self.twoWidthConstraint.constant = [NSString DecimalFuncWithOperatorType:3 first:@(model.dissatisfied) secend:@(model.total) value:1].doubleValue * AUTOLAYOUTSIZE(GRADE_WIDTH_TOTAL);
    self.threeWidthConstraint.constant = [NSString DecimalFuncWithOperatorType:3 first:@(model.good) secend:@(model.total) value:1].doubleValue * AUTOLAYOUTSIZE(GRADE_WIDTH_TOTAL);
    self.fourWidthConstraint.constant = [NSString DecimalFuncWithOperatorType:3 first:@(model.recommend) secend:@(model.total) value:1].doubleValue * AUTOLAYOUTSIZE(GRADE_WIDTH_TOTAL);
    self.fiveWidthConstraint.constant = [NSString DecimalFuncWithOperatorType:3 first:@(model.like) secend:@(model.total) value:1].doubleValue * AUTOLAYOUTSIZE(GRADE_WIDTH_TOTAL);
}

- (void)setMyCommentModel:(DBHProjectCommentModel *)myCommentModel {
    _myCommentModel = myCommentModel;
    
    if (!myCommentModel || myCommentModel.is_category_comment == 0) {
        self.myGradeBgHeightConstraint.constant = 0;
        self.myGradeBgView.hidden = YES;
    } else {
        self.myGradeBgHeightConstraint.constant = MYGRADEBG_HEIGHT;
        self.myGradeBgView.hidden = NO;
        
        self.myGradeView.grade = myCommentModel.score.doubleValue;
        self.myGradeValueLabel.text = [NSString stringWithFormat:@"%.1f%@", myCommentModel.score.doubleValue, DBHGetStringWithKeyFromTable(@"", nil)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
