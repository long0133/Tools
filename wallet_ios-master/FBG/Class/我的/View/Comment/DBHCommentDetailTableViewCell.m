//
//  DBHCommentDetailTableViewCell.m
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCommentDetailTableViewCell.h"
#import "DBHGradeView.h"
#import "DBHProjectCommentDetailModel.h"
#import "DBHProjectCommentModel.h"
#import "DBHCommentReplyModel.h"

#define UP_TYPE @"up"
#define DOWN_TYPE @"down"
#define EQUAL_TYPE @"equal"

@interface DBHCommentDetailTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *photoImgView;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *markLabel;

@property (nonatomic, weak) IBOutlet DBHGradeView *gradeView;
@property (nonatomic, weak) IBOutlet UILabel *gradLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, weak) IBOutlet UILabel *titleLbel;
@property (nonatomic, weak) IBOutlet UILabel *askLabel;
@property (nonatomic, weak) IBOutlet UIButton *goodBtn; // 赞
@property (nonatomic, weak) IBOutlet UIButton *stampBtn; // 踩
@property (nonatomic, weak) IBOutlet UIButton *interestBtn; // 有趣
@property (nonatomic, weak) IBOutlet UIButton *commentBtn; // 评论

@end

@implementation DBHCommentDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _goodBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _stampBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _interestBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _commentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.askLabel.text = DBHGetStringWithKeyFromTable(@"Valuable comment?", nil);
    [UIImage setRoundForView:_photoImgView borderColor:nil];
    
//    [self.interestBtn setTitle:[NSString stringWithFormat:@"%@ 0", DBHGetStringWithKeyFromTable(@"Amusing", nil)] forState:UIControlStateNormal];
}

#pragma mark ----- responds ------
- (IBAction)respondsToGoodBtn:(UIButton *)sender {
    [self commentReply:sender type:UP_TYPE];
}

- (IBAction)respondsToStampBtn:(UIButton *)sender {
    [self commentReply:sender type:DOWN_TYPE];
}

- (IBAction)respondsToIntestBtn:(UIButton *)sender {
    [self commentReply:sender type:EQUAL_TYPE];
}

- (void)commentReply:(UIButton *)sender type:(NSString *)type {
    NSString *urlStr = [NSString stringWithFormat:@"category/%@/comment/%@/reply/%@", @(self.detailModel.category_id), @(self.detailModel.commentId), type];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper POST:urlStr baseUrlType:3 parameters:nil hudString:nil success:^(id responseObject) {
            [weakSelf handleResponse:responseObject sender:sender];
            [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_HAS_CHANGED object:nil];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    });
}

- (void)handleResponse:(id)respondsObj sender:(UIButton *)sender {
    if ([NSObject isNulllWithObject:respondsObj]) {
        return;
    }
    
    if ([respondsObj isKindOfClass:[NSDictionary class]]) {
        DBHCommentReplyModel *model = [DBHCommentReplyModel mj_objectWithKeyValues:respondsObj];
        [self setEvaluateBtnWithUp:model.up withDown:model.down withEqual:model.equal];
        
        NSArray *clickModels = self.detailModel.user_click_comment;
        NSMutableArray *arr = [NSMutableArray arrayWithArray:clickModels];
        if (arr.count > 0) {
            DBHProjectCommentUserClickCommentModel *clickModel = arr.firstObject;
            
            clickModel.up = model.up;
            clickModel.down = model.down;
            clickModel.equal = model.equal;
        }
        
        self.detailModel.user_click_comment = [NSArray arrayWithArray:arr];
        
        NSInteger count = 0;
        NSInteger resultCount = 0;
        if ([sender isEqual:self.stampBtn]) {
            count = self.detailModel.user_click_comment_down_count;
            resultCount = [self setCount:count bySender:sender];
            self.detailModel.user_click_comment_down_count = resultCount;
        } else if ([sender isEqual:self.interestBtn]) {
            count = self.detailModel.user_click_comment_equal_count;
            resultCount = [self setCount:count bySender:sender];
            self.detailModel.user_click_comment_equal_count = resultCount;
        } else {
            count = self.detailModel.user_click_comment_up_count;
            resultCount = [self setCount:count bySender:sender];
            self.detailModel.user_click_comment_up_count = resultCount;
        }
        
        NSString *title = [NSString stringWithFormat:@"%@", @(resultCount)];
        if ([sender isEqual:self.interestBtn]) {
//            title = [NSString stringWithFormat:@"%@ %@", DBHGetStringWithKeyFromTable(@"Amusing", nil), @(resultCount)];
            
            title = [NSString stringWithFormat:@"%@", @(resultCount)];
        }
        [sender setTitle:title forState:UIControlStateNormal];
        sender.titleLabel.text = title;
    }
}

