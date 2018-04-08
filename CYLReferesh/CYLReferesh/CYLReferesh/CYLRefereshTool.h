//
//  CYLRefereshTool.h
//  CYLReferesh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface CYLRefereshTool : NSObject
+ (void)methodSwizzle:(Class)clazz origin:(SEL)originSel new:(SEL)newSel;
@end
