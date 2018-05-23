//
//  DBHFeedbackViewController.m
//  FBG
//
//  Created by yy on 2018/3/13.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHFeedbackViewController.h"
#import "DBHPlaceHolderTextView.h"

@interface DBHFeedbackViewController ()

@property (nonatomic, strong) UIView *firstBgView;
@property (nonatomic, strong) UIButton *functionalBtn;
@property (nonatomic, strong) UIButton *contentBtn;
@property (nonatomic, strong) UIButton *otherBtn;

@property (nonatomic, strong) UIView *secondBgView;
@property (nonatomic, strong) DBHPlaceHolderTextView *feedbackTextView;

@property (nonatomic, strong) UIView *thirdBgView;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation DBHFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationUI];
    [self setUI];
}

#pragma mark - UI设置
- (void)setNavigationUI {
    self.title = DBHGetStringWithKeyFromTable(@"Feedback", nil);
}

- (void)setUI {
    self.view.backgroundColor = LIGHT_WHITE_BGCOLOR;
    [self.view addSubview:self.firstBgView];
    WEAKSELF
    [self.firstBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(AUTOLAYOUTSIZE(10));
        make.width.centerX.equalTo(weakSelf.view);
        make.height.offset(AUTOLAYOUTSIZE(50));
    }];
    
    [self.firstBgView addSubview:self.functionalBtn];
    [self.functionalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.firstBgView);
        make.top.left.equalTo(weakSelf.firstBgView).offset(AUTOLAYOUTSIZE(10));
        make.width.greaterThanOrEqualTo(@AUTOLAYOUTSIZE(80));
    }];
    
    [self.firstBgView addSubview:self.contentBtn];
    [self.contentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.firstBgView);
        make.left.equalTo(weakSelf.functionalBtn.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.top.equalTo(weakSelf.functionalBtn);
        make.width.equalTo(weakSelf.functionalBtn);
    }];
    
    [self.firstBgView addSubview:self.otherBtn];
    [self.otherBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.firstBgView);
        make.left.equalTo(weakSelf.contentBtn.mas_right).offset(AUTOLAYOUTSIZE(10));
        make.top.equalTo(weakSelf.contentBtn);
        make.width.equalTo(weakSelf.functionalBtn);
    }];
    
    [self.view addSubview:self.thirdBgView];
    [self.thirdBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(weakSelf.view);
        make.height.equalTo(@(AUTOLAYOUTSIZE(250)));
    }];
    
    [self.view addSubview:self.secondBgView];
    [self.secondBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstBgView.mas_bottom).offset(AUTOLAYOUTSIZE(12));
        make.width.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.thirdBgView.mas_top).offset(-AUTOLAYOUTSIZE(12));
    }];
    
    [self.secondBgView addSubview:self.feedbackTextView];
    [self.feedbackTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.secondBgView).offset(-AUTOLAYOUTSIZE(20));
        make.center.equalTo(weakSelf.secondBgView);
        make.top.equalTo(weakSelf.secondBgView).offset(AUTOLAYOUTSIZE(20));
    }];
    
    
    [self.thirdBgView addSubview:self.contactLabel];
    [self.contactLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(10));
        make.top.offset(AUTOLAYOUTSIZE(36));
        make.width.equalTo(@(AUTOLAYOUTSIZE([NSString getWidthtWithString:weakSelf.contactLabel.text fontSize:14])));
    }];
    
    [self.thirdBgView addSubview:self.phoneTextField];
    [self.phoneTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-AUTOLAYOUTSIZE(50));
        make.height.equalTo(@(AUTOLAYOUTSIZE(40)));
        make.centerY.equalTo(weakSelf.contactLabel);
        make.left.equalTo(weakSelf.contactLabel.mas_right).offset(AUTOLAYOUTSIZE(8));
    }];
    
    [self.thirdBgView addSubview:self.commitBtn];
    [self.commitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-AUTOLAYOUTSIZE(44));
        make.width.equalTo(weakSelf.view).offset(-AUTOLAYOUTSIZE(100));
        make.height.equalTo(@(AUTOLAYOUTSIZE(45)));
    }];
    
}

