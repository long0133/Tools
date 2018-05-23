//
//  PayPriceView.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/12.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "PayPriceView.h"

@implementation PayPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [PayPriceView loadViewFromXIB];
        self.frame = frame;
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewSingleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self.maskView addGestureRecognizer:singleRecognizer];
        self.alertContView.layer.cornerRadius = 5;
        self.alertContView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)showWithView:(UIView *)view
{
    if (view)
    {
        [view addSubview:self];
    }
    else
    {
        [self addToWindow];
    }
    
    [self.alertContView springingAnimation];
}

- (void)canel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.alertContView.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        self.maskView.alpha = 0.4;
        self.alertContView.alpha = 1;
        self.priceTF.text = @"";
        self.remarkTF.text = @"";
        if ([UserSignData share].user.walletUnitType == 1) {
            self.rmbPriceLB.text = @"≈￥0.00";
        } else {
            self.rmbPriceLB.text = @"≈$0.00";
        }
        
    }];
    
}

- (void)maskViewSingleTap
{
    [self canel];
}

- (IBAction)SureButtonCilick:(id)sender
{
    //确定按钮
    [self  canel];
    if ([self.delegate respondsToSelector:@selector(sureButtonCilickWithPrice:remark:)])
    {
        [self.delegate sureButtonCilickWithPrice:self.priceTF.text remark:self.remarkTF.text];
    }
    
}

@end
