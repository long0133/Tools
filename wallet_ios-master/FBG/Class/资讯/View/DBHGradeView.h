//
//  DBHGradeView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHGradeView : UIView

@property (nonatomic, strong) NSArray *titlesArr;
/**
 评分
 */
@property (nonatomic, assign) CGFloat grade;
@property (nonatomic, assign) CGFloat width;

@end
