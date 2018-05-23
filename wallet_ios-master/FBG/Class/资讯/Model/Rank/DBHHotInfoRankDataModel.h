//
//  DBHHotInfoRankDataModel.h
//  FBG
//
//  Created by yy on 2018/4/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHHotInfoDataCategoryModel.h"

@interface DBHHotInfoRankDataModel : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, strong) DBHHotInfoDataCategoryModel *category;
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, assign) NSInteger click_rate;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *data_id;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger is_hot;
@property (nonatomic, assign) BOOL is_scroll;
@property (nonatomic, assign) BOOL is_sole;
@property (nonatomic, assign) BOOL is_top;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *video;


@end
