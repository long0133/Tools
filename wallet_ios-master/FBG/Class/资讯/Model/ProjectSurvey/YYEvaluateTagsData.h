//
//  YYEvaluateTagsData.h
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLOW_BUTTON_FONT [UIFont systemFontOfSize:12]

@interface YYEvaluateTagsData : NSObject

@property (nonatomic, strong) NSMutableArray *buttonList;
@property (nonatomic, strong) NSMutableArray *contentArr; // titles
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign) NSInteger currentSelectedTagIndex;

- (void)setData:(YYEvaluateTagsData *)data viewWidth:(CGFloat)width;

@end
