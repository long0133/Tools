//
//  DBHGradePromptView.h
//  FBG
//
//  Created by 邓毕华 on 2018/2/10.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GradeBlock)(NSInteger grade);

@interface DBHGradePromptView : UIView

@property (nonatomic, assign) NSInteger grade;

@property (nonatomic, assign) BOOL canGrade;

/**
 动画显示
 */
- (void)animationShow;

- (void)gradeBlock:(GradeBlock)gradeBlock;

@end
