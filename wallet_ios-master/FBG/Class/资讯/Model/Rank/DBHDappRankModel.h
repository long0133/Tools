//
//  DBHDappRankModel.h
//  FBG
//
//  Created by yy on 2018/4/2.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHDappRankModel : NSObject

@property (nonatomic, copy) NSString *modelId; 
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *disabled;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *contractsCount;
@property (nonatomic, copy) NSString *featured;
@property (nonatomic, copy) NSString *volumeLastDay;
@property (nonatomic, copy) NSString *volumeLastWeek;
@property (nonatomic, copy) NSString *txLastDay;
@property (nonatomic, copy) NSString *txLastWeek;
@property (nonatomic, copy) NSString *dauLastDay;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *nsfw;
@property (nonatomic, copy) NSString *slug;

@end
