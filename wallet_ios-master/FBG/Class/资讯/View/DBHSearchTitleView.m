//
//  DBHSearchTitleView.m
//  FBG
//
//  Created by 邓毕华 on 2018/2/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSearchTitleView.h"

@interface DBHSearchTitleView ()<UITextFieldDelegate>

@property (nonatomic, assign) BOOL isShowCancelBtn;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) SearchBlock searchBlock;

@end

@implementation DBHSearchTitleView

#pragma mark ------ Lifecycle ------
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setUI];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame isShowBtn:(BOOL)isShowCancelBtn {
    self = [super initWithFrame:frame];
    if (self) {
        self.isShowCancelBtn = isShowCancelBtn;
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.searchTextField];
    
    if (self.isShowCancelBtn) {
        [self addSubview:self.cancelButton];
    }
    
    WEAKSELF
    [self.searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(AUTOLAYOUTSIZE(15));
        if (weakSelf.isShowCancelBtn) {
            make.right.equalTo(weakSelf.cancelButton.mas_left);
        } else {
            make.right.offset(- AUTOLAYOUTSIZE(15));
        }
        make.height.offset(40);
        make.bottom.offset(- AUTOLAYOUTSIZE(2));
    }];
    
    if (self.isShowCancelBtn) {
        [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(weakSelf.searchTextField);
            make.width.offset(AUTOLAYOUTSIZE(66));
            make.right.equalTo(weakSelf);
        }];
    }
}

#pragma mark ------ UITextFieldDelegate ------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *changeAfterString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (!changeAfterString.length) {
        self.searchBlock(-1, nil);
    } else /**if (![string isEqualToString:@"\n"] && string.length != 0)*/ { //不是删除 和回车
        self.searchBlock(2, changeAfterString);
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.searchBlock(-1, nil);
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.searchBlock(1, textField.text);
    [textField endEditing:YES];
    return YES;
}

#pragma mark ------ Event Responds ------
/**
 取消
 */
- (void)respondsToCancelButton {
    self.searchBlock(0, nil);
}

#pragma mark ------ Public Methods ------
- (void)searchBlock:(SearchBlock)searchBlock {
    self.searchBlock = searchBlock;
}

#pragma mark ------ Getters And Setters ------
- (void)setSearchType:(NSInteger)searchType {
    _searchType = searchType;
    
    NSString *placeHolder = @"";
    switch (_searchType) {
        case 0:
            placeHolder = DBHGetStringWithKeyFromTable(@"News", nil);
            break;
        case 1:
            placeHolder = DBHGetStringWithKeyFromTable(@"Project", nil);
            break;
            
        default:
            break;
    }
    self.searchTextField.placeholder = placeHolder;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.backgroundColor = COLORFROM16(0xF6F6F6, 1);
        _searchTextField.layer.cornerRadius = 20;
        _searchTextField.font = FONT(13);
        _searchTextField.placeholder = @"";
        _searchTextField.textColor = COLORFROM16(0x333333, 1);
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AUTOLAYOUTSIZE(40), AUTOLAYOUTSIZE(40))];
        UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhuye_sousuo_ico"]];
        searchImageView.frame = CGRectMake(AUTOLAYOUTSIZE(15), AUTOLAYOUTSIZE(12.5), AUTOLAYOUTSIZE(15), AUTOLAYOUTSIZE(15));
        [leftView addSubview:searchImageView];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = FONT(18);
        [_cancelButton setTitle:DBHGetStringWithKeyFromTable(@"Cancel", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:COLORFROM16(0x333333, 1) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(respondsToCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
