//
//  TowButtonAlertView.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/8.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TowButtonAlertViewDelegate <NSObject>

- (void)sureButtonCilick;

@end

@interface TowButtonAlertView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *alertContView;
@property (weak, nonatomic) IBOutlet UILabel *alertContInfoLB;
@property (weak, nonatomic) IBOutlet UIButton *alertSureButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelSureButton;

@property (nonatomic, strong) id <TowButtonAlertViewDelegate> delegate;

- (void)show;
- (void)canel;


@end
