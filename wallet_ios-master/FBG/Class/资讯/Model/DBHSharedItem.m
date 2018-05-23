//
//  DBHSharedItem.m
//  FBG
//
//  Created by yy on 2018/3/19.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHSharedItem.h"

@implementation DBHSharedItem

- (instancetype)initWithData:(UIImage *)img andFile:(NSURL *)file {
    self = [super init];
    if (self) {
        _img = img;
        _path = file;
    }
    return self;
}

#pragma mark - UIActivityItemSource
- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return _img;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
//    if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]) {
//        return nil;
//    }
    return _path;
}

- (NSString*)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    // 这里对我这分享图好像没啥用....
    return @"";
}

@end
