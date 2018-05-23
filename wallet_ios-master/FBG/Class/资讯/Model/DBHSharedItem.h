//
//  DBHSharedItem.h
//  FBG
//
//  Created by yy on 2018/3/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DBHSharedItem : NSObject<UIActivityItemSource>

- (instancetype)initWithData:(UIImage *)img andFile:(NSURL *)file;

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSURL *path;

@end
