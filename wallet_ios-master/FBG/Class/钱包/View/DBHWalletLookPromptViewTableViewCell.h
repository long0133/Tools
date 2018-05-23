//
//  DBHWalletLookPromptViewTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/9.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHWalletManagerForNeoModelList;

@interface DBHWalletLookPromptViewTableViewCell : DBHBaseTableViewCell

/**
 查看的代币名称
 */
@property (nonatomic, copy) NSString *tokenName;

/**
 钱包Model
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *model;

@end
