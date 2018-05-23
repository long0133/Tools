//
//  DBHRankView.h
//  FBG
//
//  Created by yy on 2018/3/29.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DBHRankTitleAndDataModel;

#define RANKVIEW_TAG_START 9000

typedef void (^RowHeaderClickBlock)(UIButton *btn, NSInteger index);

@interface DBHRankView : UIView

@property (nonatomic, copy) RowHeaderClickBlock block;

/**
 除第一行外的行数据数组
 */
@property (nonatomic, strong) NSArray *rowDatasArray;

- (instancetype)initWithFrame:(CGRect)frame withModel:(DBHRankTitleAndDataModel *)model;

@end
