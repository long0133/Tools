//
//  DBHMarketDetailMoneyRealTimePriceModelDataBase.m
//
//  Created by   on 2017/12/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHMarketDetailMoneyRealTimePriceModelDataBase.h"
#import "DBHMarketDetailMoneyRealTimePriceModelData.h"


NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataBaseCode = @"code";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataBaseData = @"data";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataBaseMsg = @"msg";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataBaseUrl = @"url";


@interface DBHMarketDetailMoneyRealTimePriceModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHMarketDetailMoneyRealTimePriceModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHMarketDetailMoneyRealTimePriceModelData = [dict objectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseData];
    NSMutableArray *parsedDBHMarketDetailMoneyRealTimePriceModelData = [NSMutableArray array];
    
    if ([receivedDBHMarketDetailMoneyRealTimePriceModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHMarketDetailMoneyRealTimePriceModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHMarketDetailMoneyRealTimePriceModelData addObject:[DBHMarketDetailMoneyRealTimePriceModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHMarketDetailMoneyRealTimePriceModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHMarketDetailMoneyRealTimePriceModelData addObject:[DBHMarketDetailMoneyRealTimePriceModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHMarketDetailMoneyRealTimePriceModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHMarketDetailMoneyRealTimePriceModelData];
            self.msg = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHMarketDetailMoneyRealTimePriceModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHMarketDetailMoneyRealTimePriceModelDataBase *copy = [[DBHMarketDetailMoneyRealTimePriceModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
