//
//  CYLCardPopUpController.m
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/26.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "CYLCardPopUpController.h"
#import "CYLTansitionManager.h"
#import "CardPopUpTransitionAnimation.h"

@interface CYLCardPopUpController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) CardPopUpTransitionAnimation *animator;
@end

@implementation CYLCardPopUpController

- (instancetype)initWithDisplayLayer:(UIView*)displayLayer
{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.animator = [[CardPopUpTransitionAnimation alloc] initWithHeight:displayLayer.bounds.size.height SpringAnim:YES andRoundCornor:YES];
        self.displayView = displayLayer;
        self.displayView.frame = CGRectMake(0, 0, displayLayer.bounds.size.width, displayLayer.bounds.size.height);
        [self.view addSubview:self.displayView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [CYLTansitionManager transitionObjectwithTransitionStyle:CYLTransitionStyle_Present animateDuration:0.5 andTransitionAnimation:self.animator];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [CYLTansitionManager transitionObjectwithTransitionStyle:CYLTransitionStyle_Dismiss animateDuration:0.5 andTransitionAnimation:self.animator];
}

@end
