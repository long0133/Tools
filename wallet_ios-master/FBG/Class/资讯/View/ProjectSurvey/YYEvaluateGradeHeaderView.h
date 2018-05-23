//
//  YYEvaluateGradeHeaderView.h
//  FBG
//
//  Created by yy on 2018/4/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5FlowButtonView.h"
@class YYEvaluateSynthesisModel;
@class YYEvaluateTagsData;

#define TOP_DEFAULT_MARGIN 18

@interface YYEvaluateGradeHeaderView : UIView

@property (nonatomic, strong) YYEvaluateSynthesisModel *synthModel;

/**
 *  设置cell中的控件的值
 *
 *  @param tagsData 数据
 *  @param delegate 控件中按钮的点击事件的响应者
 */
- (void)setTagsData:(YYEvaluateTagsData *)tagsData withDelegate:(id<D5FlowButtonViewDelegate>)delegate;

@end
