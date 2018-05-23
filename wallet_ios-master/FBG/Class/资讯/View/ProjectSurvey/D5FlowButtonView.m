//
//  D5FlowButtonView.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5FlowButtonView.h"

@implementation D5FlowButtonView

#pragma mark - 将buttonlist中的button添加到self中
- (void)setData:(NSMutableArray *)buttonList withDelegate:(id<D5FlowButtonViewDelegate>)delegate {
    if (!buttonList || buttonList.count <= 0) {
        return;
    }
    
    _delegate = delegate;
    
    [self removeAllSubviews];
    for (UIButton *button in buttonList) {
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

#pragma mark - 按钮的点击事件
- (void)btnClicked:(UIButton *)btn {
    if (btn.isSelected) {
        return;
    }
    
    for (UIButton *subView in self.subviews) {
        if (![subView isEqual:btn]) {
            subView.selected = NO;
            [subView setBorderWidth:0.5 color:COLORFROM16(NORMAL_COLOR_HEX, 1)];
        }
    }
    
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        [btn setBorderWidth:0.5 color:COLORFROM16(SELECTED_COLOR_HEX, 1)];
    } else {
        [btn setBorderWidth:0.5 color:COLORFROM16(NORMAL_COLOR_HEX, 1)];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(flowButtonClicked:)]) {
        [_delegate flowButtonClicked:btn.tag - FLOW_BUTTON_START_TAG];
    }
}

@end
