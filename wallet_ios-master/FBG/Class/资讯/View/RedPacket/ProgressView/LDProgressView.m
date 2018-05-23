//
//  LDProgressView.m
//  LDProgressView
//
//  Created by Christian Di Lorenzo on 9/27/13.
//  Copyright (c) 2013 Light Design. All rights reserved.
//

#import "LDProgressView.h"
#import "UIColor+RGBValues.h"

@interface LDProgressView ()
@property (nonatomic) CGFloat offset;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CGFloat stripeWidth;
@property (nonatomic, strong) UIImage *gradientProgress;
@property (nonatomic) CGSize stripeSize;

// Animation of progress
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic) CGFloat progressToAnimateTo;
@end

@implementation LDProgressView
@synthesize animate=_animate, color=_color;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setAnimate:(NSNumber *)animate {
    _animate = animate;
    if ([animate boolValue]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(incrementOffset) userInfo:nil repeats:YES];
    } else if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)setProgress:(CGFloat)progress {
    self.progressToAnimateTo = progress;
    if (self.animationTimer) {
        [self.animationTimer invalidate];
    }
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.008 target:self selector:@selector(incrementAnimatingProgress) userInfo:nil repeats:YES];
}

- (void)incrementAnimatingProgress {
    if (_progress >= self.progressToAnimateTo-0.01 && _progress <= self.progressToAnimateTo+0.01) {
        _progress = self.progressToAnimateTo;
        [self.animationTimer invalidate];
        [self setNeedsDisplay];
    } else {
        _progress = (_progress < self.progressToAnimateTo) ? _progress + 0.01 : _progress - 0.01;
        [self setNeedsDisplay];
    }
}

- (void)incrementOffset {
    if (self.offset >= 0) {
        self.offset = -self.stripeWidth;
    } else {
        self.offset += 1;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawProgressBackground:context inRect:rect];
    if (self.progress > 0) {
        [self drawProgress:context withFrame:rect];
    }
}

- (void)drawProgressBackground:(CGContextRef)context inRect:(CGRect)rect {
    CGContextSaveGState(context);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.borderRadius.floatValue];
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:221.0f/255.0f green:106.0f/255.0f blue:86.0f/255.0f alpha:1].CGColor);
    
//    [roundedRect fill];
    
    UIBezierPath *roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect:CGRectMake(-10, -10, rect.size.width+10, rect.size.height + 10)];
    
//    CGContextSetRGBStrokeColor(context, 221.0f/255.0f, 106.0f/255.0f, 86.0f/255.0f, 1);
//    [roundedRectangleNegativePath stroke];
    
    [roundedRectangleNegativePath appendPath:roundedRect];
    roundedRectangleNegativePath.usesEvenOddFillRule = YES;

    CGSize shadowOffset = CGSizeMake(0.5, 1);
    CGContextSaveGState(context);
    CGFloat xOffset = shadowOffset.width + round(rect.size.width);
    CGFloat yOffset = shadowOffset.height;
    CGContextSetShadowWithColor(context,
            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)), 5, [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor);

    [roundedRect addClip];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rect.size.width), 0);
    [roundedRectangleNegativePath applyTransform:transform];
//    [[UIColor grayColor] setFill];
//    [roundedRectangleNegativePath fill];
    CGContextRestoreGState(context);

    // Add clip for drawing progress
    [roundedRect addClip];
}

