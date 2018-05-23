//
//  YYGradeStarHasBottomView.m
//  FBG
//
//  Created by yy on 2018/4/6.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYGradeStarHasBottomView.h"

#define TITLE_HEIGHT 20
#define TITLE_WIDTH 60
#define TITLE_TOP_MARGIN 8
#define STAR_VIEW_HEIGHT(imgHeight, titleHeight) (titleHeight + imgHeight)

@interface YYGradeStarHasBottomView()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) YYBaseItemView *bgItemView;

@property (nonatomic, strong) YYBaseItemView *topItemView;

@property (nonatomic, assign) CGFloat currentScore;

@end

@implementation YYGradeStarHasBottomView

- (instancetype)initWithItemWidth:(CGFloat)width margin:(CGFloat)margin {
    self = [super init];
    
    if(self){
        //初始化视图
        __weak YYGradeStarHasBottomView *weakSelf = self;
        self.bgView = [[UIView alloc] init];
        
        self.bgItemView = [[YYBaseItemView alloc] initWithItemWidth:width margin:margin];
        self.topItemView = [[YYBaseItemView alloc] initWithItemWidth:width margin:margin];
        [self.bgView addSubview:self.bgItemView];
        [self.bgView insertSubview:self.topItemView aboveSubview:self.bgItemView];
        self.bgView.frame = self.bgItemView.frame;
        
        [self.topItemView setFrame:CGRectMake(0, 0, 0, width)];
        [self addSubview:self.bgView];
        
        self.height = STAR_VIEW_HEIGHT(CGRectGetHeight(self.bgItemView.frame), TITLE_HEIGHT);
        for (int i = 0; i < self.titlesArr.count; i ++) {
            UILabel *label = [[UILabel alloc] init];
            label.tag = 5000;
            
            NSString *titleStr = self.titlesArr[i];
            
            CGFloat width = AUTOLAYOUTSIZE(TITLE_WIDTH);
            label.frame = CGRectMake(i * width, CGRectGetHeight(self.bgItemView.frame) + TITLE_TOP_MARGIN, width, 20);
            label.text = titleStr;
            label.font = FONT(12);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = COLORFROM16(0x333333, 1);
            [self addSubview:label];
        }
        
        UILabel *lastSub = self.subviews.lastObject;
        self.width = CGRectGetMaxX(lastSub.frame);
        
        self.bgView.x = (self.width - self.bgView.width) / 2;
        
        //评分改变回调
        [self.topItemView setScoreChangedBlock:^(CGFloat score) {
            if (weakSelf.scoreChangedBlock) {
                weakSelf.scoreChangedBlock(score);
            }
        }];
        
        [self setBgImageName:@"smalljhuixing_icom" andTopImageName:@"smallxing_icon"];
        self.itemBGColor = [UIColor clearColor];
        //设置默认评分
        self.maxScore = 5;
        
        self.operationTypes = YYGradeStarViewOperationType_click | YYGradeStarViewOperationType_dragFloat;//设置操作类型
    }
    return self;
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

- (void)setBgImageName:(NSString *)bgImageName andTopImageName:(NSString *)topImageName;{
    [self.bgItemView setImageName:bgImageName];
    [self.topItemView setImageName:topImageName];
}

- (void)setOrigin:(CGPoint)origin{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (void)setMaxScore:(CGFloat)maxScore{
    _maxScore = maxScore;
    self.topItemView.maxScore = maxScore;
}

#pragma mark - Life Circle

#pragma mark - About UI

#pragma mark - Event response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.bgView];
    [self.topItemView changeFrameWithPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.bgView];
    [self.topItemView changeFrameWithPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.bgView];
    [self.topItemView changeFrameWithPoint:point];
}
#pragma mark - Pravite Method

#pragma mark - Public Method
- (void)setOperationTypes:(YYGradeStarViewOperationType)operationTypes{
    _operationTypes = operationTypes;
    self.topItemView.operationTypes = operationTypes;
}

- (void)setItemBGColor:(UIColor *)itemBGColor{
    _itemBGColor = itemBGColor;
    self.bgItemView.itemBGColor = itemBGColor;
    self.topItemView.itemBGColor = itemBGColor;
}
#pragma mark - Getters/Setters/Lazy
- (void)setShowScore:(CGFloat)showScore{
    
    if (showScore>=self.maxScore){
        showScore = _maxScore;
    }
    
    _showScore = showScore;
    
    self.userInteractionEnabled = NO;
    
    [self.topItemView changeFrameWithScore:_showScore];
    
}
#pragma mark - Delegate methods


@end
