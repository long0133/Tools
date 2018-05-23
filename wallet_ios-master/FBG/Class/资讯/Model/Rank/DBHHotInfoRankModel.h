//
//  DBHHotInfoRankModel.h
//  FBG
//
//  Created by yy on 2018/4/3.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHHotInfoRankDataModel.h"

@interface DBHHotInfoRankModel : NSObject

@property (nonatomic, assign) NSInteger current_page;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *first_page_url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *long_name;
@property (nonatomic, assign) NSInteger from;
@property (nonatomic, copy) NSString *last_page;
@property (nonatomic, copy) NSString *last_page_url;
@property (nonatomic, copy) NSString *next_page_url;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) NSInteger per_page;
@property (nonatomic, copy) NSString *prev_page_url;
@property (nonatomic, assign) NSInteger to;
@property (nonatomic, assign) NSInteger total;

@end
