//
//  DBHMarketDetailKLineViewModelDataBase.m
//
//  Created by   on 2017/12/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHMarketDetailKLineViewModelDataBase.h"
#import "DBHMarketDetailKLineViewModelData.h"


NSString *const kDBHMarketDetailKLineViewModelDataBaseCode = @"code";
NSString *const kDBHMarketDetailKLineViewModelDataBaseData = @"data";
NSString *const kDBHMarketDetailKLineViewModelDataBaseMsg = @"msg";
NSString *const kDBHMarketDetailKLineViewModelDataBaseUrl = @"url";


@interface DBHMarketDetailKLineViewModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHMarketDetailKLineViewModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHMarketDetailKLineViewModelData = [dict objectForKey:kDBHMarketDetailKLineViewModelDataBaseData];
    NSMutableArray *parsedDBHMarketDetailKLineViewModelData = [NSMutableArray array];
    
    if ([receivedDBHMarketDetailKLineViewModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHMarketDetailKLineViewModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHMarketDetailKLineViewModelData addObject:[DBHMarketDetailKLineViewModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHMarketDetailKLineViewModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHMarketDetailKLineViewModelData addObject:[DBHMarketDetailKLineViewModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHMarketDetailKLineViewModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHMarketDetailKLineViewModelData];
            self.msg = [self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHMarketDetailKLineViewModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHMarketDetailKLineViewModelDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHMarketDetailKLineViewModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHMarketDetailKLineViewModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHMarketDetailKLineViewModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHMarketDetailKLineViewModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHMarketDetailKLineViewModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHMarketDetailKLineViewModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHMarketDetailKLineViewModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHMarketDetailKLineViewModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHMarketDetailKLineViewModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHMarketDetailKLineViewModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHMarketDetailKLineViewModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHMarketDetailKLineViewModelDataBase *copy = [[DBHMarketDetailKLineViewModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
