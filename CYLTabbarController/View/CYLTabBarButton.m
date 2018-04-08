//
//  CYLTabBarButton.m
//  LoveFreshBeen山寨
//
//  Created by GARY on 16/4/27.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTabBarButton.h"

@interface CYLTabBarButton ()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation CYLTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.redDot = [[UIView alloc] init];
        self.redDot.backgroundColor = [UIColor redColor];
        self.redDot.hidden = YES;
        [self addSubview:self.redDot];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

//- (void)layoutSubviews
//{
//    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//        if (_isOnlyPic) {
//            make.edges.equalTo(self);
//        }
//        else
//        {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self).offset(2);
//            make.width.mas_equalTo(21);
//            make.height.mas_equalTo(27);
//        }
//    }];
//    
//    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//       
//        if (_isOnlyPic) {
//            make.height.width.mas_equalTo(0);
//        }
//        else
//        {
//            make.bottom.left.right.equalTo(self);
//            make.height.mas_equalTo(15);
//        }
//        
//    }];
//}
//
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect imageViewFrame = self.imageView.frame;
    
    if (_isOnlyPic) {
        self.lineView.hidden = YES;
        return CGRectZero;
    }
    else
    {
        //设置title位置
        [self addSubview:self.lineView];
        CGRect frame = CGRectMake(0, CGRectGetMaxY(imageViewFrame), self.bounds.size.width, self.frame.size.height - imageViewFrame.size.height);
        return frame;
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (_isOnlyPic) {
        CGFloat imageW = MIN(self.bounds.size.width, self.bounds.size.height);
        CGFloat x = (self.bounds.size.width - imageW) / 2.0 ;
        CGRect frame = CGRectMake(x, 0, imageW ,imageW);
        return frame;
    }
    else
    {
        //设置图片位置
//        CGFloat imageW = self.bounds.size.width / 3;
        CGFloat imageW = 25;
        CGRect frame = CGRectMake((self.bounds.size.width - imageW)/2, 10, imageW ,23);
        
        self.redDot.frame = CGRectMake(CGRectGetMaxX(frame)-3, frame.origin.y, 8, 8);
        self.redDot.layer.cornerRadius = 4;
        
        return frame;
    }
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _lineView.backgroundColor = mainGray;
    }
    return _lineView;
}

@end
