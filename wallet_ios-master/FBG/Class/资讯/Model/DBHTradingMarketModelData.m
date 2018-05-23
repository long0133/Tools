//
//  DBHTradingMarketModelData.m
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHTradingMarketModelData.h"


NSString *const kDBHTradingMarketModelDataPairce = @"pairce";
NSString *const kDBHTradingMarketModelDataSource = @"source";
NSString *const kDBHTradingMarketModelDataSort = @"sort";
NSString *const kDBHTradingMarketModelDataUpdate = @"update";
NSString *const kDBHTradingMarketModelDataVolumPercent = @"volum_percent";
NSString *const kDBHTradingMarketModelDataVolum24 = @"volum_24";
NSString *const kDBHTradingMarketModelDataPair = @"pair";
NSString *const kDBHTradingMarketModelDataUrl = @"url";


@interface DBHTradingMarketModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHTradingMarketModelData

@synthesize pairce = _pairce;
@synthesize source = _source;
@synthesize sort = _sort;
@synthesize update = _update;
@synthesize volumPercent = _volumPercent;
@synthesize volum24 = _volum24;
@synthesize pair = _pair;
@synthesize url = _url;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.pairce = [self objectOrNilForKey:kDBHTradingMarketModelDataPairce fromDictionary:dict];
        self.source = [self objectOrNilForKey:kDBHTradingMarketModelDataSource fromDictionary:dict];
        self.sort = [self objectOrNilForKey:kDBHTradingMarketModelDataSort fromDictionary:dict];
        self.update = [self objectOrNilForKey:kDBHTradingMarketModelDataUpdate fromDictionary:dict];
        self.volumPercent = [self objectOrNilForKey:kDBHTradingMarketModelDataVolumPercent fromDictionary:dict];
        self.volum24 = [self objectOrNilForKey:kDBHTradingMarketModelDataVolum24 fromDictionary:dict];
        self.pair = [self objectOrNilForKey:kDBHTradingMarketModelDataPair fromDictionary:dict];
        self.url = [self objectOrNilForKey:kDBHTradingMarketModelDataUrl fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.pairce forKey:kDBHTradingMarketModelDataPairce];
    [mutableDict setValue:self.source forKey:kDBHTradingMarketModelDataSource];
    [mutableDict setValue:self.sort forKey:kDBHTradingMarketModelDataSort];
    [mutableDict setValue:self.update forKey:kDBHTradingMarketModelDataUpdate];
    [mutableDict setValue:self.volumPercent forKey:kDBHTradingMarketModelDataVolumPercent];
    [mutableDict setValue:self.volum24 forKey:kDBHTradingMarketModelDataVolum24];
    [mutableDict setValue:self.pair forKey:kDBHTradingMarketModelDataPair];
    [mutableDict setValue:self.url forKey:kDBHTradingMarketModelDataUrl];

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

    self.pairce = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataPairce];
    self.source = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataSource];
    self.sort = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataSort];
    self.update = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataUpdate];
    self.volumPercent = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataVolumPercent];
    self.volum24 = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataVolum24];
    self.pair = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataPair];
    self.url = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_pairce forKey:kDBHTradingMarketModelDataPairce];
    [aCoder encodeObject:_source forKey:kDBHTradingMarketModelDataSource];
    [aCoder encodeObject:_sort forKey:kDBHTradingMarketModelDataSort];
    [aCoder encodeObject:_update forKey:kDBHTradingMarketModelDataUpdate];
    [aCoder encodeObject:_volumPercent forKey:kDBHTradingMarketModelDataVolumPercent];
    [aCoder encodeObject:_volum24 forKey:kDBHTradingMarketModelDataVolum24];
    [aCoder encodeObject:_pair forKey:kDBHTradingMarketModelDataPair];
    [aCoder encodeObject:_pair forKey:kDBHTradingMarketModelDataUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHTradingMarketModelData *copy = [[DBHTradingMarketModelData alloc] init];
    if (copy) {

        copy.pairce = [self.pairce copyWithZone:zone];
        copy.source = [self.source copyWithZone:zone];
        copy.sort = [self.sort copyWithZone:zone];
        copy.update = [self.update copyWithZone:zone];
        copy.volumPercent = [self.volumPercent copyWithZone:zone];
        copy.volum24 = [self.volum24 copyWithZone:zone];
        copy.pair = [self.pair copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
