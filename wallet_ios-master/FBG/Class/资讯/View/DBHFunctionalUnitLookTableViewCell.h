//
//  DBHFunctionalUnitLookTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/31.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

typedef void(^ClickTypeButtonBlock)();

@interface DBHFunctionalUnitLookTableViewCell : DBHBaseTableViewCell

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

- (void)clickTypeButtonBlock:(ClickTypeButtonBlock)clickTypeButtonBlock;

@end
