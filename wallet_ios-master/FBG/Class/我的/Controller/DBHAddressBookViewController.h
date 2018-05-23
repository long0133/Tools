//
//  DBHAddressBookViewController.h
//  Trinity
//
//  Created by 邓毕华 on 2017/12/28.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHBaseViewController.h"

typedef void(^SelectedAddressBlock)(NSString *address);

@interface DBHAddressBookViewController : DBHBaseViewController


@property (nonatomic, assign) NSInteger currentSelectedItem; // 当前选中的Item
@property (nonatomic, assign) BOOL isSelected;

- (void)selectedAddressBlock:(SelectedAddressBlock)selectedAddressBlock;

@end
