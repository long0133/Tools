//
//  DBHMarketDetailKLineViewModelData.h
//
//  Created by   on 2017/12/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHMarketDetailKLineViewModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *volume;
@property (nonatomic, strong) NSString *minPrice;
@property (nonatomic, assign) double endTime;
@property (nonatomic, strong) NSString *closedPrice;
@property (nonatomic, assign) double time;
@property (nonatomic, strong) NSString *openedPrice;
@property (nonatomic, strong) NSString *maxPrice;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
