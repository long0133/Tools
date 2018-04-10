//
//  CYLRefereshBaseView.m
//  CYLReferesh
//
//  Created by chinapex on 2018/4/9.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLRefereshBaseView.h"
@implementation CYLRefereshBaseView

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (![newSuperview isKindOfClass:[UIScrollView class]]) return;
    self.scrollView = (UIScrollView*)newSuperview;
    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}
@end
