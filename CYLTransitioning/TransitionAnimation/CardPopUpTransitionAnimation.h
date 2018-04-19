//
//  CardPopUpTransitionAnimation.h
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/26.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "CYLBaseTransitionAnimation.h"

typedef void(^clickOutside)();

@interface CardPopUpTransitionAnimation : CYLBaseTransitionAnimation
//@property (nonatomic, copy) clickOutside didClickOutside;

- (instancetype)initWithHeight:(CGFloat)height SpringAnim:(BOOL)isSpring andRoundCornor:(BOOL)isRound;

@end
