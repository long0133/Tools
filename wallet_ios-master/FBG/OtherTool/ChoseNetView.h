//
//  ChoseNetView.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/23.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseNetViewDelegate <NSObject>

- (void)sureButtonCilickWithTest:(BOOL)isNotTset;

@end

@interface ChoseNetView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *alertContView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *mainBUtton;
@property (weak, nonatomic) IBOutlet UIButton *alertSureButton;
@property (weak, nonatomic) IBOutlet UIImageView *testImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (nonatomic, assign) BOOL isNotTest;

@property (nonatomic, strong) id <ChoseNetViewDelegate> delegate;

- (void)showWithView:(UIView *)view;
- (void)canel;

@end