#pragma mark - 响应按钮事件
- (void)respondsToFunctionalBtn:(UIButton *)btn {
    if (!btn.isSelected) {
        btn.selected = YES;
    }
    self.contentBtn.selected = NO;
    self.otherBtn.selected = NO;
}

- (void)respondsToContentBtn:(UIButton *)btn  {
    if (!btn.isSelected) {
        btn.selected = YES;
    }
    self.functionalBtn.selected = NO;
    self.otherBtn.selected = NO;
}

- (void)respondsToOtherBtn:(UIButton *)btn  {
    if (!btn.isSelected) {
        btn.selected = YES;
    }
    self.contentBtn.selected = NO;
    self.functionalBtn.selected = NO;
}

- (void)respondsToCommitBtn {
    if (![UserSignData share].user.isLogin) {
        [[AppDelegate delegate] goToLoginVC:self];
        return;
    }
    
    if ([NSObject isNulllWithObject:self.feedbackTextView.text]) {
        [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Content cannot be empty", nil)];
        return;
    }
    
    if ([NSObject isNulllWithObject:self.phoneTextField.text]) {
        [LCProgressHUD showInfoMsg:DBHGetStringWithKeyFromTable(@"Contact cannot be empty", nil)];
        return;
    }
    
    int type = 1;
    if (self.contentBtn.isSelected) {
        type = 2;
    } else if (self.otherBtn.isSelected) {
        type = 3;
    }
    
    NSDictionary *dict = @{@"type" : @(type),
                           @"content" : self.feedbackTextView.text,
                           @"contact" : self.phoneTextField.text
                           };
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        [PPNetworkHelper POST:@"user/feedbackc" baseUrlType:3 parameters:dict hudString:DBHGetStringWithKeyFromTable(@"Sending...", nil) success:^(id responseObject) {
            [LCProgressHUD showSuccess:DBHGetStringWithKeyFromTable(@"Send successfully", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"Send failed", nil)];
        }];
    });
}

#pragma mark - UIView的创建
- (UIView *)firstBgView {
    if (!_firstBgView) {
        _firstBgView = [[UIView alloc] init];
        _firstBgView.backgroundColor = WHITE_COLOR;
    }
    return _firstBgView;
}

- (UIButton *)functionalBtn {
    if (!_functionalBtn) {
        _functionalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_functionalBtn setTitle:DBHGetStringWithKeyFromTable(@"Functional", nil) forState:UIControlStateNormal];
        [_functionalBtn addTarget:self action:@selector(respondsToFunctionalBtn:) forControlEvents:UIControlEventTouchUpInside];
        _functionalBtn.titleLabel.font = FONT(14);
        [_functionalBtn setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
        [_functionalBtn setTitleColor:MAIN_ORANGE_COLOR forState:UIControlStateNormal];
        [_functionalBtn setBackgroundColor:WHITE_COLOR forState:UIControlStateNormal];
        [_functionalBtn setBackgroundColor:[UIColor highLightedColor:WHITE_COLOR] forState:UIControlStateHighlighted];
        [_functionalBtn setBackgroundColor:MAIN_ORANGE_COLOR forState:UIControlStateSelected];
        [_functionalBtn setBorderWidth:1.0f color:MAIN_ORANGE_COLOR];
        
        [_functionalBtn setSelected:YES];
        
    }
    return _functionalBtn;
}

