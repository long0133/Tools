//
//  DBHBaseViewController.h
//  Trinity
//
//  Created by 邓毕华 on 2017/12/25.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHBaseViewController : UIViewController

/**
 返回到第几级
 */
@property (nonatomic, assign) NSInteger backIndex;

- (void)setNavigationBarTitleColor;
- (void)setNavigationTintColor;

- (void)redPacketNavigationBar;

@end
