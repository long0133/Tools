//
//  DBHHomePageTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHWalletDetailTokenInfomationModelData;

@interface DBHHomePageTableViewCell : DBHBaseTableViewCell

/**
 代币
 */
@property (nonatomic, strong) DBHWalletDetailTokenInfomationModelData *model;

@end
