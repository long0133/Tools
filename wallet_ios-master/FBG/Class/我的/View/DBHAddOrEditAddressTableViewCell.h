//
//  DBHAddOrEditAddressTableViewCell.h
//  Trinity
//
//  Created by 邓毕华 on 2017/12/28.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

typedef void(^ScanQrCodeBlock)();

@interface DBHAddOrEditAddressTableViewCell : DBHBaseTableViewCell

/**
 姓名
 */
@property (nonatomic, strong) UITextField *nameTextField;

/**
 地址
 */
@property (nonatomic, strong) UITextField *addressTextField;

- (void)scanQrCodeBlock:(ScanQrCodeBlock)scanQrCodeBlock;

@end
