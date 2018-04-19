//
//  CYLRefereshTool.m
//  CYLReferesh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLRefereshTool.h"

@implementation CYLRefereshTool
+(void)methodSwizzle:(Class)clazz origin:(SEL)originSel new:(SEL)newSel {
    Method originalMethod =
    class_getInstanceMethod(clazz, originSel);
    Method swizzledMethod =
    class_getInstanceMethod(clazz, newSel);
    
    BOOL isAddSuccess =
    class_addMethod(clazz, originSel,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (isAddSuccess) {
        class_replaceMethod(clazz, newSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
