//
//  DBHInformationTableViewCell.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/24.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"

@class DBHInformationModelData;
@class DBHInformationModelIco;

@interface DBHInformationTableViewCell : DBHBaseTableViewCell

/**
 项目信息
 */
@property (nonatomic, strong) DBHInformationModelData *model;

/**
 实时行情数据
 */
@property (nonatomic, strong) DBHInformationModelIco *icoModel;

/**
 功能组件标题
 */
@property (nonatomic, copy) NSString *functionalUnitTitle;

/**
 内容
 */
@property (nonatomic, copy) NSString *content;

/**
 时间
 */
@property (nonatomic, copy) NSString *time;

//@property (nonatomic, assign) BOOL isHasNum; // 圆点中是否有数字，如果没有 则小圆 否则大圆

/**
 未读消息数量
 */
//@property (nonatomic, copy) NSString *noReadNumber;

@property (nonatomic, assign) BOOL isNoRead;

@property (nonatomic, assign) NSInteger currentSelectedTitleIndex;

@end
