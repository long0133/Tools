//
//  DBHCommentDetailTableViewCell.h
//  FBG
//
//  Created by yy on 2018/4/4.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

#define COMMENT_DETAIL_CELL_ID @"COMMENT_DETAIL_CELL"
#define COMMENT_DETAIL_DEFAULT_HEIGHT 140

typedef enum _from {
    CellFromList = 0,
    CellFromDetail
}CellFrom;

@class DBHProjectCommentModel;
@class DBHProjectCommentDetailModel;

@interface DBHCommentDetailTableViewCell : DBHBaseTableViewCell

@property (nonatomic, strong) DBHProjectCommentModel *model;
@property (nonatomic, strong) DBHProjectCommentDetailModel *detailModel;
//@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) CellFrom from;

@end
