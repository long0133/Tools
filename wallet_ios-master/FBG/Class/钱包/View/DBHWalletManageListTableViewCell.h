//
//  DBHWalletManageListTableViewCell.h
//  FBG
//
//  Created by yy on 2018/3/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHWalletManagerForNeoModelList;

@interface DBHWalletManageListTableViewCell : DBHBaseTableViewCell
/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 钱包数据
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *model;

@end
