//
//  YYEvaluateGradeHeaderView.m
//  FBG
//
//  Created by yy on 2018/4/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYEvaluateGradeHeaderView.h"
#import "DBHGradeView.h"
#import "YYEvaluateSynthesisModel.h"
#import "YYEvaluateTagsData.h"

@interface YYEvaluateGradeHeaderView()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet DBHGradeView *gradeView;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeTipLabel;

@property (weak, nonatomic) IBOutlet D5FlowButtonView *tagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightConstraint;
@end

@implementation YYEvaluateGradeHeaderView

- (id)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYEvaluateGradeHeaderView class]) owner:nil options:nil] lastObject];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYEvaluateGradeHeaderView class]) owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.text = DBHGetStringWithKeyFromTable(@" Rating ", nil);
    self.gradeView.grade = 0;
    self.gradeLabel.text = [NSString stringWithFormat:@"0%@", DBHGetStringWithKeyFromTable(@"", nil)];
    self.gradeTipLabel.text = [NSString stringWithFormat:@"0%@", DBHGetStringWithKeyFromTable(@"Commented", nil)];
}

- (void)setTagsData:(YYEvaluateTagsData *)tagsData withDelegate:(id<D5FlowButtonViewDelegate>)delegate {
    [tagsData setData:tagsData viewWidth:CGRectGetWidth(self.tagView.frame)];
    
    self.tagViewHeightConstraint.constant = tagsData.height;
    
    if (tagsData.buttonList.count > 0) {
        [self.tagView setData:tagsData.buttonList withDelegate:delegate];
    }
}

- (void)setSynthModel:(YYEvaluateSynthesisModel *)synthModel {
    _synthModel = synthModel;
    
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1f%@", synthModel.score_avg, DBHGetStringWithKeyFromTable(@"", nil)];
    self.gradeView.grade = synthModel.score_avg;
    self.gradeTipLabel.text = [NSString stringWithFormat:@"%@%@", @(synthModel.total), DBHGetStringWithKeyFromTable(@"Commented", nil)];
}

@end
