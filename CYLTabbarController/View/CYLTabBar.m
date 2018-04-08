//
//  CYLTabBar.m
//  ChemMaster
//
//  Created by GARY on 16/6/12.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTabBar.h"

@interface CYLTabBar ()
@property (nonatomic ,strong) UIButton *lastSelectedBtn;
@property (nonatomic, assign) NSInteger specialBtnIdx;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation CYLTabBar
#pragma mark - method
- (void)setTabBarItemArray:(NSArray *)tabBarItemArray
{
    _tabBarItemArray = tabBarItemArray;
    
    [self addSubview:self.lineView];
    
    for (NSInteger i = 0; i < tabBarItemArray.count; i ++) {
        
        UITabBarItem *item = tabBarItemArray[i];
        
        CYLTabBarButton  *btn = [CYLTabBarButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setTitle:item.title forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"fd9500"] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        
        btn.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        [btn addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnArr addObject:btn];
        [self addSubview:btn];
        
        if (i == 0) {
            
            btn.selected = YES;
            _lastSelectedBtn = btn;
        }
    }
}

- (void)layoutSubviews
{
    
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width / _tabBarItemArray.count;
    CGFloat btnH = self.frame.size.height;
    //    CGFloat btnW = btnH;
    
    NSInteger count = self.btnArr.count;
    
    for (NSInteger i = 0; i < count; i ++) {
        CYLTabBarButton *btn = [CYLTabBarButton buttonWithType:UIButtonTypeCustom];
        if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_9_x_Max) {
            btn = self.btnArr[i];
        }
        else
        {
            btn = self.subviews[i];
        }
        
        btn.tag = i;
        
        if (i == _specialBtnIdx) {
            btn.frame = CGRectMake(i * btnW, -15, btnW, btnH+15);
            btn.isOnlyPic = YES;
        }
        else
        {
            btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
        }
    }
    
    for (UIView *view in self.subviews) {
        
        if (![view isKindOfClass:[CYLTabBarButton class]]) {
            [view removeFromSuperview];
        }
        
        if ([view isKindOfClass:NSClassFromString(@"_UIBackdropEffectView")]) {
            view.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    
    for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
        CGPoint convertedPoint = [subview convertPoint:point fromView:self];
        UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
        if (hitTestView) {
            return hitTestView;
        }
    }

        if (![self pointInside:point withEvent:event]) {
            return nil;
        }
    
    return  self;
}

- (void)setSpecialBtn:(NSInteger)index
{
    if (self.btnArr.count == 0 || self.btnArr.count <= index) {
        return;
    }
    
    _specialBtnIdx = index;
    
    [self setNeedsLayout];
}


- (void)ButtonClicked:(UIButton *)btn
{
    _lastSelectedBtn.selected = NO;
    
    [self AnimationWithBtn:btn];
    
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBar:DidClickButton:)]) {
        [self.tabBarDelegate tabBar:self DidClickButton:btn];
    }
    
    btn.selected =YES;
    _lastSelectedBtn = btn;
    
}

- (void)selectBtnByIndex:(NSInteger)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    for (UIButton *button in self.btnArr) {
        
        if (button.tag == index) {
            btn = button;
        }
    }
    
    _lastSelectedBtn.selected = NO;
    
    [self AnimationWithBtn:btn];
    btn.selected =YES;
    _lastSelectedBtn = btn;
}

#pragma mark -  animation
- (void)AnimationWithBtn:(UIButton*)btn
{
//    //button动画效果
//    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animation];
//
//    keyAnim.keyPath = @"transform.scale";
//
//    keyAnim.values = @[@1.2, @0.8, @1.1, @0.9, @1.0];
//
//    keyAnim.repeatCount = 1;
//
//    keyAnim.repeatDuration = 2.0;
//
//    keyAnim.removedOnCompletion = YES;
//
//    keyAnim.fillMode = kCAFillModeBackwards;
//
//    keyAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//
//    [btn.imageView.layer addAnimation:keyAnim forKey:nil];
}

#pragma mark -  setter getter
- (NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.width, 1)];
        _lineView.backgroundColor = HexColor(@"ececec");
    }
    return _lineView;
}
@end
