//
//  DBHPlaceHolderTextView.h
//  FBG
//
//  Created by yy on 2018/3/21.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ObserveHasTextBlock)(BOOL hasText);

@interface DBHPlaceHolderTextView : UITextView

@property (nonatomic, copy) ObserveHasTextBlock hasTextBlock;

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;

/** 文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
