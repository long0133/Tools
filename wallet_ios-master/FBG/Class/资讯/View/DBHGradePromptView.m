//
//  DBHGradePromptView.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHGradePromptView.h"

@interface DBHGradePromptView ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, copy) GradeBlock gradeBlock;

@end

@implementation DBHGradePromptView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0x000000, 0.4);
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
        [self setUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.boxView]) {
        [self respondsToQuitButton];
    }
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.quitButton];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.gradeLabel];
    [self.boxView addSubview:self.commitButton];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(303));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(303));
    }];
    [self.quitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(44));
        make.top.right.equalTo(weakSelf.boxView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(21));
    }];
    [self.gradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(128));
    }];
    [self.commitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(47.5));
    }];
    
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        startButton.tag = 200 + i;
        [startButton setImage:[UIImage imageNamed:@"zhuye_jiaoyizhong_xing_ico"] forState:UIControlStateNormal];
        [startButton setImage:[UIImage imageNamed:@"xiangmuzhuye_xing_cio"] forState:UIControlStateSelected];
        [startButton addTarget:self action:@selector(respondsToStartButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.boxView addSubview:startButton];
        
        [startButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(AUTOLAYOUTSIZE(46));
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(57));
            if (!i) {
                make.left.offset((SCREENWIDTH - AUTOLAYOUTSIZE(230)) * 0.5);
            } else {
                make.left.equalTo([weakSelf viewWithTag:199 + i].mas_right);
            }
        }];
    }
}

#pragma mark ------ Event Responds ------
/**
 确定
 */
- (void)respondsToCommitButton {
    if (!self.commitButton.isSelected) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"The project has been graded", nil)];
        return;
    }
    
    NSString *grade = [self.gradeLabel.text substringToIndex:1];
    if ([grade isEqualToString:@"0"]) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Please Rating", nil)];
        
        return;
    }
    
    self.gradeBlock(grade.integerValue);
    [self respondsToQuitButton];
}
/**
 评分
 */
- (void)respondsToStartButton:(UIButton *)startButton {
    if (!self.canGrade) {
        [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"The project has been graded", nil)];
        return;
    }
    
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [self viewWithTag:200 + i];
        button.selected = button.tag <= startButton.tag;
    }
    self.gradeLabel.text = [NSString stringWithFormat:@"%ld%@", startButton.tag - 199, DBHGetStringWithKeyFromTable(@"", nil)];
}
/**
 退出
 */
- (void)respondsToQuitButton {
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(303));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(303));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ------ Public Methods ------
- (void)gradeBlock:(GradeBlock)gradeBlock {
    self.gradeBlock = gradeBlock;
}
/**
 动画显示
 */
- (void)animationShow {
    WEAKSELF
    [self.boxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(303));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

#pragma mark ------ Getters And Setters ------
- (void)setGrade:(NSInteger)grade {
    _grade = grade;
    
    if (!_grade) {
        return;
    }
    
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [self viewWithTag:200 + i];
        button.selected = button.tag - 200 < _grade;
    }
    self.gradeLabel.text = [NSString stringWithFormat:@"%ld%@", _grade, DBHGetStringWithKeyFromTable(@"", nil)];
}
- (void)setCanGrade:(BOOL)canGrade {
    _canGrade = canGrade;
    
    self.commitButton.selected = _canGrade;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = WHITE_COLOR;
    }
    return _boxView;
}
- (UIButton *)quitButton {
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(respondsToQuitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDFONT(18);
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"Rating", nil);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)gradeLabel {
    if (!_gradeLabel) {
        _gradeLabel = [[UILabel alloc] init];
        _gradeLabel.font = FONT(15);
        _gradeLabel.text = [NSString stringWithFormat:@"0%@", DBHGetStringWithKeyFromTable(@"", nil)];
        _gradeLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _gradeLabel;
}
- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.titleLabel.font = BOLDFONT(14);
        [_commitButton setBackgroundImage:[UIImage getImageFromColor:COLORFROM16(0xDADADA, 1) Rect:CGRectMake(0, 0, AUTOLAYOUTSIZE(400), AUTOLAYOUTSIZE(200))] forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage getImageFromColor:MAIN_ORANGE_COLOR Rect:CGRectMake(0, 0, AUTOLAYOUTSIZE(400), AUTOLAYOUTSIZE(200))] forState:UIControlStateSelected];
        [_commitButton setTitle:DBHGetStringWithKeyFromTable(@"Submit", nil) forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(respondsToCommitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

@end
