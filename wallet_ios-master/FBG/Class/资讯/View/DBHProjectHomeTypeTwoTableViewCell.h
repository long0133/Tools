//
//  DBHProjectHomeTypeTwoTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHProjectHomeNewsModelData;
@class DBHInformationModelData;
@class DBHProjectDetailInformationModelLastArticle;

@interface DBHProjectHomeTypeTwoTableViewCell : DBHBaseTableViewCell

/**
 项目资讯数据
 */
@property (nonatomic, strong) DBHProjectHomeNewsModelData *model;

/**
 项目信息
 */
@property (nonatomic, strong) DBHInformationModelData *projectModel;

/**
 最后一条数据
 */
@property (nonatomic, strong) DBHProjectDetailInformationModelLastArticle *lastModel;

@end
