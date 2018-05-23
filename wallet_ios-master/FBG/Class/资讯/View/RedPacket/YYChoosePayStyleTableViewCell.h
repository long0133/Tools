//
//  YYChoosePayStyleTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

#define CHOOSE_PAY_STYLE_CELL_ID @"CHOOSE_PAY_STYLE_CELL"

@interface YYChoosePayStyleTableViewCell : DBHBaseTableViewCell

- (void)setModel:(DBHWalletManagerForNeoModelList *)model currentWalletID:(NSInteger)currentWalletID tokenName:(NSString *)tokenName;

@end
