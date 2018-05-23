//
//  LookWalletCodeView.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/15.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "LookWalletCodeView.h"

@implementation LookWalletCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [LookWalletCodeView loadViewFromXIB];
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
        self.codeImageView.image = nil;
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
    if ([self.delegate respondsToSelector:@selector(LookWalletCodeViewsureButtonCilick)])
    {
        [self.delegate LookWalletCodeViewsureButtonCilick];
    }
    
}

@end
