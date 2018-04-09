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
}
@end
