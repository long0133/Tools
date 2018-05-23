//
//  YYRedPacketSendSecondViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//  

#import "YYRedPacketSendSecondViewController.h"
#import "DBHInputPasswordPromptView.h"
#import "YYRedPacketPackagingViewController.h"

@interface YYRedPacketSendSecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *poundageLabel;
@property (weak, nonatomic) IBOutlet UILabel *poundageValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UIButton *startCreateBtn;

@property (weak, nonatomic) IBOutlet UILabel *wallletAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseWalletBtn;


@property (weak, nonatomic) IBOutlet UILabel *walletMaxUseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletMaxUseValueLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (nonatomic, strong) DBHInputPasswordPromptView *inputPasswordPromptView;


@end

@implementation YYRedPacketSendSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self getPerRedPacketHandleFee];
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

#pragma mark ------- Data ---------
/**
 获取手续费
 */
- (void)getPerRedPacketHandleFee {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        EthmobileEthCall *call = EthmobileNewEthCall();
        
        NSString *contractAddr = TEST_REDPACKET_CONTRACT_ADDRESS;
        if ([APP_APIEHEAD isEqualToString:APIEHEAD1]) {
            contractAddr = REDPACKET_CONTRACT_ADDRESS;
        }
        
        NSError *error = nil;
        NSString *cost = [call redPacketTaxCost:contractAddr error:&error];
        if ([NSObject isNulllWithObject:cost]) {
            cost = @"0";
        }
        NSString *redbagHandleFee = [NSString DecimalFuncWithOperatorType:2 first:cost secend:@(self.redbag_number) value:0];
        
        NSString *minValue = [NSString DecimalFuncWithOperatorType:2 first:@"25200000000000" secend:@"90000" value:8];
        minValue = [NSString DecimalFuncWithOperatorType:3 first:minValue secend:@"21000" value:8];
        minValue = [NSString DecimalFuncWithOperatorType:3 first:minValue secend:@"1000000000000000000" value:8];
        
        NSString *maxValue = [NSString DecimalFuncWithOperatorType:2 first:@"2520120000000000" secend:@"90000" value:8];
        maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"21000"  value:8];
        maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"1000000000000000000" value:8];
        
        NSString *totalMinValue = [NSString DecimalFuncWithOperatorType:0 first:minValue secend:redbagHandleFee value:8];
        NSString *totalMaxValue = [NSString DecimalFuncWithOperatorType:0 first:maxValue secend:redbagHandleFee value:8];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *number = [NSString notRounding:totalMinValue afterPoint:8];
            self.minLabel.text = [NSString stringWithFormat:@"%.8lf", number.doubleValue];
            
            number = [NSString notRounding:totalMaxValue afterPoint:8];
            self.maxLabel.text = [NSString stringWithFormat:@"%.8lf", number.doubleValue];
            self.slider.minimumValue = totalMinValue.doubleValue;
            self.slider.maximumValue = totalMaxValue.doubleValue;
            self.slider.value = totalMinValue.doubleValue;
        });
    });
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.backIndex = 2;
    self.title = DBHGetStringWithKeyFromTable(@"Send RedPacket", nil);
    
    self.secondLabel.text = DBHGetStringWithKeyFromTable(@"Second:", nil);
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Pay Some Poundage, Finish The Creation of Red Packet", nil);
    self.walletMaxUseTitleLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Max Avaliable Amount", nil)];
    self.poundageLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Fees", nil)];
    
    [self.startCreateBtn setTitle:DBHGetStringWithKeyFromTable(@"Start Create Red Packet", nil) forState:UIControlStateNormal];
    [self.startCreateBtn setCorner:2];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 4);
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    [self.slider addTarget:self action:@selector(respondsToGasSlider) forControlEvents:UIControlEventValueChanged];
    self.slider.value = 0;
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToStartCreateBtn:(id)sender {
    [[UIApplication sharedApplication].keyWindow addSubview:self.inputPasswordPromptView];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.inputPasswordPromptView animationShow];
    });
}

- (IBAction)respondsToChooseWalletBtn:(UIButton *)sender {
}

- (void)respondsToGasSlider {
    self.poundageLabel.text = [NSString stringWithFormat:@"%@", @(self.slider.value)];
}
#pragma mark ----- Setters And Getters ---------
- (DBHInputPasswordPromptView *)inputPasswordPromptView {
    if (!_inputPasswordPromptView) {
        _inputPasswordPromptView = [[DBHInputPasswordPromptView alloc] init];
        
        _inputPasswordPromptView.placeHolder = DBHGetStringWithKeyFromTable(@"Please input a password", nil);
        WEAKSELF
        [_inputPasswordPromptView commitBlock:^(NSString *password) {
            //YYTODO 去打包
            YYRedPacketPackagingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:REDPACKET_PACKAGING_STORYBOARD_ID];
            vc.packageType = PackageTypeRedPacket;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _inputPasswordPromptView;
}
@end
