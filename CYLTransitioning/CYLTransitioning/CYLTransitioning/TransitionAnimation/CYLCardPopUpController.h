//
//  CYLCardPopUpController.h
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/26.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLCardPopUpController : UIViewController
@property (nonatomic, strong) UIView *displayView;
- (instancetype)initWithDisplayLayer:(UIView*)displayLayer;
@end
