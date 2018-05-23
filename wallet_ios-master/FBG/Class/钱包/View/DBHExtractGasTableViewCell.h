//
//  DBHExtractGasTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHWalletDetailTokenInfomationModelData;

typedef void(^UnfreezeBlock)();

@interface DBHExtractGasTableViewCell : DBHBaseTableViewCell

/**
 gas代币Model
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *gasTokenModel;

/**
 解冻回调
 */
- (void)unfreezeBlock:(UnfreezeBlock)unfreezeBlock;

@end
