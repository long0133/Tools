//
//  DBHWalletDetailTitleView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/12.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickShowPriceBlock)();

@interface DBHWalletDetailTitleView : UIView

/**
 总资产
 */
@property (nonatomic, copy) NSString *totalAsset;

@property(nonatomic, assign) CGSize intrinsicContentSize;

- (void)refreshAsset;

/**
 显示/隐藏资产回调
 */
- (void)clickShowPriceBlock:(ClickShowPriceBlock)clickShowPriceBlock;

@end