- (NSInteger)setCount:(NSInteger)count bySender:(UIButton *)sender {
    if (sender.isSelected) { // +1
        count ++;
    } else { // -1
        if (count > 0) {
            count --;
        }
    }
    
    return count;
}

#pragma mark ----- setters ------
- (void)setFrom:(CellFrom)from {
    _from = from;
    
    self.goodBtn.userInteractionEnabled = (from == CellFromDetail);
    self.stampBtn.userInteractionEnabled = (self.selectionStyle == UITableViewCellSelectionStyleNone);
    self.interestBtn.userInteractionEnabled = (self.selectionStyle == UITableViewCellSelectionStyleNone);
}

- (void)setDetailModel:(DBHProjectCommentDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.nameLabel.text = detailModel.user.name;
    
    //http://inwecrypto-china.oss-cn-shanghai.aliyuncs.com/ios_header_1523700570.jpeg
    [self.photoImgView sdsetImageWithURL:detailModel.user.img placeholderImage:[UIImage imageNamed:@"touxiang"]];

    self.timeLabel.text = [NSString formatTimeDelayEight:detailModel.category_comment_at];
    
    NSString *markValue = detailModel.category_comment_tag_name;
    if (markValue.length > 0) {
        _markLabel.layer.borderColor = COLORFROM16(0x85B752, 1).CGColor;
        [_markLabel.layer setMasksToBounds:YES];
        [_markLabel.layer setCornerRadius:AUTOLAYOUTSIZE(3.0f)]; //设置圆角
        [_markLabel.layer setBorderWidth:AUTOLAYOUTSIZE(1.0)]; // 边框宽度
        self.markLabel.text = [NSString stringWithFormat:@" %@ ", markValue];
    } else {
        self.markLabel.text = @"";
    }
    
    
    CGFloat score = detailModel.score.doubleValue;
    self.gradeView.grade = score;
    self.gradLabel.text = [NSString stringWithFormat:@"%.1f%@", score, DBHGetStringWithKeyFromTable(@"", nil)];
    
    NSString *mark = nil;
    int index = floor(score); // 整数部分
    CGFloat value = score - index; // 小数部分
    if (index == 0) {
        mark = self.gradeView.titlesArr[index];
    } else if (index <= self.gradeView.titlesArr.count) {
        if (value > 0) { // 0.5
            mark = self.gradeView.titlesArr[index];
        } else {
            mark = self.gradeView.titlesArr[index - 1];
        }
    }
    
    self.descLabel.text = mark;
    
    NSString *comment = detailModel.category_comment;
    if (comment.length == 0) {
        comment = DBHGetStringWithKeyFromTable(@"Default Comment", nil);
    }
    self.titleLbel.text = comment;
    
    CGFloat commentWidth = CGRectGetWidth(self.titleLbel.frame);
    CGFloat askWidth = CGRectGetWidth(self.askLabel.frame);
    
    CGFloat commentHeight = [NSString getHeightWithString:self.titleLbel.text width:commentWidth lineSpacing:0 fontSize:15];
    CGFloat askHeight = [NSString getHeightWithString:self.askLabel.text width:askWidth lineSpacing:0 fontSize:12];
    _detailModel.height = COMMENT_DETAIL_DEFAULT_HEIGHT + commentHeight + askHeight;
    
    [self.goodBtn setTitle:[NSString stringWithFormat:@"%@", @(detailModel.user_click_comment_up_count)] forState:UIControlStateNormal];
    [self.stampBtn setTitle:[NSString stringWithFormat:@"%@", @(detailModel.user_click_comment_down_count)] forState:UIControlStateNormal];
    [self.interestBtn setTitle:[NSString stringWithFormat:@"%@", @(detailModel.user_click_comment_equal_count)] forState:UIControlStateNormal];
//    [self.interestBtn setTitle:[NSString stringWithFormat:@"%@ %@", DBHGetStringWithKeyFromTable(@"Amusing", nil), @(detailModel.user_click_comment_equal_count)] forState:UIControlStateNormal];
    
    if (detailModel.user_click_comment.count > 0) {
        DBHProjectCommentUserClickCommentModel *clickModel = detailModel.user_click_comment.firstObject;
        [self setEvaluateBtnWithUp:clickModel.up withDown:clickModel.down withEqual:clickModel.equal];
    }
    
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@", @(self.detailModel.comment_count)] forState:UIControlStateNormal];
}

