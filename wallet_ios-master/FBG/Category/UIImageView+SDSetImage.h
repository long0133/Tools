//
//  UIImageView+SDSetImage.h
//  PandaTravel
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SDSetImage)

//设置头像
- (void)sdsetImageWithHeaderimg:(NSString *)img;

//设置图片
- (void)sdsetImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

@end
