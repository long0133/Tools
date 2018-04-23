//
//  CYLCountDownButton.h
//  CYLAppBaseFrameWork
//
//  Created by chinapex on 2018/4/20.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ZJNButton.h"
@interface CYLCountDownButton : ZJNButton
- (instancetype)initWithPeriod:(CGFloat)period countToZeroBlock:(dispatch_block_t)zeroBlock;
@end
