//
//  UIImage+Blur.h
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/23.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Tools.h"

@interface UIImage (Blur)
+(UIImage *)blurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
+ (UIImage *)getImageWithView:(UIView *)view withBlurNum:(CGFloat)blur;
- (UIImage*)getImageCompressWithSize:(CGSize)size;
+ (UIImage *)createImageWithColor:(UIColor *)color;
@end
