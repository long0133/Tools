//
//  DBHCommentListTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
#define COMMENT_LIST_CELL_ID @"COMMENT_LIST_CELL"
@class DBHProjectCommentAllListDetailModel;

@interface DBHCommentListTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) DBHProjectCommentAllListDetailModel *model;

@end
