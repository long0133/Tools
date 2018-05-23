//
//  DBHTradingMarketCharTableViewCell.h
//  FBG
//
//  Created by yy on 2018/3/16.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHBaseTableViewCell.h"
#import "DBHProjectDetailInformationModelData.h"
#import "DBHInformationModelData.h"

@interface DBHTradingMarketCharTableViewCell : DBHBaseTableViewCell

- (void)setDetailModel:(DBHProjectDetailInformationModelData *)detailModel infoModel:(DBHInformationModelData *)infoModel;
- (void)refreshChartData;
- (void)setTimerNil;
@end
