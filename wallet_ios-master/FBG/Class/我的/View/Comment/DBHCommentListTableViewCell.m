//
//  DBHCommentListTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCommentListTableViewCell.h"
#import "DBHProjectCommentAllListDetailModel.h"
#import "DBHProjectCommentUserModel.h"

@interface DBHCommentListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation DBHCommentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [UIImage setRoundForView:_photoImgView borderColor:nil];
}

- (void)setModel:(DBHProjectCommentAllListDetailModel *)model {
    _model = model;
    [self.photoImgView sdsetImageWithURL:model.user.img placeholderImage:[UIImage imageNamed:@"touxiang"]];
    self.nameLabel.text = model.user.name;
    self.timeLabel.text = [NSString formatTimeDelayEight:model.created_at];
    
    NSString *content = model.content;
    self.contentLabel.text = content;
    
    CGFloat width = CGRectGetWidth(self.contentLabel.frame);
    CGFloat height = [NSString getHeightWithString:content width:width lineSpacing:0 fontSize:15];
    
    _model.height = COMMENT_LIST_DEFAULT_HEIGHT + height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
