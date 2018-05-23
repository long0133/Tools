//
//  DBHAddOrEditAddressViewController.h
//  Trinity
//
//  Created by 邓毕华 on 2017/12/28.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHAddressBookModelList;

typedef enum : NSUInteger {
    DBHAddressViewControllerAddType,
    DBHAddressViewControllerEditType,
} AddressViewControllerType;

@interface DBHAddOrEditAddressViewController : DBHBaseViewController

@property (nonatomic, assign) AddressViewControllerType addressViewControllerType;

@property (nonatomic, copy) NSString *icoId;

/**
 联系人信息
 */
@property (nonatomic, strong) DBHAddressBookModelList *model;

@end
