//
//  DBHProjectCommentSendViewController.m
//  FBG
//
//  Created by yy on 2018/4/6.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHProjectCommentSendViewController.h"
#import "DBHProjectDetailInformationDataModels.h"
#import "DBHPlaceHolderTextView.h"
#import "YYGradeStarHasBottomView.h"
#import "DBHCommentSendSuccessViewController.h"
#import "DBHBaseNavigationController.h"
#import "DBHProjectCommentModel.h"
#import "DBHProjectSurveyViewController.h"

#define GRADE_BTN_TAG_START 111
#define MYCOMMENTS_STORYBOARD_NAME @"MyComments"

@interface DBHProjectCommentSendViewController ()

@property (weak, nonatomic) IBOutlet UILabel *myGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *myGradeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *myGradeUnitLabel;

@property (weak, nonatomic) IBOutlet UIView *gradeView;

@property (weak, nonatomic) IBOutlet UIButton *joinedBtn;
@property (weak, nonatomic) IBOutlet UIButton *wantJoinBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet DBHPlaceHolderTextView *textView;

@end

@implementation DBHProjectCommentSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

/**

 */

- (void)setUI {
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@" Submit ", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToSendButton)];
    
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateSelected];
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self.view layoutIfNeeded];
    YYGradeStarHasBottomView *starView = [[YYGradeStarHasBottomView alloc] initWithItemWidth:AUTOLAYOUTSIZE(28) margin:AUTOLAYOUTSIZE(30)];
    starView.y = 10;
    starView.x = CGRectGetMidX(self.gradeView.frame) - starView.width / 2;
    WEAKSELF
    starView.scoreChangedBlock = ^(CGFloat score) {//监控评分
        weakSelf.myGradeValueLabel.text = [NSString stringWithFormat:@"%.1f",score];
    };
    [self.gradeView addSubview:starView];
    
    self.myGradeLabel.text = DBHGetStringWithKeyFromTable(@"My Rating", nil);
    self.myGradeUnitLabel.text = DBHGetStringWithKeyFromTable(@"", nil);

    self.joinedBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.wantJoinBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.lookBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.joinedBtn setTitle:DBHGetStringWithKeyFromTable(@"Joined", nil) forState:UIControlStateNormal];
    [self.wantJoinBtn setTitle:DBHGetStringWithKeyFromTable(@"Want to join", nil) forState:UIControlStateNormal];
    [self.lookBtn setTitle:DBHGetStringWithKeyFromTable(@"Circusee", nil) forState:UIControlStateNormal];
    
    [self.joinedBtn setCorner:3];
    [self.wantJoinBtn setCorner:3];
    [self.lookBtn setCorner:3];
    
    [self.joinedBtn setBackgroundColor:COLORFROM16(0x6BBD25, 1) forState:UIControlStateSelected];
    [self.wantJoinBtn setBackgroundColor:COLORFROM16(0x6BBD25, 1) forState:UIControlStateSelected];
    [self.lookBtn setBackgroundColor:COLORFROM16(0x6BBD25, 1) forState:UIControlStateSelected];
    
    [self.lookBtn setBackgroundColor:COLORFROM16(0xCECFD0, 1) forState:UIControlStateNormal];
    [self.wantJoinBtn setBackgroundColor:COLORFROM16(0xCECFD0, 1) forState:UIControlStateNormal];
    [self.joinedBtn setBackgroundColor:COLORFROM16(0xCECFD0, 1) forState:UIControlStateNormal];
    
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Not required", nil);
    self.textView.placeholder = DBHGetStringWithKeyFromTable(@"Your comment on the project", nil);
}

- (void)setProjectDetailModel:(DBHProjectDetailInformationModelData *)projectDetailModel {
    _projectDetailModel = projectDetailModel;
    
    NSString *titleStr = [NSString stringWithFormat:@"%@%@", projectDetailModel.name, DBHGetStringWithKeyFromTable(@"  Comment  ", nil)];
    self.title = titleStr;
}

- (void)pushToSendSuccessVC:(DBHProjectCommentModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_HAS_ADDED object:nil userInfo:nil];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:MYCOMMENTS_STORYBOARD_NAME bundle:nil];
    DBHCommentSendSuccessViewController *vc = [sb instantiateViewControllerWithIdentifier:COMMENTSENDSUCCESS_STORYBOARD_ID];
    DBHBaseNavigationController *nav = [[DBHBaseNavigationController alloc] initWithRootViewController:vc];
    vc.title = DBHGetStringWithKeyFromTable(@"Submitted", nil);
    vc.model = model;
    WEAKSELF
    [self presentViewController:nav animated:YES completion:^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)respondsToSendButton {
    NSString *comment = self.textView.text;
    if (comment.length > 0 && comment.length < 10) {
        [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Comments should contain 10 to 200 characters ", nil)];
        return;
    }
    
    NSInteger categoryId = self.projectDetailModel.dataIdentifier;
    NSString *urlStr = [NSString stringWithFormat:@"category/%@/comment", @(categoryId)];
    
    int type = 0;
    
    BOOL joined = self.joinedBtn.isSelected;
    if (joined) {
        type = 3;
    }
    
    BOOL wantJoin = self.wantJoinBtn.isSelected;
    if (wantJoin) {
        type = 1;
    }
    BOOL look = self.lookBtn.isSelected;
    if (look) {
        type = 2;
    }
    
    if (comment.length == 0) {
        comment = @"";
    }
    
    NSString *score = self.myGradeValueLabel.text;
    NSDictionary *params = @{
                             @"score" : @(score.doubleValue),
                             @"category_comment" : comment,
                             @"category_comment_tag_id" : [NSString stringWithFormat:@"%@", @(type)]
                             };
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        WEAKSELF
        [PPNetworkHelper POST:urlStr baseUrlType:3 parameters:params hudString:DBHGetStringWithKeyFromTable(@"Sending...", nil) success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:COMMENT_HAS_ADDED object:nil userInfo:nil];
                DBHProjectCommentModel *model = [DBHProjectCommentModel mj_objectWithKeyValues:responseObject];
                [weakSelf performSelectorOnMainThread:@selector(pushToSendSuccessVC:) withObject:model waitUntilDone:NO];
            }
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Send failed", nil)];
        }];
    });
}

- (IBAction)respondsToLookBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    self.wantJoinBtn.selected = NO;
    self.joinedBtn.selected = NO;
}

- (IBAction)respondsToWantJoinBtnBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    self.joinedBtn.selected = NO;
    self.lookBtn.selected = NO;
}

- (IBAction)respondsToJoinedBtnBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    self.wantJoinBtn.selected = NO;
    self.lookBtn.selected = NO;
}

@end
