//
//  ChoseNetView.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/23.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "ChoseNetView.h"

@implementation ChoseNetView

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
        self = [ChoseNetView loadViewFromXIB];
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
    if ([APP_APIEHEAD isEqualToString:TESTAPIEHEAD1])
    {
        //测试
        self.testImage.image = [UIImage imageNamed:@"list_btn_selected"];
        self.mainImage.image = [UIImage imageNamed:@"list_btn_default"];
    }
    else
    {
        //正式
        self.testImage.image = [UIImage imageNamed:@"list_btn_default"];
        self.mainImage.image = [UIImage imageNamed:@"list_btn_selected"];
    }
    self.isNotTest = [APP_APIEHEAD isEqualToString:APIEHEAD1];
    
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
    }];
}

- (void)maskViewSingleTap
{
    [self canel];
}
- (IBAction)testButtonCilick:(id)sender
{
    //选择测试
    self.isNotTest = NO;
    self.testImage.image = [UIImage imageNamed:@"list_btn_selected"];
    self.mainImage.image = [UIImage imageNamed:@"list_btn_default"];
}

- (IBAction)mainButtonCilick:(id)sender
{
    //选择正式
    self.isNotTest = YES;
    self.testImage.image = [UIImage imageNamed:@"list_btn_default"];
    self.mainImage.image = [UIImage imageNamed:@"list_btn_selected"];
}

- (IBAction)SureButtonCilick:(id)sender
{
    //确定按钮
    [self  canel];
    
    if ([APP_APIEHEAD isEqualToString:(self.isNotTest ? APIEHEAD1 : TESTAPIEHEAD1)]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(sureButtonCilickWithTest:)])
    {
        [self.delegate sureButtonCilickWithTest:self.isNotTest];
    }
    
}

@end
