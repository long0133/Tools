//
//  DBHTransferListTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/8.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHWalletManagerForNeoModelList;
@class DBHTransferListModelList;

@interface DBHTransferListTableViewCell : DBHBaseTableViewCell

/**
 转账记录
 */
@property (nonatomic, strong) DBHTransferListModelList *model;

@property (nonatomic, strong) DBHWalletManagerForNeoModelList *neoWalletModel;

@end
