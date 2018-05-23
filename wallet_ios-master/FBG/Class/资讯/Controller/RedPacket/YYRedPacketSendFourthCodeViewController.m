//
//  YYRedPacketSendFourthCodeViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendFourthCodeViewController.h"
#import "DBHPlaceHolderTextView.h"

@interface YYRedPacketSendFourthCodeViewController ()
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@property (weak, nonatomic) IBOutlet UIView *senderView;
@property (weak, nonatomic) IBOutlet UITextField *senderNameTextField;

@property (weak, nonatomic) IBOutlet UIView *bestView;
@property (weak, nonatomic) IBOutlet DBHPlaceHolderTextView *bestTextView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *tipCopyBtn;

@end

@implementation YYRedPacketSendFourthCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redPacketNavigationBar];
}

#pragma mark ------- 父类方法 ---------
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

- (void)setNavigationTintColor {
    self.navigationController.navigationBar.tintColor = WHITE_COLOR;
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send RedPacket", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DBHGetStringWithKeyFromTable(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(respondsToDoneBarButtonItem)];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 4);
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    
    self.fourthLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Fourth", nil)];
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Generate style, Preview And Share", nil);
    
    self.styleLabel.text = self.styleStr;
    
    [self.senderView setBorderWidth:0.5f color:COLORFROM16(0xD9D9D9, 1)];
    [self.bestView setBorderWidth:0.5f color:COLORFROM16(0xD9D9D9, 1)];
    
    self.senderNameTextField.placeholder = DBHGetStringWithKeyFromTable(@"Sender Name", nil);
    self.bestTextView.placeholder = DBHGetStringWithKeyFromTable(@"Best / Message", nil);
    
    [self.sureBtn setCorner:2];
    
    [self.sureBtn setTitle:DBHGetStringWithKeyFromTable(@" Confirm ", nil) forState:UIControlStateNormal];
    
    [self.tipCopyBtn setTitle:DBHGetStringWithKeyFromTable(@"Click To Copy Code", nil) forState:UIControlStateNormal];
}

#pragma mark ----- RespondsToSelector ---------

/**
 完成 去分享
 */
- (void)respondsToDoneBarButtonItem {
    
}

/**
 点击复制
 */
- (IBAction)respondsToTipCopyBtn:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.codeLabel.text;
    [LCProgressHUD showMessage:DBHGetStringWithKeyFromTable(@"Copy success", nil)];
}


/**
 确认 生成代码

 @param sender sender
 */
- (IBAction)respondsToSureBtn:(UIButton *)sender {
    
}
@end
