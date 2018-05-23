//
//  YYGradeStarView.m
//  YYGradeStarViewDemo
//
//  Created by WHJ on 2017/11/10.
//  Copyright © 2017年 WHJ. All rights reserved.
//

#import "YYGradeStarView.h"
@class YYBaseItemView;

@interface YYGradeStarView()

@property (nonatomic, strong) YYBaseItemView *bgItemView;

@property (nonatomic, strong) YYBaseItemView *topItemView;

@property (nonatomic, assign) CGFloat currentScore;

@end

@implementation YYGradeStarView

- (instancetype)initWithItemWidth:(CGFloat)width margin:(CGFloat)margin {
    self = [super init];
    
    if(self){
        //设置默认评分
        self.maxScore = 5;
        //初始化视图
        __weak YYGradeStarView *weakSelf = self;
        self.bgItemView = [[YYBaseItemView alloc] initWithItemWidth:width margin:margin];
        [self addSubview:self.bgItemView];
        [self setFrame:self.bgItemView.frame];
        
        self.topItemView = [[YYBaseItemView alloc] initWithItemWidth:width margin:margin];
        [self addSubview:self.topItemView];
        [self.topItemView setFrame:CGRectMake(0, 0, 0, width)];
        //评分改变回调
        [self.topItemView setScoreChangedBlock:^(CGFloat score) {
            if (weakSelf.scoreChangedBlock) {
                weakSelf.scoreChangedBlock(score);
            }
        }];
        
        [self setBgImageName:@"smalljhuixing_icom" andTopImageName:@"smallxing_icon"];
        self.itemBGColor = [UIColor clearColor];
        //默认支持点击和拖拽整数
        [self setOperationTypes:(YYGradeStarViewOperationType_click | YYGradeStarViewOperationType_dragFloat)];
    }
    return self;
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
    CGPoint point = [touch locationInView:self];
    [self.topItemView changeFrameWithPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.topItemView changeFrameWithPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
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
    if (showScore >= self.maxScore){
        showScore = _maxScore;
    }
    
    _showScore = showScore;
    self.userInteractionEnabled = NO;
    [self.topItemView changeFrameWithScore:_showScore];
    
}
#pragma mark - Delegate methods

@end

@implementation YYBaseItemView

#pragma mark - Life Circle
- (instancetype)initWithItemWidth:(CGFloat)width margin:(CGFloat)margin {
    _itemW = width;
    _margin = margin;
    
    self = [super init];
    
    if(self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - About UI
- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    //创建按钮并布局
    for (int i = 0; i < 5; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        [self addSubview:imgV];
        [self.imgVs addObject:imgV];
        
        imgV.frame = CGRectMake(i * (_itemW + _margin), 0, _itemW, _itemW);
        imgV.userInteractionEnabled = YES;
    }
    
    //设置自己的frame
    UIImageView *lastImgV = [self.imgVs lastObject];
    self.frame = CGRectMake(0, 0, CGRectGetMaxX(lastImgV.frame), _itemW);
}
#pragma mark - Event response

#pragma mark - Pravite Method

#pragma mark - Public Method
- (void)setImageName:(NSString *)imageName{
    
    [self.imgVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgV = obj;
        imgV.image = [UIImage imageNamed:imageName];
    }];
}
//根据点击的点 进行frame调整
- (void)changeFrameWithPoint:(CGPoint)point{
    __block NSInteger selectIndex = 0;
    
    __weak YYBaseItemView *weakSelf = self;
    
    __block NSInteger count = self.imgVs.count;
    [self.imgVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgV = obj;
        if(CGRectContainsPoint(imgV.frame, point)){
            CGFloat score = 0;
            selectIndex = idx;
//            if (weakSelf.operationTypes & YYGradeStarViewOperationType_dragFloat) {//如果支持小数
//                if (weakSelf.scoreChangedBlock) {
//                    CGFloat value = point.x - idx * (weakSelf.margin + weakSelf.itemW);
//
//                    CGFloat first = value / weakSelf.itemW;
//                    CGFloat second = weakSelf.maxScore / (CGFloat)count;
//                    score = first * second + selectIndex;
//
//                    weakSelf.scoreChangedBlock(score);
//                    NSLog(@"%.2f",score);
//                }
//                weakSelf.frame = CGRectMake(0, 0, point.x,_itemW);
//            } else {
//                CGFloat offsetX = CGRectGetMaxX(imgV.frame);
//                if(idx == 0 && point.x < (offsetX*2/5)){
//                    offsetX = 0;
//                    score = 0;
//                } else {
//                    score = (idx + 1) / 5.f;
//                }
//
//                if(weakSelf.scoreChangedBlock){
//                    weakSelf.scoreChangedBlock(score);
//                }
//                weakSelf.frame = CGRectMake(0, 0, offsetX, _itemW);
//            }
            CGFloat offsetX = CGRectGetMaxX(imgV.frame);
            
            if (weakSelf.operationTypes & YYGradeStarViewOperationType_dragFloat) {//如果支持小数
                CGFloat width = point.x;
                if(weakSelf.scoreChangedBlock){
                    CGFloat value = point.x - idx * (weakSelf.margin + weakSelf.itemW);
                    if (value <= weakSelf.itemW / 2) { //0.5
                        score = idx + 0.5;
                        width = offsetX - weakSelf.itemW / 2;
                    } else {
                        score = idx + 1;
                        width = offsetX;
                    }

                    weakSelf.scoreChangedBlock(score);
                    NSLog(@"after ==%.1f",score);
                }
                weakSelf.frame = CGRectMake(0, 0, width, weakSelf.itemW);
            } else {
                if (idx == 0 && point.x < (offsetX * 2 / 5)) {
                    offsetX = 0;
                    score = 0;
                } else {
                    score = (idx + 1) / 5.f;
                }

                score = score * weakSelf.maxScore;
                if(weakSelf.scoreChangedBlock){
                    weakSelf.scoreChangedBlock(score);
                }
                NSLog(@"%.1f",score);
                weakSelf.frame = CGRectMake(0, 0, offsetX, weakSelf.itemW);
            }
        }
    }];
}

- (void)changeFrameWithScore:(CGFloat)score{
    CGFloat length = self.imgVs.count * _itemW;
    CGFloat scale = score / self.maxScore;
    CGFloat itemLength = scale * length;
    CGFloat topItemCount = itemLength / _itemW;
    BOOL isInteger = (topItemCount - floor(topItemCount)) == 0;
    CGFloat marginLength = isInteger ? (topItemCount - 1) * _margin : topItemCount * _margin - 0.5 * _margin;
    CGFloat topW = itemLength+marginLength;
    self.frame = CGRectMake(0, 0, topW, _itemW);
}

#pragma mark - Getters/Setters/Lazy
- (NSMutableArray *)imgVs{
    if (!_imgVs) {
        _imgVs = [NSMutableArray arrayWithCapacity:5];
    }
    return _imgVs;
}

- (void)setItemBGColor:(UIColor *)itemBGColor{
    _itemBGColor = itemBGColor;
    [self.imgVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageV = obj;
        imageV.backgroundColor = itemBGColor;
    }];
}

@end



