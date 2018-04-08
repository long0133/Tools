//
//  UIScrollView+Referesh.m
//  CYLReferesh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "UIScrollView+Referesh.h"
#import "CYLRefershHeader.h"
#import "CYLRefereshTool.h"
#import "UIView+MJExtension.h"

const char *kHeaderView = "kHeaderView";
const char *kHeaderAction = "kHeaderAction";
const char *kOriginInset = "kOriginInset";

@interface UIScrollView()
@property (nonatomic, copy) dispatch_block_t headerAction;
@property (nonatomic, strong) CYLRefershHeader *headerView;
@property (nonatomic, strong) NSValue *originInset;;
@end

@implementation UIScrollView (Referesh)
+ (void)load{
    
}

#pragma mark - hook action

#pragma mark - private
- (void)addHeaderRefereshAction:(void (^)(void))Action{
    
    self.headerView = [[CYLRefershHeader alloc] initWithFrame:CGRectMake(0, -CYLRefereshHeaderViewHeight, self.mj_size.width, CYLRefereshHeaderViewHeight)];
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    self.headerAction = Action;
    
    self.originInset = [NSValue valueWithUIEdgeInsets:self.contentInset];
    
    [self addSubview:self.headerView];
}

- (void)endReferesh{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = self.originInset.UIEdgeInsetsValue;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *value = (NSValue*)change[NSKeyValueChangeNewKey];
        [self scrollViewContentSizeDidChange:value.CGPointValue];
    }
}

- (void)scrollViewContentSizeDidChange:(CGPoint)contentOffset{
    CGFloat offSet_Y = contentOffset.y;
    NSLog(@"%f",contentOffset.y);
    if (offSet_Y <= -CYLRefereshHeaderViewHeight) {
        self.contentInset = UIEdgeInsetsMake(CYLRefereshHeaderViewHeight, 0, 0, 0);
        if (self.headerAction) {
            self.headerAction();
        }
    }
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - getter setter
- (void)setHeaderView:(CYLRefershHeader *)headerView{
    objc_setAssociatedObject(self, kHeaderView, headerView, OBJC_ASSOCIATION_RETAIN);
}

- (CYLRefershHeader *)headerView{
    return objc_getAssociatedObject(self, kHeaderView);
}

- (void)setHeaderAction:(dispatch_block_t)headerAction{
    objc_setAssociatedObject(self, kHeaderAction, headerAction, OBJC_ASSOCIATION_COPY);
}

- (dispatch_block_t)headerAction{
    return objc_getAssociatedObject(self, kHeaderAction);
}

- (void)setOriginInset:(NSValue*)originInset{
    objc_setAssociatedObject(self, kOriginInset, originInset, OBJC_ASSOCIATION_RETAIN);
}

- (NSValue*)originInset{
    NSValue *v = objc_getAssociatedObject(self, kOriginInset);
    return v;
}
@end
