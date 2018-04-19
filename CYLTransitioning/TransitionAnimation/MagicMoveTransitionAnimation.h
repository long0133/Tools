//
//  MagicMoveTransitionAnimation.h
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/23.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "CYLBaseTransitionAnimation.h"

@interface MagicMoveTransitionAnimation : CYLBaseTransitionAnimation
@property (nonatomic, strong) UIImageView *fromImageV;
@property (nonatomic, assign) CGRect originalRect;
@property (nonatomic, strong) UIImageView *toImageV;
@property (nonatomic, assign) CYLTransitionStyle style;

- (instancetype)initWithFromImageV:(UIImageView*)fromImageV toImageView:(UIImageView*)toImageV;
@end
