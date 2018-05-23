//
//  YYRedPacketHomeHeaderView.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketHomeHeaderView.h"

@interface YYRedPacketHomeHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *sendRedPacketBtn;

@end
@implementation YYRedPacketHomeHeaderView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYRedPacketHomeHeaderView class]) owner:nil options:nil] lastObject];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYRedPacketHomeHeaderView class]) owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

- (IBAction)respondsSendRedPacketBtn:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
