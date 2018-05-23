//
//  DBHMarketDetailKLineViewModelData.m
//
//  Created by   on 2017/12/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHMarketDetailKLineViewModelData.h"


NSString *const kDBHMarketDetailKLineViewModelDataVolume = @"volume";
NSString *const kDBHMarketDetailKLineViewModelDataMinPrice = @"min_price";
NSString *const kDBHMarketDetailKLineViewModelDataEndTime = @"end_time";
NSString *const kDBHMarketDetailKLineViewModelDataClosedPrice = @"closed_price";
NSString *const kDBHMarketDetailKLineViewModelDataTime = @"time";
NSString *const kDBHMarketDetailKLineViewModelDataOpenedPrice = @"opened_price";
NSString *const kDBHMarketDetailKLineViewModelDataMaxPrice = @"max_price";


@interface DBHMarketDetailKLineViewModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHMarketDetailKLineViewModelData

@synthesize volume = _volume;
@synthesize minPrice = _minPrice;
@synthesize endTime = _endTime;
@synthesize closedPrice = _closedPrice;
@synthesize time = _time;
@synthesize openedPrice = _openedPrice;
@synthesize maxPrice = _maxPrice;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.volume = [self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataVolume fromDictionary:dict];
            self.minPrice = [self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataMinPrice fromDictionary:dict];
            self.endTime = [[self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataEndTime fromDictionary:dict] doubleValue];
            self.closedPrice = [self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataClosedPrice fromDictionary:dict];
            self.time = [[self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataTime fromDictionary:dict] doubleValue];
            self.openedPrice = [self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataOpenedPrice fromDictionary:dict];
            self.maxPrice = [self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataMaxPrice fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.volume forKey:kDBHMarketDetailKLineViewModelDataVolume];
    [mutableDict setValue:self.minPrice forKey:kDBHMarketDetailKLineViewModelDataMinPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.endTime] forKey:kDBHMarketDetailKLineViewModelDataEndTime];
    [mutableDict setValue:self.closedPrice forKey:kDBHMarketDetailKLineViewModelDataClosedPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.time] forKey:kDBHMarketDetailKLineViewModelDataTime];
    [mutableDict setValue:self.openedPrice forKey:kDBHMarketDetailKLineViewModelDataOpenedPrice];
    [mutableDict setValue:self.maxPrice forKey:kDBHMarketDetailKLineViewModelDataMaxPrice];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.volume = [aDecoder decodeObjectForKey:kDBHMarketDetailKLineViewModelDataVolume];
    self.minPrice = [aDecoder decodeObjectForKey:kDBHMarketDetailKLineViewModelDataMinPrice];
    self.endTime = [aDecoder decodeDoubleForKey:kDBHMarketDetailKLineViewModelDataEndTime];
    self.closedPrice = [aDecoder decodeObjectForKey:kDBHMarketDetailKLineViewModelDataClosedPrice];
    self.time = [aDecoder decodeDoubleForKey:kDBHMarketDetailKLineViewModelDataTime];
    self.openedPrice = [aDecoder decodeObjectForKey:kDBHMarketDetailKLineViewModelDataOpenedPrice];
    self.maxPrice = [aDecoder decodeObjectForKey:kDBHMarketDetailKLineViewModelDataMaxPrice];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_volume forKey:kDBHMarketDetailKLineViewModelDataVolume];
    [aCoder encodeObject:_minPrice forKey:kDBHMarketDetailKLineViewModelDataMinPrice];
    [aCoder encodeDouble:_endTime forKey:kDBHMarketDetailKLineViewModelDataEndTime];
    [aCoder encodeObject:_closedPrice forKey:kDBHMarketDetailKLineViewModelDataClosedPrice];
    [aCoder encodeDouble:_time forKey:kDBHMarketDetailKLineViewModelDataTime];
    [aCoder encodeObject:_openedPrice forKey:kDBHMarketDetailKLineViewModelDataOpenedPrice];
    [aCoder encodeObject:_maxPrice forKey:kDBHMarketDetailKLineViewModelDataMaxPrice];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHMarketDetailKLineViewModelData *copy = [[DBHMarketDetailKLineViewModelData alloc] init];
    
    
    
    if (copy) {

        copy.volume = [self.volume copyWithZone:zone];
        copy.minPrice = [self.minPrice copyWithZone:zone];
        copy.endTime = self.endTime;
        copy.closedPrice = [self.closedPrice copyWithZone:zone];
        copy.time = self.time;
        copy.openedPrice = [self.openedPrice copyWithZone:zone];
        copy.maxPrice = [self.maxPrice copyWithZone:zone];
    }
    
    return copy;
}


@end
