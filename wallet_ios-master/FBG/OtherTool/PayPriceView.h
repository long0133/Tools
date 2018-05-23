//
//  PayPriceView.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/12.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PayPriceViewDelegate <NSObject>

- (void)sureButtonCilickWithPrice:(NSString *)price remark:(NSString *)remark;

@end

@interface PayPriceView : UIView

@property (weak, nonatomic) IBOutlet PayPriceView *alertContView;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UILabel *rmbPriceLB;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@property (nonatomic, strong) id <PayPriceViewDelegate> delegate;

- (void)showWithView:(UIView *)view;
- (void)canel;

@end
