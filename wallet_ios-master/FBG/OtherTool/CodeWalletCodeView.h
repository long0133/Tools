//
//  CodeWalletCodeView.h
//  FBG
//
//  Created by 贾仕海 on 2017/9/1.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CodeWalletCodeViewDelegate <NSObject>

- (void)CodeWalletCodeViewsureButtonCilick;

@end

@interface CodeWalletCodeView : UIView

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIView *alertContView;
@property (weak, nonatomic) IBOutlet UIButton *alertSureButton;

@property (nonatomic, strong) id <CodeWalletCodeViewDelegate> delegate;

- (void)showWithView:(UIView *)view;
- (void)canel;

@end