- (void)drawProgress:(CGContextRef)context withFrame:(CGRect)frame {
    CGRect rectToDrawIn = CGRectMake(0, 0, frame.size.width * self.progress, frame.size.height);
    CGRect insetRect = CGRectInset(rectToDrawIn, self.progress > 0.03 ? 0.5 : -0.5, 0.5);
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:self.borderRadius.floatValue];
    if ([self.flat boolValue]) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        [roundedRect fill];
    } else {
        CGContextSaveGState(context);
        [roundedRect addClip];
        [self colorGradualChangeStart: CGPointMake(insetRect.size.width / 2, 0) end:CGPointMake(insetRect.size.width / 2, insetRect.size.height)];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = {0.0, 1.0};
        NSArray *colors = @[(__bridge id)[self.color lighterColor].CGColor, (__bridge id)[self.color darkerColor].CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
        
        CGContextDrawLinearGradient(context, gradient, CGPointMake(insetRect.size.width / 2, 0), CGPointMake(insetRect.size.width / 2, insetRect.size.height), 0);
        CGContextRestoreGState(context);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }

    
    switch (self.type) {
        case LDProgressGradient:
            [self drawGradients:context inRect:insetRect];
            break;
        case LDProgressStripes:
            [self drawStripes:context inRect:insetRect];
            break;
        default:
            break;
    }
    
//    CGContextSetStrokeColorWithColor(context, [[self.color darkerColor] darkerColor].CGColor);
//    [roundedRect stroke];

    if ([self.showText boolValue]) {
        [self drawRightAlignedLabelInRect:insetRect];
    }
}

/*创建一个线性渐变 会调用一个CGGradientCreateWithColorComponents函数 这个函数的返回类型的CGGradientRef的渐变 这是一个句柄 一旦不再使用 要调用CGGradientRelease来释放资源 需要四个参数*/
- (void)colorGradualChangeStart:(CGPoint)startPoint end:(CGPoint)endPoint  {
    
    //步骤1 为渐变选择起点和终点 渐变的颜色将会沿着这条坐标轴过度
    
    //步骤2 创建一个色彩空间 用于传递给CGGradientCreateWithColorComponent函数的第一个参数  当我们不再用的时候 要记得释放*/
    
    /*参数1（color space） 色彩空间 是一个色彩范围的容器 类型必须是 CGColorSpaceRef 闯入CGColorSpaceCreateDeviceRGB的返回值 将会给我们一个RGB的色彩空间*/
    
    CGColorSpaceRef spaceColor = CGColorSpaceCreateDeviceRGB();
    
    
    
    //步骤 3 选择起始点和终止点的颜色 实际上 我们将在数组中的位置决定哪个是起始点的颜色哪个是终止点的颜色
    
    UIColor *startColor = [UIColor colorWithRed:217.0f/255.0f green:114.0f/255.0f blue:91.0f/255.0f alpha:1];
    
    CGFloat *startColorComponents = (CGFloat *)CGColorGetComponents([startColor CGColor]);
    
    UIColor *endColor = [UIColor colorWithRed:178.0f/255.0f green:62.0f/255.0f blue:46.0f/255.0f alpha:1];
    
    CGFloat *endColorComponents = (CGFloat *)CGColorGetComponents([endColor CGColor]);
    
    //步骤 4 获取每种颜色的分量 并保存在一个数组中 传递给CGGradientCreateWithColorComponents函数
    
    /*参数2 颜色分量的数组 这个数组必须包含红 绿 蓝和透明度 如果需要两个点（起点和终点）必须要为这个数组提供两种颜色*/
    
    CGFloat colorComponents[8] = {
        
        startColorComponents[0],
        
        startColorComponents[1],
        
        startColorComponents[2],
        
        startColorComponents[3],
        
        /*起始点的颜色是蓝色*/
        
        endColorComponents[0],
        
        endColorComponents[1],
        
        endColorComponents[2],
        
        endColorComponents[3]
        
        /*终止点的颜色是绿色*/
        
    };
    
    
    
    //步骤 5 因为我们在数组中只有两个颜色 指出渐变最开始的位置 接着指定结束的位置 并把这些指针放在数组中 传递给CGGradientCreateWithColorComponents函数
    
    /*参数3 位置数组 颜色数组中各个颜色的位置 此参数控制渐变从一种颜色到另一种颜色的速度 第一种颜色是渐变的起始颜色 第二种颜色是渐变的终止颜色*/
    
    CGFloat colorIndices[2]={0.0f,1.0f};
    
    
    
    //步骤6  用我们已经准备好的参数调用CGGradientCreateWithColorComponents函数
    
    /*参数4 位置数量（位置数组的颜色数量）这个参数告诉我们需要多少个颜色和位置 即下列方法的最后一个参数*/
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(spaceColor, (const CGFloat*)&colorComponents, (const CGFloat*)&colorIndices, 2);
    
    
    
    //步骤 7 释放色彩空间
    
    CGColorSpaceRelease(spaceColor);
    
    //用CGContextDrawLinearGradient过程 在图形上下文 绘制该线性渐变 需要5个参数
    
    /*参数 1 指定用于绘制线性渐变的图形上下文*/
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(currentContext);
    
    /*参数 2 我们使用CGGradientCreateWithColorComponents方法创建线性渐变的对象的句柄*/
    
    /*参数 3 渐变的起点*/
    
    /*参数 4 渐变的终点*/
    
    /*参数 5 当起点和终点不在上下文边缘内指定如何处理*/
    
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    
    //释放句柄
    
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(currentContext);
    
}



