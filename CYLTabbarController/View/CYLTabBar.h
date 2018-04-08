//
//  CYLTabBar.h
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLTabBarButton.h"

@class CYLTabBar;

@protocol CYLTabBarDelegate <NSObject>

- (void)tabBar:(CYLTabBar*)tabBar DidClickButton:(UIButton*)button;
@end

@interface CYLTabBar : UITabBar
@property (nonatomic , strong) NSArray *tabBarItemArray;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) id<CYLTabBarDelegate> tabBarDelegate;

- (void)selectBtnByIndex:(NSInteger)index;
- (void)setSpecialBtn:(NSInteger)index;
@end
