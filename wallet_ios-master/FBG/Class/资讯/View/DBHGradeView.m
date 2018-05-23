//
//  DBHGradeView.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHGradeView.h"

@implementation DBHGradeView

#pragma mark ------ Lifecycle ------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangmugaikuang_xing"]];
        starImageView.tag = 200 + i;
        
        starImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:starImageView];
        
        WEAKSELF
        [starImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            CGFloat value = CGRectGetHeight(weakSelf.frame);
            if (value == 0) {
                make.width.height.offset(AUTOLAYOUTSIZE(8.5));
            } else {
                make.width.height.offset(value);
            }
            if (!i) {
                make.left.equalTo(weakSelf);
            } else {
                make.left.equalTo([weakSelf viewWithTag:199 + i].mas_right).offset(AUTOLAYOUTSIZE(3.5));
            }
            make.centerY.equalTo(weakSelf);
        }];
    }
}

#pragma mark ------ Getters And Setters ------
- (void)setGrade:(CGFloat)grade {
    _grade = grade;
    
    int index = floor(grade); // 整数部分
    CGFloat value = grade - index; // 小数部分
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *starImageView = [self viewWithTag:200 + i];
        UIImage *image = [UIImage imageNamed:@"smalljhuixing_icom"]; // 灰色
        if (i <= index - 1) {
            image = [UIImage imageNamed:@"smallxing_icon"];
        } else if (i == index) {
            if (value >= 0.5) {
                image = [UIImage imageNamed:@"smallbanxing_icon"];
            }
        }
        
        starImageView.image = image;
    }
}

- (NSArray *)titlesArr {
    if (!_titlesArr) {
        _titlesArr = @[DBHGetStringWithKeyFromTable(@"Very Bad", nil),
                       DBHGetStringWithKeyFromTable(@"Bad", nil),
                       DBHGetStringWithKeyFromTable(@"Fair", nil),
                       DBHGetStringWithKeyFromTable(@"Recommend", nil),
                       DBHGetStringWithKeyFromTable(@"Highly Recommend", nil)
                       ];
    }
    return _titlesArr;
}
@end
