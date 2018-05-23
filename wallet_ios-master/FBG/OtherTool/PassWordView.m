//
//  PassWordView.m
//  FBG
//
//  Created by mac on 2017/7/30.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "PassWordView.h"

@interface PassWordView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *canelButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UITextField *passWorldTF;

@end

@implementation PassWordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.passWorldTF.delegate = self;
//    self.layer.cornerRadius = 10;
//    self.layer.masksToBounds = YES;
    
    [self.canelButton setTitle:DBHGetStringWithKeyFromTable(@"Cancel", nil) forState:UIControlStateNormal];
    [self.commitButton setTitle:DBHGetStringWithKeyFromTable(@"Determine", nil) forState:UIControlStateNormal];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)begainFirstResponder
{
    [self.passWorldTF becomeFirstResponder];
}

- (void)clean
{
    self.passWorldTF.text = @"";
}


- (IBAction)canelButtonCilick:(id)sender
{
    //取消
    if ([self.delegate respondsToSelector:@selector(canel)])
    {
        [self.delegate canel];
    }
    [self.passWorldTF resignFirstResponder];
    [self clean];
}

- (IBAction)sureButtonCilick:(id)sender
{
    //确定
    if (![NSString isPassword:self.passWorldTF.text])
    {
        [LCProgressHUD showMessage:@"请输入正确的密码格式"];
//        return;
    }
    if ([self.delegate respondsToSelector:@selector(sureWithPassWord:)])
    {
        [self.delegate sureWithPassWord:self.passWorldTF.text];
    }
    [self.passWorldTF resignFirstResponder];
    [self clean];
}


@end
