//
//  YYRedPacketHomeHeaderView.h
//  FBG
//
//  Created by yy on 2018/4/17.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendRedPacketClickBlock) (void);

@interface YYRedPacketHomeHeaderView : UIView

@property (nonatomic, copy) SendRedPacketClickBlock clickBlock;

@end
