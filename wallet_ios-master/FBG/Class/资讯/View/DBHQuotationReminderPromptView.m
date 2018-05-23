//
//  DBHQuotationReminderPromptView.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/7.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHQuotationReminderPromptView.h"

@interface DBHQuotationReminderPromptView ()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *maxPriceLabel;
@property (nonatomic, strong) UITextField *maxPriceTextField;
@property (nonatomic, strong) UILabel *minPriceLabel;
@property (nonatomic, strong) UITextField *minPriceTextField;
@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, copy) CommitBlock commitBlock;

@end

@implementation DBHQuotationReminderPromptView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = COLORFROM16(0x000000, 0.4);
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
        [self setUI];
        
        // 注册观察键盘的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.boxView]) {
        [self respondsToQuitButton];
    }
}

#pragma mark ------ NSNotificationCenter ------
/**
 键盘将要显示
 */
- (void)keyboardWillShow {
    WEAKSELF
    [self.boxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(- AUTOLAYOUTSIZE(150));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}
/**
 键盘将要隐藏
 */
- (void)keyboardWillHide {
    WEAKSELF
    [self.boxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.quitButton];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.promptLabel];
    [self.boxView addSubview:self.priceLabel];
    [self.boxView addSubview:self.maxPriceLabel];
    [self.boxView addSubview:self.maxPriceTextField];
    [self.boxView addSubview:self.minPriceLabel];
    [self.boxView addSubview:self.minPriceTextField];
    [self.boxView addSubview:self.commitButton];
    
    WEAKSELF
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(373.5));
    }];
    [self.quitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(AUTOLAYOUTSIZE(40));
        make.height.offset(AUTOLAYOUTSIZE(44));
        make.top.right.equalTo(weakSelf.boxView);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.boxView).offset(AUTOLAYOUTSIZE(15));
    }];
    [self.promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(10));
        make.centerX.equalTo(weakSelf.boxView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(AUTOLAYOUTSIZE(19));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(62.5));
        make.top.equalTo(weakSelf.promptLabel.mas_bottom).offset(AUTOLAYOUTSIZE(26.5));
    }];
    [self.maxPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.priceLabel);
        make.top.equalTo(weakSelf.priceLabel.mas_bottom).offset(AUTOLAYOUTSIZE(31));
    }];
    [self.maxPriceTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(111.5));
        make.right.offset(- AUTOLAYOUTSIZE(62.5));
        make.height.offset(AUTOLAYOUTSIZE(35));
        make.centerY.equalTo(weakSelf.maxPriceLabel);
    }];
    [self.minPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.priceLabel);
        make.centerY.equalTo(weakSelf.minPriceTextField);
    }];
    [self.minPriceTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.maxPriceTextField);
        make.centerX.equalTo(weakSelf.maxPriceTextField);
        make.top.equalTo(weakSelf.maxPriceTextField.mas_bottom).offset(AUTOLAYOUTSIZE(14.5));
    }];
    [self.commitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(108));
        make.height.offset(AUTOLAYOUTSIZE(40.5));
        make.centerX.equalTo(weakSelf.boxView);
        make.bottom.equalTo(weakSelf.boxView).offset(- AUTOLAYOUTSIZE(47.5));
    }];
}

#pragma mark ------ Event Responds ------
/**
 退出
 */
