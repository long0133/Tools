//
//  DBHProjectLookForProjectCommunityTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/26.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHProjectDetailInformationModelCategoryMedia;

@interface DBHProjectLookForProjectCommunityTableViewCell : DBHBaseTableViewCell

/**
 项目社区信息
 */
@property (nonatomic, strong) DBHProjectDetailInformationModelCategoryMedia *model;

@end
