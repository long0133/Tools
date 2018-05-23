//
//  DBHChangePasswordTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

typedef void(^GetVerificationCodeBlock)(BOOL isShow);

@interface DBHChangePasswordTableViewCell : DBHBaseTableViewCell

/**
 输入框
 */
@property (nonatomic, strong) UITextField *valueTextField;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 显示密码回调
 */
- (void)getVerificationCodeBlock:(GetVerificationCodeBlock)getVerificationCodeBlock;

@end
