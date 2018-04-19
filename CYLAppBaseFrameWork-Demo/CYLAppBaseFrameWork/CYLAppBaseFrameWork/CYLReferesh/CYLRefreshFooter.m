//
//  CYLRefreshFooter.m
//  CYLReferesh
//
//  Created by chinapex on 2018/4/9.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLRefreshFooter.h"
@interface CYLRefreshFooter()
@property (nonatomic, strong) UIImageView *footerImageV;
@property (nonatomic, strong) UILabel *footerTipLable;
@end

@implementation CYLRefreshFooter
@synthesize state = _state;

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.footerTipLable];
    [self.footerTipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(CGRectGetWidth(self.frame)/2.0);
        make.height.mas_equalTo(CGRectGetHeight(self.frame)/2.0);
    }];
}

#pragma mark - getter setter
- (void)setState:(RefreshState)state{
    if (_state != state) {
        _state = state;
        if (state == RefreshStatePulling) {
            
        }else if (state == RefreshStateRefreshing){
            self.footerTipLable.text = @"正在加载更多...";
                if (self.footerAction) {
                    self.footerAction();
                }
            
        }else if (state == RefreshStateIdle){
            _footerTipLable.text = @"上拉加载更多...";
        }else if (state == RefreshStateNoMoreData){
            self.footerTipLable.text = @"暂无更多数据...";
        }
    }
}

- (UILabel *)footerTipLable{
    if (!_footerTipLable) {
        _footerTipLable = [[UILabel alloc] init];
        _footerTipLable.textColor = color255(159, 159, 159);
        _footerTipLable.text = @"上拉加载更多...";
        _footerTipLable.font = [UIFont systemFontOfSize:14];
        _footerTipLable.textAlignment = NSTextAlignmentCenter;
    }
    return _footerTipLable;
}

@end
