//
//  DBHProjectLookForProjectInfomationTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHProjectDetailInformationModelData;

typedef void(^ClickTypeButtonBlock)(NSInteger type);

@interface DBHProjectLookForProjectInfomationTableViewCell : DBHBaseTableViewCell

/**
 项目详情信息
 */
@property (nonatomic, strong) DBHProjectDetailInformationModelData *projectDetailModel;;

- (void)clickTypeButtonBlock:(ClickTypeButtonBlock)clickTypeButtonBlock;

@end
