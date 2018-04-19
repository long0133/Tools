//
//  UIImage+Blur.h
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/23.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
+ (UIImage *)getImageViewWithView:(UIView *)view withBlurNum:(CGFloat)blur;
@end
