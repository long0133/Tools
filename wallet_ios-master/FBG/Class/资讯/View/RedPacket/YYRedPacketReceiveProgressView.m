//
//  YYRedPacketReceiveProgressView.m
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketReceiveProgressView.h"

@interface YYRedPacketReceiveProgressView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidthConstaint;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation YYRedPacketReceiveProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _progressWidthConstaint.constant = 0;
        _progressLabel.text = @"";
    }
    return self;
}

- (void)setProgress:(NSInteger)progress total:(NSInteger)total {
    _progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", progress, total];
    CGFloat width = self.bgView.width;
    
    CGFloat value = (CGFloat)progress / (CGFloat)total;
    _progressWidthConstaint.constant = width * value;
}

@end
