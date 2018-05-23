//
//  YYStarView.m
//  FBG
//
//  Created by yy on 2018/4/6.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYStarView.h"
#define DEFALUT_STAR_NUMBER 5

@interface YYStarView()

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;
@property (nonatomic, assign) NSInteger numberOfStars;

@end

@implementation YYStarView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStars:DEFALUT_STAR_NUMBER];
}

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStar {
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStar;
        [self buildDataAndUI];
    }
    return self;
}

- (void)buildDataAndUI {
    _scorePercent = 1;
    self.foregroundStarView = [self createStarViewWithImage:@"smallxing_icon"];
    self.backgroundStarView = [self createStarViewWithImage:@"smalljhuixing_icom"];
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < self.numberOfStars; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imgView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height );
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imgView];
    }
    return view;
}

- (void)setScorePercent:(CGFloat)scorePercent {
    if (_scorePercent == scorePercent) {
        return;
    }
    if (scorePercent < 0) {
        _scorePercent = 0;
        
    } else if (scorePercent > 1) {
        _scorePercent = 1;
    } else {
        _scorePercent = scorePercent;
    }
    self.foregroundStarView.frame = CGRectMake(0,0,self.bounds.size.width * self.scorePercent , self.bounds.size.height);
}


@end
