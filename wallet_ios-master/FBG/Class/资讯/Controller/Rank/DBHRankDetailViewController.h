//
//  DBHRankDetailViewController.h
//  FBG
//
//  Created by yy on 2018/3/30.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseViewController.h"

#define RANKDETAIL_STORYBOARD_NAME @"RankDetail"
#define RANKDETAIL_STORYBOARD_ID @"RANKDETAIL_STORYBOARD_ID"

@class DBHRankMarketGainsModel;

@interface DBHRankDetailViewController : DBHBaseViewController

@property (nonatomic, strong) DBHRankMarketGainsModel *model;

@end
