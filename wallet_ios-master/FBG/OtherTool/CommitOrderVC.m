//
//  CommitOrderVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/31.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "CommitOrderVC.h"

@interface CommitOrderVC ()

@end

@implementation CommitOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewSingleTap)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.maskView addGestureRecognizer:singleRecognizer];
    self.alertContView.layer.cornerRadius = 5;
    self.alertContView.layer.masksToBounds = YES;
    
    NSString * min = [NSString DecimalFuncWithOperatorType:2
                                                     first:[NSString DecimalFuncWithOperatorType:3
                                                                                           first:[NSString DecimalFuncWithOperatorType:2 first:@"0.00002520" secend:@"1000000000000000000" value:8]
                                                                                          secend:@"90000"
                                                                                           value:8]
                                                    secend:[NSString stringWithFormat:@"%d",[_gas intValue]]
                                                     value:8];
    NSString * max = [NSString DecimalFuncWithOperatorType:2
                                                     first:[NSString DecimalFuncWithOperatorType:3
                                                                                           first:[NSString DecimalFuncWithOperatorType:2 first:@"0.00252012" secend:@"1000000000000000000" value:8]
                                                                                          secend:@"90000"
                                                                                           value:8]
                                                    secend:[NSString stringWithFormat:@"%d",[_gas intValue]]
                                                     value:8];
    self.priceSilder.minimumValue = [[NSString DecimalFuncWithOperatorType:3 first:[NSString stringWithFormat:@"%@",min] secend:@"1000000000000000000" value:8] floatValue];
    self.priceSilder.maximumValue = [[NSString DecimalFuncWithOperatorType:3 first:[NSString stringWithFormat:@"%@",max] secend:@"1000000000000000000" value:8] floatValue];
    self.priceSilder.continuous = YES;// 设置可连续变化
    
    self.banalceLB.text = [NSString stringWithFormat:@"(当前余额:%@)",self.banalce];
    self.changesPriceLB.text = self.changesPrice;
    self.orderLB.text = self.orderTitle;
    self.transferAddressLB.text = self.transferAddress;
    self.addressLB.text = self.address;
    
    [self.priceSilder setValue:[self.changesPrice floatValue]];
}


- (IBAction)priceSilderChange:(id)sender
{
    //滑块  0.00002520   ~  0.00252012    * 21000 单位
    if ((long)(self.priceSilder.value * 100000000) % 5 == 0)
    {
        self.gas = [NSString DecimalFuncWithOperatorType:3 first:[NSString stringWithFormat:@"%f",self.priceSilder.value] secend:[NSString stringWithFormat:@"%d",self.defaultGasNum] value:0];
        
        self.changesPrice = [NSString stringWithFormat:@"%f",self.priceSilder.value];
        self.changesPriceLB.text = [NSString stringWithFormat:@"%f",self.priceSilder.value];
    }
}

- (void)maskViewSingleTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)SureButtonCilick:(id)sender
{
    //钱包余额判断   手续费 + 转账金额 <= ether钱包余额
    if (self.priceTF.text.length == 0)
    {
        [LCProgressHUD showMessage:@"请输入正确价格"];
        return;
    }
    
    NSComparisonResult result = [NSString DecimalFuncComparefirst:self.priceTF.text secend:self.banalce];
    if (result == NSOrderedDescending)
    {
        [LCProgressHUD showMessage:@"钱包余额不足"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(comiitButtonCilickWithchangesPrice:gasprice:)])
    {
        [self.delegate comiitButtonCilickWithchangesPrice:self.changesPrice gasprice:self.gas];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
