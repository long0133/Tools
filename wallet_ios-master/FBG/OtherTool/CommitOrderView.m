//
//  CommitOrderView.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/16.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "CommitOrderView.h"

@implementation CommitOrderView

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
        self = [CommitOrderView loadViewFromXIB];
        self.frame = frame;
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewSingleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self.maskView addGestureRecognizer:singleRecognizer];
        self.alertContView.layer.cornerRadius = 5;
        self.alertContView.layer.masksToBounds = YES;
        
        self.priceSilder.minimumValue = 0.00002520;
        self.priceSilder.maximumValue = 0.00252012;
        self.priceSilder.continuous = YES;// 设置可连续变化
        
        self.priceSilder.minimumValue = 0;
        self.priceSilder.maximumValue = 1;
        self.priceSilder.continuous = YES;
    }
    return self;
}

- (IBAction)priceSilderChange:(id)sender
{
    //滑块  0.00002520   ~  0.00252012    * 21000 单位
    int minimumValue = 2520;
    int maximumValue = 252012;
    
    int value = ((maximumValue - minimumValue) * self.priceSilder.value) + 2520;
    
    if (value % 5 == 0)
    {
        double doubuValue = (double)value / 100000000 * 21000;
        self.changesPriceLB.text = [NSString stringWithFormat:@"%.8f",doubuValue];
//        self.gas = [NSString stringWithFormat:@"%.8f",doubuValue];
    }
}

- (void)maskViewSingleTap
{
    if ([self.delegate respondsToSelector:@selector(cancelView)])
    {
        [self.delegate cancelView];
    }
}


- (IBAction)SureButtonCilick:(id)sender
{
    //确定按钮
    if ([self.delegate respondsToSelector:@selector(comiitButtonCilickWithData:)])
    {
        [self.delegate comiitButtonCilickWithData:nil];
    }
    
}

@end
