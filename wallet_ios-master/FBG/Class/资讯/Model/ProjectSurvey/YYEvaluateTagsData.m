//
//  YYEvaluateTagsData.m
//  FBG
//
//  Created by yy on 2018/4/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYEvaluateTagsData.h"
#import "YYEvaluateTagModel.h"
#import "D5FlowButtonView.h"

#define BTN_ROUND_RADIUS 6
#define BTN_HEIGHT 24

@interface YYEvaluateTagsData()

@property (nonatomic, assign) int currentRow;
@property (nonatomic, assign) CGFloat currentRowWidth, btnHeight, viewWidth;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *localTitlesArr;

@end

@implementation YYEvaluateTagsData

- (void)setData:(YYEvaluateTagsData *)data viewWidth:(CGFloat)width {
    self.contentArr = data.contentArr;
    
    _viewWidth = width;
    
    _btnHeight = BTN_HEIGHT;
    
    _currentRow = 0;
    _currentRowWidth = 0;
    
    
    NSMutableArray *tempTitleArr = [NSMutableArray arrayWithArray:self.localTitlesArr];
    for (int i = 0; i < self.contentArr.count; i ++) {
        @autoreleasepool {
            YYEvaluateTagModel *model = self.contentArr[i];
            NSString *title = [NSString stringWithFormat:@"%@ (%@)", model.name, @(model.number)];
            [tempTitleArr addObject:title];
        }
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < tempTitleArr.count; i ++) {
        @autoreleasepool {
            UIButton *btn = [self addBtnWithTitle:tempTitleArr[i] atIndex:i];
            if (i == tempTitleArr.count - 1) {
                self.height = CGRectGetMaxY(btn.frame) + 8;
            }
            
            [tempArr addObject:btn];
        }
    }
    self.buttonList = tempArr;
}

/**
 *  根据text的字数得到button的宽度
 *
 *  @param text 参数
 *
 *  @return 适应text字数的宽度
 */
- (CGFloat)buttonWidthWithText:(NSString *)text {
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(_viewWidth, _btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FLOW_BUTTON_FONT} context:nil].size;
    return textSize.width + 20;
}


/**
 *  添加button, 在dataList里面索引为index
 *
 *  @param title button的标题
 *  @param index datalist中所在的索引
 */
- (UIButton *)addBtnWithTitle:(NSString *)title atIndex:(int)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = FLOW_BUTTON_FONT;
    
    button.tag = FLOW_BUTTON_START_TAG + index;
    
    CGFloat width = [self buttonWidthWithText:title];
    
    CGFloat margin = 8;
    CGFloat x = 0;
    CGFloat y = 0;
    
    // 对第一个Button进行设置
    CGFloat newAddWidth = width + margin;
    if (index == 0) {
        _currentRowWidth += newAddWidth;
    } else {
        if (((_currentRowWidth + newAddWidth) >= _viewWidth) && ((_currentRowWidth + newAddWidth - margin) >= _viewWidth)) {
            _currentRow ++;
            _currentRowWidth = newAddWidth;
        } else {
            x = _currentRowWidth;
            _currentRowWidth += newAddWidth;
        }
    }
    
    
    y = (_currentRow + 1) * margin + _currentRow * _btnHeight;
    button.frame = CGRectMake(x, y, width, _btnHeight);
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:COLORFROM16(NORMAL_COLOR_HEX, 1) forState:UIControlStateNormal];
    [button setTitleColor:COLORFROM16(SELECTED_COLOR_HEX, 1) forState:UIControlStateSelected];
    
    if (index == self.currentSelectedTagIndex) {
        button.selected = YES;
        [button setBorderWidth:0.5 color:COLORFROM16(SELECTED_COLOR_HEX, 1)];
    } else {
        [button setBorderWidth:0.5 color:COLORFROM16(NORMAL_COLOR_HEX, 1)];
    }
    
    return button;
}

- (NSArray *)localTitlesArr {
    if (!_localTitlesArr) {
        _localTitlesArr = @[DBHGetStringWithKeyFromTable(@"All", nil),
                            DBHGetStringWithKeyFromTable(@" Hot ", nil),
                            DBHGetStringWithKeyFromTable(@"Newest", nil),
                            DBHGetStringWithKeyFromTable(@" Evaluation ", nil)];
    }
    return _localTitlesArr;
}

@end
