//
//  UIImage+Tool.h
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

//网址转图片
+ (UIImage *)imageFromURLString:(NSString *)urlstring;

//由颜色生成图片
+ (UIImage *) imageWithColor:(UIColor*)color;

//将图片剪裁至目标尺寸
+ (UIImage *) imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;
+ (UIImage *)imageWithGradients:(NSArray *)colours;


/**
 将图片压缩至指定大小

 @param image image
 @param newSize newSize
 @return 图片
 */
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (void)setRoundForView:(UIView *)view borderColor:(UIColor *)color;
@end
