//
//  DBHProjectHomeTypeOneTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

typedef void(^ClickButtonBlock)(NSInteger type);

@class DBHInformationModelData;

@interface DBHProjectHomeTypeOneTableViewCell : DBHBaseTableViewCell

/**
 项目信息
 */
@property (nonatomic, strong) DBHInformationModelData *projectModel;

/**
 点击按钮回调
 */
- (void)clickButtonBlock:(ClickButtonBlock)clickButtonBlock;

@end
