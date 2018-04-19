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

@interface CYLRefershHeader()
@property (nonatomic, strong) UIView *canvas;
@property (nonatomic, strong) Animator *arrowAnimator;
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
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.height.mas_equalTo(self.mj_h*2.0/3);
        make.width.mas_equalTo(self.mj_h*2.0/3);
    }];
}

#pragma mark - 动画入口
- (void)setState:(RefreshState)state{
    if (_state != state) {
        _state = state;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHeaderStatusDidChanged object:@(state)];
        
        if (state == RefreshStatePulling) {
            [self.arrowAnimator showArrowOnCanvas:self.canvas];
        }else if (state == RefreshStateRefreshing){
            [self.arrowAnimator showRefreshAnimationCanTriggerActionBlock:^{
                if (self.headerAction) {
                    self.headerAction();
                }
            }];
        }else if (state == RefreshStateIdle){
            [self.arrowAnimator clear];
            self.arrowAnimator = nil;
        }
    }
}

#pragma mark - getter setter
- (UIView *)canvas{
    if (!_canvas) {
        _canvas = [[UIView alloc] init];
        _canvas.backgroundColor = self.backgroundColor;
    }
    return _canvas;
}

- (Animator *)arrowAnimator{
    if (!_arrowAnimator) {
        _arrowAnimator = [[Animator alloc] init];
    }
    return _arrowAnimator;
}
@end
