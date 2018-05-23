//
//  D5FlowButtonView.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

#define FLOW_BUTTON_START_TAG 100000

#define SELECTED_COLOR_HEX 0xFD842F
#define NORMAL_COLOR_HEX 0xB6B6B6

@protocol D5FlowButtonViewDelegate <NSObject>

- (void)flowButtonClicked:(NSInteger)index;

@end

@interface D5FlowButtonView : UIView

@property (nonatomic, weak) id<D5FlowButtonViewDelegate> delegate;

/**
 *  通过传入一组按钮填充D5FlowButtonView
 *
 *  @param buttonList 按钮数组
 */
- (void)setData:(NSMutableArray *)buttonList withDelegate:(id<D5FlowButtonViewDelegate>)delegate ;

@end
