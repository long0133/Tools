//
//  DBHPlaceHolderTextView.m
//  FBG
//
//  Created by yy on 2018/3/21.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHPlaceHolderTextView.h"

@interface DBHPlaceHolderTextView()

/** 占位label */
@property (nonatomic, weak) UILabel *textViewLabel;

@end

@implementation DBHPlaceHolderTextView


- (UILabel *)textViewLabel {
    if (!_textViewLabel) {
        UILabel *textViewLabel = [[UILabel alloc] init];
        textViewLabel.numberOfLines = 0;
        CGRect frame = textViewLabel.frame;
        frame.origin.x = 6;
        frame.origin.y = 8;
        textViewLabel.frame = frame;
       
        [self addSubview:textViewLabel];
        _textViewLabel = textViewLabel;
    }
    return _textViewLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeTextView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeTextView];
}

- (void)initializeTextView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    // 设置始终可以拖拽
    self.alwaysBounceVertical = YES;
    self.placeholderColor = COLORFROM10(220, 220, 220, 1);
    self.font = FONT(13);
}

- (void)textDidChange {
    self.textViewLabel.hidden = self.hasText;
    if (self.hasTextBlock) {
        self.hasTextBlock(self.hasText);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 重写各种setter方法

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.textViewLabel.text = self.placeholder;
    [self textDidChange];
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.textViewLabel.textColor = self.placeholderColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.textViewLabel.font = font;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textDidChange];
    [self setNeedsLayout];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChange];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.textViewLabel.frame;
    frame.size.width = self.frame.size.width - 2 * self.textViewLabel.frame.origin.x;
    self.textViewLabel.frame = frame;
    [self.textViewLabel sizeToFit];
}


@end
