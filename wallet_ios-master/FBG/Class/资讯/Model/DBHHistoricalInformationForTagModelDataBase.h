//
//  DBHHistoricalInformationForTagModelDataBase.h
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHHistoricalInformationForTagModelDataBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *lastPageUrl;
@property (nonatomic, assign) id prevPageUrl;
@property (nonatomic, assign) double from;
@property (nonatomic, assign) double total;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *firstPageUrl;
@property (nonatomic, assign) id nextPageUrl;
@property (nonatomic, assign) double lastPage;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) double currentPage;
@property (nonatomic, assign) double perPage;
@property (nonatomic, assign) double to;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
