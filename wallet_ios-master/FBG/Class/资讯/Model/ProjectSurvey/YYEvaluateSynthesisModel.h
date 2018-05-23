//
//  YYEvaluateSynthesisModel.h
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYEvaluateSynthesisModel : NSObject

@property (nonatomic, assign) NSInteger very_dissatisfied;
@property (nonatomic, assign) NSInteger dissatisfied;
@property (nonatomic, assign) NSInteger good;
@property (nonatomic, assign) NSInteger recommend;
@property (nonatomic, assign) NSInteger like;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) CGFloat score_avg;

@end
