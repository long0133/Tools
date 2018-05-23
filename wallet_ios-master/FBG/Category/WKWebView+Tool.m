//
//  WKWebView+Tool.m
//  FBG
//
//  Created by yy on 2018/3/14.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "WKWebView+Tool.h"

@implementation WKWebView (Tool)

- (void)ZFJContentCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler {
    CGPoint offset = self.scrollView.contentOffset;
    
    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
    [self.superview addSubview:snapShotView];
    
    if(self.frame.size.height < self.scrollView.contentSize.height){
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height - self.frame.size.height);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollView.contentOffset = CGPointZero;
        WEAKSELF
        [self ZFJContentCaptureWithoutOffsetCompletionHandler:^(UIImage *capturedImage) {
            weakSelf.scrollView.contentOffset = offset;
            
            [snapShotView removeFromSuperview];
            
            if (completionHandler) {
                completionHandler(capturedImage);
            }
        }];
    });
    
}

- (void)ZFJContentPageDrawTargetView:(UIView *)targetView index:(int)index maxIndex:(int)maxIndex drawCallback:(void(^)())drawCallback{
    CGRect splitFrame = CGRectMake(0, (float)index * targetView.frame.size.height, targetView.bounds.size.width, targetView.frame.size.height);
    
    CGRect myFrame = self.frame;
    myFrame.origin.y = - ((float)index * targetView.frame.size.height);
    self.frame = myFrame;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [targetView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        
        if (index<maxIndex) {
            [self ZFJContentPageDrawTargetView:targetView index:index + 1 maxIndex:maxIndex drawCallback:drawCallback];
        } else {
            if (drawCallback) {
                drawCallback();
            }
        }
    });
}
- (void)ZFJContentCaptureWithoutOffsetCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler{
    UIView *containerView = [[UIView alloc]initWithFrame:self.bounds];
    
    CGRect bakFrame = self.frame;
    UIView *bakSuperView = self.superview;
    NSInteger bakIndex = [self.superview.subviews indexOfObject:self];
    
    [self removeFromSuperview];
    [containerView addSubview:self];
    
    CGSize totalSize = self.scrollView.contentSize;
    
    float page = floorf (totalSize.height / containerView.bounds.size.height);
    
    self.frame = CGRectMake(0, 0, containerView.bounds.size.width, self.scrollView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(totalSize, false, [UIScreen mainScreen].scale);
    
    WEAKSELF
    [self ZFJContentPageDrawTargetView:containerView index:0 maxIndex:(int)page drawCallback:^{
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [weakSelf removeFromSuperview];
        [bakSuperView insertSubview:weakSelf atIndex:bakIndex];
        
        weakSelf.frame = bakFrame;
        
        [containerView removeFromSuperview];
        
        if (completionHandler) {
            completionHandler(capturedImage);
        }
    }];
    
}
@end
