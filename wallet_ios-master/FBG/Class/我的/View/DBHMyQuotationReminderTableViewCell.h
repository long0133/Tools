//
//  DBHMyQuotationReminderTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/23.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHInformationModelData;

@interface DBHMyQuotationReminderTableViewCell : DBHBaseTableViewCell

/**
 行情提醒
 */
@property (nonatomic, strong) DBHInformationModelData *model;

@end
