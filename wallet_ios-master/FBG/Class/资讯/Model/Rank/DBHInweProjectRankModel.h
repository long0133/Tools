//
//  DBHInweProjectRankModel.h
//  FBG
//
//  Created by yy on 2018/4/2.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHInformationModelData.h"

@interface DBHInweProjectRankModel : NSObject

@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *long_name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *industry;
@property (nonatomic, copy) NSString *favorite;
@property (nonatomic, copy) NSString *search_rate;
@property (nonatomic, copy) NSString *click_rate;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *score_sum;
@property (nonatomic, copy) NSString *rank_score;
@property (nonatomic, copy) NSString *rank;

@property (nonatomic, strong) DBHInformationModelData *projectModel;

@end
