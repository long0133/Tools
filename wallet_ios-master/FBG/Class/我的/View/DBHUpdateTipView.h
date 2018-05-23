//
//  DBHUpdateTipView.h
//  FBG
//
//  Created by yy on 2018/3/21.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHUpdateTipView : UIView

- (void)setTipString:(NSString *)tipStr isForce:(BOOL)isForceUpdate downloadUrl:(NSString *)downloadUrl;
- (void)animationShow;

@end
