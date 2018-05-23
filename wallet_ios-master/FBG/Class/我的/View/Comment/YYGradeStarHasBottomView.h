//
//  YYGradeStarHasBottomView.h
//  FBG
//
//  Created by yy on 2018/4/6.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYGradeStarView.h"

@interface YYGradeStarHasBottomView : UIView

@property (nonatomic, strong) NSArray *titlesArr;
/** 最高评分 */
@property (nonatomic, assign) CGFloat maxScore;
/** 当前评分 */
@property (nonatomic, assign, readonly) CGFloat currentScore;
/** 评分改变回调 */
@property (nonatomic, copy) void(^scoreChangedBlock)(CGFloat score);
/** 支持操作类型 */
@property (nonatomic, assign) YYGradeStarViewOperationType operationTypes;
/** 单元背景色 */
@property (nonatomic, strong) UIColor *itemBGColor;
/** 根据设置分数显示评分（纯显示控件） */
@property (nonatomic, assign) CGFloat showScore;


- (instancetype)initWithItemWidth:(CGFloat)width margin:(CGFloat)margin;

- (void)setBgImageName:(NSString *)bgImageName andTopImageName:(NSString *)topImageName;

- (void)setOrigin:(CGPoint)origin;



@end
