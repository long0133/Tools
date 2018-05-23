//
//  DBHRankRowHeaderView.h
//  FBG
//
//  Created by yy on 2018/3/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kHeaderViewWidth 130
#define BUTTON_FONT_SIZE 14

typedef void(^ClickBlock)(UIButton *btn);

@interface DBHRankRowHeaderView : UIView

@property (nonatomic, assign) BOOL isSelected; // 是否被选中
@property (nonatomic, copy) ClickBlock clickBlock;

- (void)setSelected:(BOOL)selected ordered:(NSInteger)ordered;

/**
 根据参数创建view
 
 @param titleStr    显示的标题
 @param isCanClick  是否可以点击
 @param isShowLine  是否显示右侧的竖线
 @param index       当前显示的rank index
 @return view
 */
- (DBHRankRowHeaderView *)initWithFrame:(CGRect)frame title:(NSString *)titleStr isCanClick:(BOOL)isCanClick isShowLine:(BOOL)isShowLine index:(NSInteger)index isFirst:(BOOL)isFirst;

@end
