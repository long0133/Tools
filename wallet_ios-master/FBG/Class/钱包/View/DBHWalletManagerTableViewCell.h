//
//  DBHWalletManagerTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/5.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHWalletManagerForNeoModelList;

@interface DBHWalletManagerTableViewCell : DBHBaseTableViewCell

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 钱包数据
 */
@property (nonatomic, strong) DBHWalletManagerForNeoModelList *model;

@end
