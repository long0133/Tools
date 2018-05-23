//
//  UIImage+ImageForColor.m
//  RenRenDai
//
//  Created by DBH on 16/10/31.
//  Copyright © 2016年 邓毕华. All rights reserved.
//

#import "UIImage+ImageForColor.h"

@implementation UIImage (ImageForColor)

+ (UIImage *)getImageFromColor:(UIColor *)color Rect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

/**
 *  压缩图片为原尺寸的4分之1
 *
 *  @param image 原始图片
 *
 *  @return 生成图片
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image {
    NSInteger second = image.size.width / 1000;
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width / second, image.size.height / second));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect: CGRectMake(0, 0, image.size.width / second, image.size.height / second)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return smallImage;
}

@end
