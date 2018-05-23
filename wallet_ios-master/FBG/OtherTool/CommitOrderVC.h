//
//  CommitOrderVC.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/31.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommitOrderVCDelegate <NSObject>

- (void)comiitButtonCilickWithchangesPrice:(NSString *)changesPrice gasprice:(NSString *)gasprice;

@end

@interface CommitOrderVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *alertContView;
@property (weak, nonatomic) IBOutlet UILabel *orderLB;
@property (weak, nonatomic) IBOutlet UILabel *transferAddressLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *changesPriceLB;
@property (weak, nonatomic) IBOutlet UISlider *priceSilder;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UILabel *banalceLB;

@property (nonatomic, copy) NSString * banalce;
@property (nonatomic, copy) NSString * changesPrice; //总共手续费
@property (nonatomic, copy) NSString * orderTitle;
@property (nonatomic, copy) NSString * transferAddress;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * gas; //手续费单价
@property (nonatomic, assign) int defaultGasNum;  //手续费数量

@property (nonatomic, strong) id <CommitOrderVCDelegate> delegate;

@end
