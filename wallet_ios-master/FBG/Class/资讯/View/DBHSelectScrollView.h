//
//  DBHSelectScrollView.h
//  FBG
//
//  Created by yy on 2018/3/28.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLEVIEW_TAG_START 200

typedef void(^SelectedBlock)(int index);

@interface DBHSelectScrollView : UIView

@property (nonatomic, strong) SelectedBlock selectedBlock;

@property (nonatomic, strong) UIColor *backgroundViewColor;
@property (nonatomic, strong) UIColor *topLineColor;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger currentSelectedIndex;

- (DBHSelectScrollView *)initWithTitles:(NSArray *)titles currentSelectedIndex:(NSInteger)selectedIndex;
- (void)scrollToIndex:(NSInteger)index;

@end