- (void)drawGradients:(CGContextRef)context inRect:(CGRect)rect {
    self.stripeSize = CGSizeMake(self.stripeWidth, rect.size.height);
    CGContextSaveGState(context);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.borderRadius.floatValue] addClip];
    CGFloat xStart = self.offset;
    while (xStart < rect.size.width) {
        [self.gradientProgress drawAtPoint:CGPointMake(xStart, 0)];
        xStart += self.stripeWidth;
    }
    CGContextRestoreGState(context);
}

- (void)drawStripes:(CGContextRef)context inRect:(CGRect)rect {
    CGContextSaveGState(context);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.borderRadius.floatValue] addClip];
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGFloat xStart = self.offset, height = rect.size.height, width = self.stripeWidth;
    while (xStart < rect.size.width) {
        CGContextSaveGState(context);
        CGContextMoveToPoint(context, xStart, height);
        CGContextAddLineToPoint(context, xStart + width * 1.0, 0);
        CGContextAddLineToPoint(context, xStart + width * 1.5, 0);
        CGContextAddLineToPoint(context, xStart + width * 0.5, height);
        CGContextClosePath(context);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
        xStart += width;
    }
    CGContextRestoreGState(context);
}

- (void)drawRightAlignedLabelInRect:(CGRect)rect {
    if (rect.size.width > 40) {
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%.0f%%", self.progress*100];
        label.font = [UIFont boldSystemFontOfSize:17];
        UIColor *baseLabelColor = [self.color isLighterColor] ? [UIColor blackColor] : [UIColor whiteColor];
        label.textColor = [baseLabelColor colorWithAlphaComponent:0.6];
        [label drawTextInRect:CGRectMake(6, 0, rect.size.width-12, rect.size.height)];
    }
}

#pragma mark - Accessors

- (UIImage *)gradientProgress {
    if (!_gradientProgress) {
        UIGraphicsBeginImageContext(self.stripeSize);
        CGContextRef imageCxt = UIGraphicsGetCurrentContext();

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = {0.0, 0.5, 1.0};
        NSArray *colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[[[self.color darkerColor] darkerColor] colorWithAlphaComponent:0.3].CGColor, (__bridge id)[UIColor clearColor].CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

        CGContextDrawLinearGradient(imageCxt, gradient, CGPointMake(0, self.stripeSize.height / 2), CGPointMake(self.stripeSize.width, self.stripeSize.height / 2), 0);

        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);

        _gradientProgress = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _gradientProgress;
}

- (NSNumber *)animate {
    if (_animate == nil) {
        return @YES;
    }
    return _animate;
}

- (NSNumber *)showText {
    if (_showText == nil) {
        return @YES;
    }
    return _showText;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.gradientProgress = nil;
}

- (UIColor *)color {
    if (!_color) {
        return [UIColor colorWithRed:221.0f/255.0f green:106.0f/255.0f blue:86.0f/255.0f alpha:1];
    }
    return _color;
}

- (CGFloat)stripeWidth {
    switch (self.type) {
        case LDProgressGradient:
            _stripeWidth = 15;
            break;
        default:
            _stripeWidth = 15;
            break;
    }
    return _stripeWidth;
}

- (NSNumber *)borderRadius {
    if (!_borderRadius) {
        return @(self.frame.size.height / 2.0);
    }
    return _borderRadius;
}

@end
