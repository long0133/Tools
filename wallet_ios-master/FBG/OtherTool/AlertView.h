//
//  AlertView.h
//  FBG
//
//  Created by mac on 2017/7/30.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewDelegate <NSObject>

- (void)sureButtonCilick;

@end

@interface AlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *alertContView;
@property (weak, nonatomic) IBOutlet UILabel *alertContInfoLB;
@property (weak, nonatomic) IBOutlet UIButton *alertSureButton;
@property (weak, nonatomic) IBOutlet UITextView *alertTextView;

@property (nonatomic, strong) id <AlertViewDelegate> delegate;

- (void)showWithView:(UIView *)view;
- (void)canel;

@end
