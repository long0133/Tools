//
//  DBHTradingMarketModelDataBase.m
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHTradingMarketModelDataBase.h"
#import "DBHTradingMarketModelData.h"


NSString *const kDBHTradingMarketModelDataBaseCode = @"code";
NSString *const kDBHTradingMarketModelDataBaseData = @"data";
NSString *const kDBHTradingMarketModelDataBaseMsg = @"msg";
NSString *const kDBHTradingMarketModelDataBaseUrl = @"url";


@interface DBHTradingMarketModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHTradingMarketModelDataBase

@synthesize code = _code;
@synthesize data = _data;
@synthesize msg = _msg;
@synthesize url = _url;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.code = [[self objectOrNilForKey:kDBHTradingMarketModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHTradingMarketModelData = [dict objectForKey:kDBHTradingMarketModelDataBaseData];
    NSMutableArray *parsedDBHTradingMarketModelData = [NSMutableArray array];
    
    if ([receivedDBHTradingMarketModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHTradingMarketModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHTradingMarketModelData addObject:[DBHTradingMarketModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHTradingMarketModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHTradingMarketModelData addObject:[DBHTradingMarketModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHTradingMarketModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHTradingMarketModelData];
            self.msg = [self objectOrNilForKey:kDBHTradingMarketModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHTradingMarketModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHTradingMarketModelDataBaseCode];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.data) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHTradingMarketModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHTradingMarketModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHTradingMarketModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHTradingMarketModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHTradingMarketModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHTradingMarketModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHTradingMarketModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHTradingMarketModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHTradingMarketModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHTradingMarketModelDataBase *copy = [[DBHTradingMarketModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
