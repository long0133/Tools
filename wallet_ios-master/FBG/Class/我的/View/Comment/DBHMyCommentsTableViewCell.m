//
//  DBHMyCommentsTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHMyCommentsTableViewCell.h"
#import "DBHGradeView.h"
#import "DBHProjectCommentModel.h"

@interface DBHMyCommentsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet DBHGradeView *gradeView;
@property (weak, nonatomic) IBOutlet UILabel *gradeValueLabel;

@end

@implementation DBHMyCommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gradeLabel.text = DBHGetStringWithKeyFromTable(@"Rating", nil);
}

- (void)setModel:(DBHProjectCommentModel *)model {
    CGFloat score = model.score.doubleValue;
    self.gradeView.grade = score;
    self.gradeValueLabel.text = [NSString stringWithFormat:@"%.1f%@", score, DBHGetStringWithKeyFromTable(@"", nil)];
    
    [self.iconImageView sdsetImageWithURL:model.category.img placeholderImage:[UIImage imageNamed:@"NEO_add"]]; //TODO
    self.symbolLabel.text = model.category.name;
    self.nameLabel.text = model.category.long_name;
    self.desLabel.text = model.category.industry;
}

@end
