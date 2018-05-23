//
//  UIImage+ImageForColor.h
//  RenRenDai
//
//  Created by DBH on 16/10/31.
//  Copyright © 2016年 邓毕华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageForColor)


/**
 根据颜色生成一张图片

 @param color 颜色
 @param rect 大小
 @return 图片
 */
+ (UIImage *)getImageFromColor:(UIColor *)color Rect:(CGRect)rect;

/**
 *  压缩图片为原尺寸的4分之1
 *
 *  @param image 原始图片
 *
 *  @return 生成图片
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image;

@end
