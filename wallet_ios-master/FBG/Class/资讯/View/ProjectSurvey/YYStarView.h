//
//  YYStarView.h
//  FBG
//
//  Created by yy on 2018/4/6.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYStarView : UIView

@property (nonatomic, assign) CGFloat scorePercent; // 0到1,评分

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStar;

@end
