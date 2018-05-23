//
//  DBHUnLoginTableCell.m
//  FBG
//
//  Created by yy on 2018/3/20.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHUnLoginTableCell.h"
#import "DBHUnLoginView.h"

@interface DBHUnLoginTableCell()

@property (nonatomic, strong) DBHUnLoginView *unLoginView;

@end

@implementation DBHUnLoginTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self.contentView addSubview:self.unLoginView];
    
    WEAKSELF
    [self.unLoginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.contentView);
        make.center.equalTo(weakSelf.contentView);
    }];
}

- (DBHUnLoginView *)unLoginView {
    if (!_unLoginView) {
        _unLoginView = [[DBHUnLoginView alloc] init];
        
        WEAKSELF
        [_unLoginView setBtnBlock:^{
            [[AppDelegate delegate] goToLoginVC:[weakSelf parentController]];
        }];
    }
    
    return _unLoginView;
}
@end
