//
//  DBHAddressBookTableViewCell.h
//  Trinity
//
//  Created by 邓毕华 on 2017/12/28.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHAddressBookModelList;

@interface DBHAddressBookTableViewCell : DBHBaseTableViewCell

/**
 联系人信息
 */
@property (nonatomic, strong) DBHAddressBookModelList *model;

@end
