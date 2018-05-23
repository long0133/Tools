//
//  CommitOrderView.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/16.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommitOrderViewDelegate <NSObject>

- (void)cancelView;
- (void)comiitButtonCilickWithData:(id)data;

@end

@interface CommitOrderView : UIView

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *alertContView;
@property (weak, nonatomic) IBOutlet UILabel *orderLB;
@property (weak, nonatomic) IBOutlet UILabel *transferAddressLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *changesPriceLB;
@property (weak, nonatomic) IBOutlet UISlider *priceSilder;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UILabel *banalceLB;

@property (nonatomic, strong) id <CommitOrderViewDelegate> delegate;



@end
