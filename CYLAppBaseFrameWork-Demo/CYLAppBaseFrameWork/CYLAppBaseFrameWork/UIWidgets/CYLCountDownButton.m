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
@property (nonatomic, copy) dispatch_block_t beginBlock;
@property (nonatomic, strong) RACCommand *countDownCommand;
@property (nonatomic, strong) RACSignal *isValidSignal;
@property (nonatomic, assign) NSInteger currentCountDown;
@property (nonatomic, strong) NSTimer *countDownTimer; /**<  */
@property (nonatomic, strong) RACDisposable *countDownDisposable; /**<  */
@property (nonatomic, strong) NSString *originText; /**<  */
@end

@implementation CYLCountDownButton

- (instancetype)initWithPeriod:(CGFloat)period beginCountBlock:(dispatch_block_t)beginBlock countToZeroBlock:(dispatch_block_t)zeroBlock{
    if(self = [super init]){
        self.countPeriod = period;
        self.countToZeroBlock = zeroBlock;
        self.beginBlock = beginBlock;
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
        _countDownCommand = [[RACCommand alloc] initWithEnabled:self.isValidSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            _originText = self.titleLabel.text;
            self.currentCountDown = self.countPeriod;
            if (self.beginBlock) self.beginBlock();
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    
                    [self setTitle:[NSString stringWithFormat:@"%lds",(long)self.currentCountDown] forState:UIControlStateNormal];
                    if (self.currentCountDown == 0) {
                        [self setTitle:_originText forState:UIControlStateNormal];
                        if (self.countToZeroBlock) self.countToZeroBlock();
                        [subscriber sendCompleted];
                        [timer invalidate];
                    }else{
                        self.currentCountDown -= 1;
                    }
                    
                }];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                [timer fire];

                return nil;
            }];
            return signal;
        }];
    }
    return _countDownCommand;
}

- (RACSignal *)isValidSignal{
    if (!_isValidSignal) {
        _isValidSignal = [[RACObserve(self, currentCountDown) takeUntil:self.rac_willDeallocSignal] map:^id _Nullable(NSNumber *value) {
            return @(value.integerValue == 0);
        }];
    }
    return _isValidSignal;
}
@end
