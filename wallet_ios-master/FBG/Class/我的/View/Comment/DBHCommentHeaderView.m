//
//  DBHCommentHeaderView.m
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHCommentHeaderView.h"
#define COMMENT_HEADER_VIEW @"CommentHeaderView"

@interface DBHCommentHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *allCommentBtn;

@end

@implementation DBHCommentHeaderView

- (id)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:COMMENT_HEADER_VIEW owner:nil options:nil] lastObject];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:COMMENT_HEADER_VIEW owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _allCommentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setTitltWithCount:0];
}

- (void)setTitltWithCount:(NSInteger)count {
    [self.allCommentBtn setTitle:[NSString stringWithFormat:@"%@ (%ld)", DBHGetStringWithKeyFromTable(@"All Comments", nil), count] forState:UIControlStateNormal];
}

- (void)setCount:(NSInteger)count {
    _count = count;
    
    [self setTitltWithCount:count];
}

@end