- (void)setEvaluateBtnWithUp:(BOOL)up withDown:(BOOL)down withEqual:(BOOL)equal {
    self.goodBtn.selected = up;
    self.stampBtn.selected = down;
    self.interestBtn.selected = equal;
    
    if (self.selectionStyle != UITableViewCellSelectionStyleNone) {
        return;
    }
    // 没评价过
    if (!self.goodBtn.isSelected && !self.stampBtn.isSelected && !self.interestBtn.isSelected) {
        self.stampBtn.userInteractionEnabled = YES;
        self.interestBtn.userInteractionEnabled = YES;
        self.goodBtn.userInteractionEnabled = YES;
    } else {
        self.stampBtn.userInteractionEnabled = NO;
        self.interestBtn.userInteractionEnabled = NO;
        self.goodBtn.userInteractionEnabled = NO;
        if (self.goodBtn.isSelected) {
            self.goodBtn.userInteractionEnabled = YES;
        }
        if (self.stampBtn.isSelected) {
            self.stampBtn.userInteractionEnabled = YES;
        }
        
        if (self.interestBtn.isSelected) {
            self.interestBtn.userInteractionEnabled = YES;
        }
    }
}

//- (void)setCommentCount:(NSInteger)commentCount {
//    _commentCount = commentCount;
//    
//    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@", @(commentCount)] forState:UIControlStateNormal];
//}

- (void)setModel:(DBHProjectCommentModel *)model {
    _model = model;
    
    self.nameLabel.text = model.user.name;
    [self.photoImgView sdsetImageWithURL:model.user.img placeholderImage:[UIImage imageNamed:@"touxiang"]];
    self.timeLabel.text = [NSString formatTimeDelayEight:model.created_at];
    self.markLabel.text = [NSString stringWithFormat:@" %@ ", model.category_comment_tag_name];
    
    CGFloat score = model.score.doubleValue;
    self.gradeView.grade = score;
    self.gradLabel.text = [NSString stringWithFormat:@"%.1f%@", score, DBHGetStringWithKeyFromTable(@"", nil)];
    
    
    NSString *mark = nil;
    int index = floor(score); // 整数部分
    CGFloat value = score - index; // 小数部分
    if (index == 0) {
        mark = self.gradeView.titlesArr[index];
    } else if (index <= self.gradeView.titlesArr.count) {
        if (value > 0) { // 0.5
            mark = self.gradeView.titlesArr[index];
        } else {
            mark = self.gradeView.titlesArr[index - 1];
        }
    }
    
    self.descLabel.text = mark;
    
    self.titleLbel.text = model.category_comment;
    
    CGFloat commentWidth = CGRectGetWidth(self.titleLbel.frame);
    CGFloat askWidth = CGRectGetWidth(self.askLabel.frame);
    
    CGFloat commentHeight = [NSString getHeightWithString:self.titleLbel.text width:commentWidth lineSpacing:0 fontSize:15];
    CGFloat askHeight = [NSString getHeightWithString:self.askLabel.text width:askWidth lineSpacing:0 fontSize:12];
    _model.height = COMMENT_DETAIL_DEFAULT_HEIGHT + commentHeight + askHeight;
}

@end
