//
//  DBHSearchTitleView.h
//  FBG
//
//  Created by 邓毕华 on 2018/2/11.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBlock)(NSInteger type, NSString *searchString);

@interface DBHSearchTitleView : UIView

/**
 搜索类型
 */
@property (nonatomic, assign) NSInteger searchType;

@property (nonatomic, strong) UITextField *searchTextField;
- (instancetype)initWithFrame:(CGRect)frame isShowBtn:(BOOL)isShowCancelBtn;
- (void)searchBlock:(SearchBlock)searchBlock;

@end
