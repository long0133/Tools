//
//  CYLCountDownButton.m
//  CYLAppBaseFrameWork
//
//  Created by chinapex on 2018/4/20.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLCountDownButton.h"

@interface CYLCountDownButton()
@property (nonatomic, assign) CGFloat countPeriod;
@property (nonatomic, copy) dispatch_block_t countToZeroBlock;
@property (nonatomic, strong) RACCommand *countDownCommand;
@property (nonatomic, strong) RACSignal *isValidSignal;
@property (nonatomic, assign) CGFloat currentCountDown;
@end

@implementation CYLCountDownButton

- (instancetype)initWithPeriod:(CGFloat)period countToZeroBlock:(dispatch_block_t)zeroBlock{
    if(self = [super init]){
        self.countPeriod = period;
        self.countToZeroBlock = zeroBlock;
        self.currentCountDown = 0;
        [self countDownAction];
    }
    return self;
}

- (void)countDownAction{
    self.rac_command = self.countDownCommand;
}

#pragma mark - getter setter
- (RACCommand *)countDownCommand{
    if (!_countDownCommand) {
//        _countDownCommand = [[RACCommand alloc] initWithEnabled:self.isValidSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//            
//        }];
    }
    return _countDownCommand;
}

- (RACSignal *)isValidSignal{
    if (!_isValidSignal) {
        _isValidSignal = [RACObserve(self, currentCountDown) map:^id _Nullable(NSNumber *value) {
            return @(value.integerValue == 0);
        }];
    }
    return _isValidSignal;
}
@end
