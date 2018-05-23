//
//  DBHRankListHeaderView.h
//  FBG
//
//  Created by yy on 2018/3/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBHRankRowHeaderView.h"

#define LIST_MIN_WIDTH 160

@interface DBHRankListHeaderView : UIView

@property (nonatomic, copy) ClickBlock clickBlock;

- (instancetype)initWithRank:(NSString *)rank icon:(NSString *)icon first:(NSString *)first second:(NSString *)second third:(NSString *)third;

@end
