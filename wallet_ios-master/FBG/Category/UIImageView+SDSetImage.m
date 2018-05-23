//
//  UIImageView+SDSetImage.m
//  PandaTravel
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "UIImageView+SDSetImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SDSetImage)

- (void)sdsetImageWithHeaderimg:(NSString *)img
{
    if ([img containsString:@"http"])
    {
        [self sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:Default_Person_Image];
    }
    else
    {
        [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,img]] placeholderImage:Default_Person_Image];
    }
}

- (void)sdsetImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    if (url != nil && ![url isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSString *tempUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if ([tempUrl containsString:@"http"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:tempUrl] placeholderImage:placeholder];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,tempUrl]] placeholderImage:placeholder];
    }
}


- (void)sdsetImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder completed:(EMSDWebImageCompletionBlock)completedBlock {
    if (url != nil && ![url isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSString *tempUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if ([tempUrl containsString:@"http"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:tempUrl] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,tempUrl]] placeholderImage:placeholder];
    }
}
@end
