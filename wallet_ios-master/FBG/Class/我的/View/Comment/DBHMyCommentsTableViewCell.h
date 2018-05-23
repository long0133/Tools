//
//  DBHMyCommentsTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
@class DBHProjectCommentModel;

#define MYCOMMENTS_CELL_ID @"MYCOMMENTS_CELL"

@interface DBHMyCommentsTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) DBHProjectCommentModel *model;

@end
