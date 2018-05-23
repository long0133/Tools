//
//  ChoseWalletView.h
//  FBG
//
//  Created by 贾仕海 on 2017/8/14.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseWalletViewDelegate <NSObject>

- (void)sureButtonCilickWithData:(id)data;

@end

@interface ChoseWalletView : UIView

@property (nonatomic, strong) id <ChoseWalletViewDelegate> delegate;

- (void)showWithView:(UIView *)view;
- (void)canel;

@end
