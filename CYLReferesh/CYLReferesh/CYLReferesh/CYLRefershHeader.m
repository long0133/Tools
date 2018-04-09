//
//  CYLRefershHeader.m
//  CYLReferesh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLRefershHeader.h"
#import "UIView+MJExtension.h"
#import "Animator.h"
#import <Masonry.h>

@interface CYLRefershHeader()
@property (nonatomic, strong) UIView *canvas;
@end

@implementation CYLRefershHeader
@synthesize state = _state;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.canvas];
    [self.canvas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.height.mas_equalTo(self.mj_h*2.0/3);
        make.width.mas_equalTo(self.mj_h*2.0/3);
    }];
}

- (void)setState:(RefreshState)state{
    if (_state != state) {
        _state = state;
        
        if (state == RefreshStatePulling) {
            [Animator showArrowOnCanvas:self.canvas];
        }
    }
}

#pragma mark - getter
- (UIView *)canvas{
    if (!_canvas) {
        _canvas = [[UIView alloc] init];
        _canvas.backgroundColor = [UIColor whiteColor];
    }
    return _canvas;
}
@end
