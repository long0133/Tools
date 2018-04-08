//
//  UIScrollView+Referesh.h
//  CYLReferesh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Referesh)
- (void)addHeaderRefereshAction:(void (^)(void))Action;
- (void)endReferesh;
@end
