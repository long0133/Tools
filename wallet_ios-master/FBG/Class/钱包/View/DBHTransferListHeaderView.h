//
//  DBHTransferListHeaderView.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHTransferListHeaderView : UIView

/**
 余额
 */
@property (nonatomic, copy) NSString *balance;

/**
 资产
 */
@property (nonatomic, copy) NSString *asset;


/**
 图标地址
 */
@property (nonatomic, copy) NSString *headImageUrl;

@end