- (UIButton *)contentBtn {
    if (!_contentBtn) {
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_contentBtn setTitle:DBHGetStringWithKeyFromTable(@"Content", nil) forState:UIControlStateNormal];
        [_contentBtn addTarget:self action:@selector(respondsToContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        _contentBtn.titleLabel.font = FONT(14);
        [_contentBtn setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
        [_contentBtn setTitleColor:MAIN_ORANGE_COLOR forState:UIControlStateNormal];
        [_contentBtn setBackgroundColor:WHITE_COLOR forState:UIControlStateNormal];
        [_contentBtn setBackgroundColor:[UIColor highLightedColor:WHITE_COLOR] forState:UIControlStateHighlighted];
        [_contentBtn setBackgroundColor:MAIN_ORANGE_COLOR forState:UIControlStateSelected];
        [_contentBtn setBorderWidth:1.0f color:MAIN_ORANGE_COLOR];
        
    }
    return _contentBtn;
}

- (UIButton *)otherBtn {
    if (!_otherBtn) {
        _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_otherBtn setTitle:DBHGetStringWithKeyFromTable(@"Other ", nil) forState:UIControlStateNormal];
        [_otherBtn addTarget:self action:@selector(respondsToOtherBtn:) forControlEvents:UIControlEventTouchUpInside];
        _otherBtn.titleLabel.font = FONT(14);
        [_otherBtn setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
        [_otherBtn setTitleColor:MAIN_ORANGE_COLOR forState:UIControlStateNormal];
        [_otherBtn setBackgroundColor:WHITE_COLOR forState:UIControlStateNormal];
        [_otherBtn setBackgroundColor:[UIColor highLightedColor:WHITE_COLOR] forState:UIControlStateHighlighted];
        [_otherBtn setBackgroundColor:MAIN_ORANGE_COLOR forState:UIControlStateSelected];
        [_otherBtn setBorderWidth:1.0f color:MAIN_ORANGE_COLOR];
    }
    return _otherBtn;
}

- (UIView *)secondBgView {
    if (!_secondBgView) {
        _secondBgView = [[UIView alloc] init];
        _secondBgView.backgroundColor = WHITE_COLOR;
    }
    return _secondBgView;
}

- (DBHPlaceHolderTextView *)feedbackTextView {
    if (!_feedbackTextView) {
        _feedbackTextView = [[DBHPlaceHolderTextView alloc] init];
        _feedbackTextView.layer.cornerRadius = AUTOLAYOUTSIZE(3);
        _feedbackTextView.layer.borderColor = COLORFROM10(240, 240, 240, 1).CGColor;
        _feedbackTextView.layer.borderWidth = AUTOLAYOUTSIZE(1);
        
        _feedbackTextView.placeholder = DBHGetStringWithKeyFromTable(@"We hope to hear your valuable comments and feedback", nil);
    }

    return _feedbackTextView;
}

- (UIView *)thirdBgView {
    if (!_thirdBgView) {
        _thirdBgView = [[UIView alloc] init];
        _thirdBgView.backgroundColor = WHITE_COLOR;
    }
    return _thirdBgView;
}

- (UILabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = [[UILabel alloc] init];
        _contactLabel.textColor = COLORFROM16(0x333333, 1);
        _contactLabel.text = DBHGetStringWithKeyFromTable(@"Contact", nil); //
        _contactLabel.font = FONT(14);
    }
    return _contactLabel;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.font = FONT(14);
        _phoneTextField.textColor = COLORFROM16(0x333333, 1);
        _phoneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _phoneTextField.placeholder = DBHGetStringWithKeyFromTable(@"Phone / QQ / Email", nil);
        
        _phoneTextField.layer.borderColor = COLORFROM10(240, 240, 240, 1).CGColor;
        _phoneTextField.layer.cornerRadius = AUTOLAYOUTSIZE(3);
        _phoneTextField.layer.borderWidth = AUTOLAYOUTSIZE(1);
        
        //设置左边视图的宽度
        
        _phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
        
        //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneTextField;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [_commitBtn setTitle:DBHGetStringWithKeyFromTable(@"Submit", nil) forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(respondsToCommitBtn) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.titleLabel.font = FONT(14);
        [_commitBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [_commitBtn setBackgroundColor:MAIN_ORANGE_COLOR];
    }
    return _commitBtn;
}
@end