- (void)respondsToQuitButton {
    self.maxPriceTextField.text = @"";
    self.minPriceTextField.text = @"";
    WEAKSELF
    [self endEditing:YES];
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(AUTOLAYOUTSIZE(373.5));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ------ Event Responds ------
/**
 确定
 */
- (void)respondsToCommitButton {
    if (self.maxPriceTextField.text.doubleValue <= self.minPriceTextField.text.doubleValue) {
        [LCProgressHUD showFailure:DBHGetStringWithKeyFromTable(@"The highest value should be greater than the minimum", nil)];
        
        return;
    }
    self.commitBlock(self.maxPriceTextField.text, self.minPriceTextField.text);
    [self respondsToQuitButton];
}

#pragma mark ------ Public Methods ------
/**
 动画显示
 */
- (void)animationShow {
    WEAKSELF
    [self.boxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.offset(AUTOLAYOUTSIZE(373.5));
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}
- (void)commitBlock:(CommitBlock)commitBlock {
    self.commitBlock = commitBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setPrice:(NSString *)price {
    _price = price;
    
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@", DBHGetStringWithKeyFromTable(@"Current Price", nil), _price]];
    [priceAttributedString addAttribute:NSForegroundColorAttributeName value:COLORFROM16(0x262626, 1) range:NSMakeRange(0, DBHGetStringWithKeyFromTable(@"Current Price", nil).length + 1)];
    self.priceLabel.attributedText = priceAttributedString;
}
- (void)setMaxPrice:(NSString *)maxPrice {
    _maxPrice = maxPrice;
    
    self.maxPriceTextField.text = _maxPrice;
}
- (void)setMinPrice:(NSString *)minPrice {
    _minPrice = minPrice;
    
    self.minPriceTextField.text = _minPrice;
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
        _titleLabel.text = DBHGetStringWithKeyFromTable(@"Reminder", nil);
        _titleLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _titleLabel;
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.font = FONT(11);
        _promptLabel.text = DBHGetStringWithKeyFromTable(@"After setting the reminder, the system will push notifications at the Above/Below value of the quotation", nil);
        _promptLabel.textColor = COLORFROM16(0xD4D4D4, 1);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = FONT(13);
        _priceLabel.textColor = COLORFROM16(0xFC6F17, 1);
    }
    return _priceLabel;
}
- (UILabel *)maxPriceLabel {
    if (!_maxPriceLabel) {
        _maxPriceLabel = [[UILabel alloc] init];
        _maxPriceLabel.font = FONT(13);
        _maxPriceLabel.text = DBHGetStringWithKeyFromTable(@"Above", nil);
        _maxPriceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _maxPriceLabel;
}
- (UITextField *)maxPriceTextField {
    if (!_maxPriceTextField) {
        _maxPriceTextField = [[UITextField alloc] init];
        _maxPriceTextField.backgroundColor = COLORFROM16(0xF9F9F9, 1);
        _maxPriceTextField.font = FONT(13);
        _maxPriceTextField.textColor = COLORFROM16(0x333333, 1);
        _maxPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _maxPriceTextField.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AUTOLAYOUTSIZE(28.5), AUTOLAYOUTSIZE(35))];
        moneyLabel.font = FONT(14);
        moneyLabel.text = @"$";
        moneyLabel.textColor = COLORFROM16(0xBABABA, 1);
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        _maxPriceTextField.leftView = moneyLabel;
        _maxPriceTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _maxPriceTextField;
}
- (UILabel *)minPriceLabel {
    if (!_minPriceLabel) {
        _minPriceLabel = [[UILabel alloc] init];
        _minPriceLabel.font = FONT(13);
        _minPriceLabel.text = DBHGetStringWithKeyFromTable(@"Below", nil);
        _minPriceLabel.textColor = COLORFROM16(0x333333, 1);
    }
    return _minPriceLabel;
}
- (UITextField *)minPriceTextField {
    if (!_minPriceTextField) {
        _minPriceTextField = [[UITextField alloc] init];
        _minPriceTextField.backgroundColor = COLORFROM16(0xF9F9F9, 1);
        _minPriceTextField.font = FONT(13);
        _minPriceTextField.textColor = COLORFROM16(0x333333, 1);
        _minPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _minPriceTextField.layer.cornerRadius = AUTOLAYOUTSIZE(2);
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AUTOLAYOUTSIZE(28.5), AUTOLAYOUTSIZE(35))];
        moneyLabel.font = FONT(14);
        moneyLabel.text = @"$";
        moneyLabel.textColor = COLORFROM16(0xBABABA, 1);
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        _minPriceTextField.leftView = moneyLabel;
        _minPriceTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _minPriceTextField;
}
- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.backgroundColor = MAIN_ORANGE_COLOR;
        _commitButton.titleLabel.font = BOLDFONT(14);
        [_commitButton setTitle:DBHGetStringWithKeyFromTable(@"Confirm", nil) forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(respondsToCommitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

@end
