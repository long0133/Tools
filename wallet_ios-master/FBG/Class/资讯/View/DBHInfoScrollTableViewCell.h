//
//  DBHInfoScrollTableViewCell.h
//  FBG
//
//  Created by yy on 2018/3/20.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
#define SCROLL_LOOP_HEIGHT 200

typedef void(^PullBlock)(void);

@interface DBHInfoScrollTableViewCell : DBHBaseTableViewCell

@property (nonatomic, copy) PullBlock block;

//@property (nonatomic, assign) BOOL isShowScroll;
- (void)titleLabelIsShow:(BOOL)isShow;

- (void)setTitles:(NSArray *)titles images:(NSArray *)images models:(NSMutableArray *)models;
- (void)invalidateTimers;
- (void)scrollToZero;
- (void)setInitLabelText;

@end
