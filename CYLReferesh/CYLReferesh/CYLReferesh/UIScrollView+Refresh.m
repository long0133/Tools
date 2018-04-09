//
//  UIScrollView+Refresh.m
//  CYLRefresh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "CYLRefershHeader.h"
#import "CYLRefreshFooter.h"
#import "CYLRefereshTool.h"
#import "UIView+MJExtension.h"
#import "CYLRefereshConstant.h"

const char *kHeaderView = "kHeaderView";
const char *kFooterView = "kFooterView";
const char *kOriginInset = "kOriginInset";
const char *kScrollContentStateDict = "kScrollContentStateDict";
static BOOL isObserving = false; /**< 是否观察中 */

@interface UIScrollView()
@property (nonatomic, strong) CYLRefershHeader *headerView;
@property (nonatomic, strong) CYLRefreshFooter *footerView;
@property (nonatomic, strong) NSValue *originInset;
@property (nonatomic, strong) NSMutableDictionary *scrollContentStateDict;
@end

@implementation UIScrollView (Refresh)
#pragma mark - private
//header
- (void)addHeaderRefreshAction:(void (^)(void))Action{
    self.headerView = [[CYLRefershHeader alloc] initWithFrame:CGRectMake(0, -CYLRefreshHeaderViewHeight, self.mj_size.width, CYLRefreshHeaderViewHeight)];
    self.headerView.state = RefreshStateIdle;
    self.headerView.headerAction = Action;
    
    [self refreshPrepare];
    [self addSubview:self.headerView];
}

//footer
- (void)addFooterRfreshAction:(void(^)(void))Action{
    self.footerView = [[CYLRefreshFooter alloc] initWithFrame:CGRectMake(0, self.mj_size.height, self.mj_size.width, CYLRefreshFooterViewHeight)];
    self.footerView.state = RefreshStateIdle;
    self.footerView.footerAction = Action;
    self.contentInset = [self edgeInsets:self.contentInset addBottom:CYLRefreshFooterViewHeight];
    [self refreshPrepare];
    [self insertSubview:self.footerView atIndex:0];
}

- (void)endHeaderRefresh{
    self.headerView.state = RefreshStateIdle;
    [self setScrollViewContentInset:self.originInset.UIEdgeInsetsValue];
}

- (void)endFooterRefresh{
    self.footerView.state = RefreshStateIdle;
    [self setScrollViewContentInset:self.originInset.UIEdgeInsetsValue];
}

- (void)refreshPrepare{
    [self addObserver];
    
    self.originInset = [NSValue valueWithUIEdgeInsets:self.contentInset];
    
    self.scrollContentStateDict = [NSMutableDictionary dictionary];
    [self.scrollContentStateDict setValue:[NSValue valueWithCGPoint:CGPointZero] forKey:CYLRefreshKeyPathContentOffset];
    [self.scrollContentStateDict setValue:[NSValue valueWithCGSize:CGSizeZero] forKey:CYLRefreshKeyPathContentSize];
    [self.scrollContentStateDict setValue:@0 forKey:CYLRefreshKeyPathPanState];
    [self.scrollContentStateDict setValue:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero] forKey:CYLRefreshKeyPathContentInset];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:CYLRefreshKeyPathContentOffset]) {
        NSValue *value = (NSValue*)change[NSKeyValueChangeNewKey];
        [self.scrollContentStateDict setValue:value forKey:CYLRefreshKeyPathContentOffset];
    }
    
    if ([keyPath isEqualToString:CYLRefreshKeyPathContentSize]) {
        NSValue *value = (NSValue*)change[NSKeyValueChangeNewKey];
        CGSize contentSize = value.CGSizeValue;
        self.footerView.frame = CGRectMake(0, contentSize.height, contentSize.width, CYLRefreshFooterViewHeight);
        [self.scrollContentStateDict setValue:value forKey:CYLRefreshKeyPathContentSize];
    }
    
    if ([keyPath isEqualToString:CYLRefreshKeyPathPanState]) {
        NSNumber *state = (NSNumber*)change[NSKeyValueChangeNewKey];
        [self.scrollContentStateDict setValue:state forKey:CYLRefreshKeyPathPanState];
    }
    
    [self scrollViewContentSizeDidChange:self.scrollContentStateDict];
}


