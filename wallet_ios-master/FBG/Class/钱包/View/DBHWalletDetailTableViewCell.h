//
//  DBHWalletDetailTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHWalletDetailTokenInfomationModelData;

typedef void(^ClickExtractButtonBlock)();

@interface DBHWalletDetailTableViewCell : DBHBaseTableViewCell

/**
 代币信息
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *model;

/**
 点击提取按钮回调
 */
- (void)clickExtractButtonBlock:(ClickExtractButtonBlock)clickExtractButtonBlock;

@end
