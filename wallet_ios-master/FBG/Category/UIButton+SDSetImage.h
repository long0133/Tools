//
//  UIButton+SDSetImage.h
//  PandaTravel
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SDSetImage)

//设置头像
- (void)sdsetImageWithHeadimg:(NSString *)img;

//设置图片
- (void)sdsetImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

//设置背景图片
- (void)sdsetBackgroundImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

/**
 *  扩大 UIButton 的點擊範圍
 *  控制上下左右的延長範圍
 *
 *  @param top    <#top description#>
 *  @param right  <#right description#>
 *  @param bottom <#bottom description#>
 *  @param left   <#left description#>
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
