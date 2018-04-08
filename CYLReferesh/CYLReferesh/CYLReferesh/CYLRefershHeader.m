//
//  CYLRefershHeader.m
//  CYLReferesh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLRefershHeader.h"

@implementation CYLRefershHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor redColor];
}
@end
