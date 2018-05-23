//
//  DBHProjectHomeViewController.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

@class DBHInformationModelData;

@interface DBHProjectHomeViewController : DBHBaseViewController

/**
 项目信息
 */
@property (nonatomic, strong) DBHInformationModelData *projectModel;

@end
