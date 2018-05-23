//
//  YYRedPacketSendFourthLinkViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendFourthLinkViewController.h"
#import "DBHPlaceHolderTextView.h"
#import "YYRedPacketPreviewViewController.h"

@interface YYRedPacketSendFourthLinkViewController ()
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@property (weak, nonatomic) IBOutlet UIView *senderView;
@property (weak, nonatomic) IBOutlet UITextField *senderNameTextField;


@property (weak, nonatomic) IBOutlet UIView *bestView;
@property (weak, nonatomic) IBOutlet DBHPlaceHolderTextView *bestTextView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation YYRedPacketSendFourthLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redPacketNavigationBar];
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send RedPacket", nil);
    
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
    
    [self.shareBtn setCorner:2];
    
    [self.shareBtn setTitle:DBHGetStringWithKeyFromTable(@"Preview And Share", nil) forState:UIControlStateNormal];
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToShareBtn:(UIButton *)sender {
    NSString *bestStr = self.bestTextView.text;
    if (bestStr.length > 0 && bestStr.length < 10) {
        //YYTODO
        //        return;
    }
    
    YYRedPacketPreviewViewController *previewVC = [[YYRedPacketPreviewViewController alloc] init];
    [self.navigationController pushViewController:previewVC animated:YES];
}
    
@end
