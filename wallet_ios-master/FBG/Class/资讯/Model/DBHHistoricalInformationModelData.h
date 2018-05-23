//
//  DBHHistoricalInformationModelData.h
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHHistoricalInformationModelCategory, DBHHistoricalInformationModelArticleUser;

@interface DBHHistoricalInformationModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *lang;
@property (nonatomic, assign) double clickRate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) double sort;
@property (nonatomic, strong) DBHHistoricalInformationModelCategory *category;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) BOOL isScroll;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) DBHHistoricalInformationModelArticleUser *articleUser;
@property (nonatomic, assign) BOOL isSole;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) NSString *author;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
