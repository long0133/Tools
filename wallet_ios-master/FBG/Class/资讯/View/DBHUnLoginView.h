//
//  DBHUnLoginView.h
//  FBG
//
//  Created by yy on 2018/3/20.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBtnBlock)(void);

@interface DBHUnLoginView : UIView

@property (nonatomic, copy) ClickBtnBlock btnBlock;

@property (nonatomic, strong) NSString *tipTitle;
@property (nonatomic, strong) NSString *btnTitle;

@end
