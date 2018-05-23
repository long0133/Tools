//
//  ScanVC.h
//  FBG
//
//  Created by mac on 2017/7/27.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanVCDelegate <NSObject>

- (void)scanSucessWithObject:(id)object;

@end

@interface ScanVC : UIViewController

@property (nonatomic, strong) id <ScanVCDelegate> delegate;

@end
