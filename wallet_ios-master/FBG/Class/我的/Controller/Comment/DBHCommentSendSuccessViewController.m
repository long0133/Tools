//
//  DBHCommentSendSuccessViewController.m
//  FBG
//
//  Created by yy on 2018/4/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCommentSendSuccessViewController.h"
#import "DBHGradeView.h"
#import "DBHCommentDetailViewController.h"
#import "DBHProjectCommentModel.h"
#import "DBHSharePictureViewController.h"
#import "DBHBaseNavigationController.h"

@interface DBHCommentSendSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIView *whiteBgView;
@property (weak, nonatomic) IBOutlet UIView *leftCircleView;
@property (weak, nonatomic) IBOutlet UIView *rightCircleView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *myGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet DBHGradeView *gradeView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookCommentDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *captureBgView;

@end

@implementation DBHCommentSendSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login_close"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToCloseBarButtonItem)];
    
    self.view.backgroundColor = COLORFROM16(0xF8F8F8, 1);
    self.whiteBgView.layer.cornerRadius = AUTOLAYOUTSIZE(5);
    self.leftCircleView.layer.cornerRadius = CGRectGetHeight(self.leftCircleView.frame) / 2;
    self.rightCircleView.layer.cornerRadius = CGRectGetHeight(self.rightCircleView.frame) / 2;
    self.myGradeLabel.text = DBHGetStringWithKeyFromTable(@"My Rating", nil);
    
    [self.lookCommentDetailBtn setTitle:DBHGetStringWithKeyFromTable(@"To see the details of the evaluation", nil) forState:UIControlStateNormal];
    [self.shareBtn setTitle:DBHGetStringWithKeyFromTable(@"Share Picture", nil) forState:UIControlStateNormal];
    
    [self.iconImgView sdsetImageWithURL:self.model.category.img placeholderImage:[UIImage imageNamed:@"NEO_add"]];
    self.symbolLabel.text = self.model.category.name;
    self.nameLabel.text = self.model.category.long_name;
    self.descLabel.text = self.model.category.industry;
    CGFloat score = self.model.score.doubleValue;
    
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
    
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1f%@(%@)", score, DBHGetStringWithKeyFromTable(@"", nil), mark];
    self.gradeView.grade = score;
    
    NSString *comment = self.model.category_comment;
    if (comment.length == 0) {
        comment = DBHGetStringWithKeyFromTable(@"Default Comment", nil);
    }
    self.commentLabel.text = comment;
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageFromColor:WHITE_COLOR Rect:CGRectMake(0, 0, SCREENWIDTH, STATUSBARHEIGHT + 44)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark --- click event ------
- (void)respondsToCloseBarButtonItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)lookCommentDetailBtnClicked:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:COMMENTS_STORYBOARD_NAME bundle:nil];
    DBHCommentDetailViewController *detailVC = [sb instantiateViewControllerWithIdentifier:COMMENTDETAIL_STORYBOARD_ID];
    detailVC.model = self.model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)shareBtnClicked:(UIButton *)sender {
    UIImage *centerImg = [self imageFromView:self.captureBgView];
    [self pushToShareVC:centerImg];
}

- (void)pushToShareVC:(UIImage *)img {
    DBHSharePictureViewController *shareVC = [[DBHSharePictureViewController alloc] init];
    shareVC.longPictureImg = img;
    shareVC.footerBgColor = self.captureBgView.backgroundColor;
    DBHBaseNavigationController *navigationController = [[DBHBaseNavigationController alloc] initWithRootViewController:shareVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (UIImage *)imageFromView:(UIView *) theView {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(theView.width, theView.height), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
