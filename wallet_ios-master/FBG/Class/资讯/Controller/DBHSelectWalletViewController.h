//
//  DBHSelectWalletViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

typedef void(^SelectdWalletBlock)(NSInteger selectdRow);

@interface DBHSelectWalletViewController : DBHBaseViewController

/**
 当前选中行数
 */
@property (nonatomic, assign) NSInteger currentSelectedRow;

/**
 选择钱包回调
 */
- (void)selectdWalletBlock:(SelectdWalletBlock)selectdWalletBlock;

@end