- (void)scrollViewContentSizeDidChange:(NSDictionary*)contentDict{
    
    CGPoint contentOffSet = ((NSValue*)contentDict[CYLRefreshKeyPathContentOffset]).CGPointValue;
    UIGestureRecognizerState state = ((NSNumber*)contentDict[CYLRefreshKeyPathPanState]).integerValue;
    CGFloat offSet_Y = contentOffSet.y;
    
    if (offSet_Y > -CYLRefreshHeaderViewHeight && state == UIGestureRecognizerStateChanged) {
        //开始拖拽但是还未拉倒触发区
        self.headerView.state = RefreshStatePulling;
    }
    
    if (offSet_Y <= -CYLRefreshHeaderViewHeight && state == UIGestureRecognizerStateChanged) {
        //拖拽到触发区 但是还未松手
        self.headerView.state = RefreshStatePulling;
    }
    
    //下拉刷新
    //松手后再进行contentInset的更改 手势拖拽中进行更改会出抖动bug
    if (offSet_Y <= -CYLRefreshHeaderViewHeight && state == UIGestureRecognizerStateEnded) {
        [self setScrollViewContentInset:UIEdgeInsetsMake(CYLRefreshHeaderViewHeight, 0, 0, 0)];
        self.headerView.state = RefreshStateRefreshing;
        if (self.headerView.headerAction) {
            self.headerView.headerAction();
        }
    }
    
    //上拉加载
    if (offSet_Y >= fmaxf(.0f, self.contentSize.height - self.frame.size.height) + CYLRefreshFooterViewHeight) //x是触发操作的阀值
    {
        //触发上拉刷新
        if (self.footerView.state == RefreshStateIdle) {
            NSLog(@"触发上拉刷新");
            self.footerView.state = RefreshStateRefreshing;
            if (self.footerView.footerAction) {
                self.footerView.footerAction();
            }
        }
    }
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.contentInset = contentInset;
                     }
                     completion:NULL];
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:CYLRefreshKeyPathContentOffset];
    [self removeObserver:self forKeyPath:CYLRefreshKeyPathContentSize];
    [self removeObserver:self forKeyPath:CYLRefreshKeyPathPanState];
    isObserving = false;
}

- (void)addObserver{
    if (!isObserving) {
        [self addObserver:self forKeyPath:CYLRefreshKeyPathContentOffset options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:CYLRefreshKeyPathContentSize options:NSKeyValueObservingOptionNew context:nil];
        [self.panGestureRecognizer addObserver:self forKeyPath:CYLRefreshKeyPathPanState options:NSKeyValueObservingOptionNew context:nil];
        isObserving = YES;
    }
}

#pragma mark - getter setter
- (void)setHeaderView:(CYLRefershHeader *)headerView{
    objc_setAssociatedObject(self, kHeaderView, headerView, OBJC_ASSOCIATION_RETAIN);
}

- (CYLRefershHeader *)headerView{
    return objc_getAssociatedObject(self, kHeaderView);
}

- (void)setFooterView:(CYLRefreshFooter *)footerView{
    objc_setAssociatedObject(self, kFooterView, footerView, OBJC_ASSOCIATION_RETAIN);
}

- (CYLRefreshFooter *)footerView{
    return objc_getAssociatedObject(self, kFooterView);
}

- (void)setOriginInset:(NSValue*)originInset{
    objc_setAssociatedObject(self, kOriginInset, originInset, OBJC_ASSOCIATION_RETAIN);
}

- (NSValue*)originInset{
    NSValue *v = objc_getAssociatedObject(self, kOriginInset);
    return v;
}

- (void)setScrollContentStateDict:(NSMutableDictionary *)scrollContentStateDict{
    objc_setAssociatedObject(self, kScrollContentStateDict, scrollContentStateDict, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)scrollContentStateDict{
    return objc_getAssociatedObject(self, kScrollContentStateDict);
}
@end
