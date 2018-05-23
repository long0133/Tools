//
//  DBHExchangeNoticeModelDataBase.m
//
//  Created by   on 2018/2/8
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHExchangeNoticeModelDataBase.h"
#import "DBHExchangeNoticeModelData.h"


NSString *const kDBHExchangeNoticeModelDataBaseLastPageUrl = @"last_page_url";
NSString *const kDBHExchangeNoticeModelDataBasePrevPageUrl = @"prev_page_url";
NSString *const kDBHExchangeNoticeModelDataBaseFrom = @"from";
NSString *const kDBHExchangeNoticeModelDataBaseTotal = @"total";
NSString *const kDBHExchangeNoticeModelDataBasePath = @"path";
NSString *const kDBHExchangeNoticeModelDataBaseFirstPageUrl = @"first_page_url";
NSString *const kDBHExchangeNoticeModelDataBaseNextPageUrl = @"next_page_url";
NSString *const kDBHExchangeNoticeModelDataBaseLastPage = @"last_page";
NSString *const kDBHExchangeNoticeModelDataBaseData = @"data";
NSString *const kDBHExchangeNoticeModelDataBaseCurrentPage = @"current_page";
NSString *const kDBHExchangeNoticeModelDataBasePerPage = @"per_page";
NSString *const kDBHExchangeNoticeModelDataBaseTo = @"to";


@interface DBHExchangeNoticeModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHExchangeNoticeModelDataBase

@synthesize lastPageUrl = _lastPageUrl;
@synthesize prevPageUrl = _prevPageUrl;
@synthesize from = _from;
@synthesize total = _total;
@synthesize path = _path;
@synthesize firstPageUrl = _firstPageUrl;
@synthesize nextPageUrl = _nextPageUrl;
@synthesize lastPage = _lastPage;
@synthesize data = _data;
@synthesize currentPage = _currentPage;
@synthesize perPage = _perPage;
@synthesize to = _to;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.lastPageUrl = [self objectOrNilForKey:kDBHExchangeNoticeModelDataBaseLastPageUrl fromDictionary:dict];
            self.prevPageUrl = [self objectOrNilForKey:kDBHExchangeNoticeModelDataBasePrevPageUrl fromDictionary:dict];
            self.from = [[self objectOrNilForKey:kDBHExchangeNoticeModelDataBaseFrom fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kDBHExchangeNoticeModelDataBaseTotal fromDictionary:dict] doubleValue];
            self.path = [self objectOrNilForKey:kDBHExchangeNoticeModelDataBasePath fromDictionary:dict];
            self.firstPageUrl = [self objectOrNilForKey:kDBHExchangeNoticeModelDataBaseFirstPageUrl fromDictionary:dict];
            self.nextPageUrl = [self objectOrNilForKey:kDBHExchangeNoticeModelDataBaseNextPageUrl fromDictionary:dict];
            self.lastPage = [[self objectOrNilForKey:kDBHExchangeNoticeModelDataBaseLastPage fromDictionary:dict] doubleValue];
    NSObject *receivedDBHExchangeNoticeModelData = [dict objectForKey:kDBHExchangeNoticeModelDataBaseData];
    NSMutableArray *parsedDBHExchangeNoticeModelData = [NSMutableArray array];
    
    if ([receivedDBHExchangeNoticeModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHExchangeNoticeModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHExchangeNoticeModelData addObject:[DBHExchangeNoticeModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHExchangeNoticeModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHExchangeNoticeModelData addObject:[DBHExchangeNoticeModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHExchangeNoticeModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHExchangeNoticeModelData];
            self.currentPage = [[self objectOrNilForKey:kDBHExchangeNoticeModelDataBaseCurrentPage fromDictionary:dict] doubleValue];
            self.perPage = [self objectOrNilForKey:kDBHExchangeNoticeModelDataBasePerPage fromDictionary:dict];
            self.to = [[self objectOrNilForKey:kDBHExchangeNoticeModelDataBaseTo fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lastPageUrl forKey:kDBHExchangeNoticeModelDataBaseLastPageUrl];
    [mutableDict setValue:self.prevPageUrl forKey:kDBHExchangeNoticeModelDataBasePrevPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.from] forKey:kDBHExchangeNoticeModelDataBaseFrom];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kDBHExchangeNoticeModelDataBaseTotal];
    [mutableDict setValue:self.path forKey:kDBHExchangeNoticeModelDataBasePath];
    [mutableDict setValue:self.firstPageUrl forKey:kDBHExchangeNoticeModelDataBaseFirstPageUrl];
    [mutableDict setValue:self.nextPageUrl forKey:kDBHExchangeNoticeModelDataBaseNextPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastPage] forKey:kDBHExchangeNoticeModelDataBaseLastPage];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHExchangeNoticeModelDataBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.currentPage] forKey:kDBHExchangeNoticeModelDataBaseCurrentPage];
    [mutableDict setValue:self.perPage forKey:kDBHExchangeNoticeModelDataBasePerPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.to] forKey:kDBHExchangeNoticeModelDataBaseTo];

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

    self.lastPageUrl = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataBaseLastPageUrl];
    self.prevPageUrl = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataBasePrevPageUrl];
    self.from = [aDecoder decodeDoubleForKey:kDBHExchangeNoticeModelDataBaseFrom];
    self.total = [aDecoder decodeDoubleForKey:kDBHExchangeNoticeModelDataBaseTotal];
    self.path = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataBasePath];
    self.firstPageUrl = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataBaseFirstPageUrl];
    self.nextPageUrl = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataBaseNextPageUrl];
    self.lastPage = [aDecoder decodeDoubleForKey:kDBHExchangeNoticeModelDataBaseLastPage];
    self.data = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataBaseData];
    self.currentPage = [aDecoder decodeDoubleForKey:kDBHExchangeNoticeModelDataBaseCurrentPage];
    self.perPage = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataBasePerPage];
    self.to = [aDecoder decodeDoubleForKey:kDBHExchangeNoticeModelDataBaseTo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lastPageUrl forKey:kDBHExchangeNoticeModelDataBaseLastPageUrl];
    [aCoder encodeObject:_prevPageUrl forKey:kDBHExchangeNoticeModelDataBasePrevPageUrl];
    [aCoder encodeDouble:_from forKey:kDBHExchangeNoticeModelDataBaseFrom];
    [aCoder encodeDouble:_total forKey:kDBHExchangeNoticeModelDataBaseTotal];
    [aCoder encodeObject:_path forKey:kDBHExchangeNoticeModelDataBasePath];
    [aCoder encodeObject:_firstPageUrl forKey:kDBHExchangeNoticeModelDataBaseFirstPageUrl];
    [aCoder encodeObject:_nextPageUrl forKey:kDBHExchangeNoticeModelDataBaseNextPageUrl];
    [aCoder encodeDouble:_lastPage forKey:kDBHExchangeNoticeModelDataBaseLastPage];
    [aCoder encodeObject:_data forKey:kDBHExchangeNoticeModelDataBaseData];
    [aCoder encodeDouble:_currentPage forKey:kDBHExchangeNoticeModelDataBaseCurrentPage];
    [aCoder encodeObject:_perPage forKey:kDBHExchangeNoticeModelDataBasePerPage];
    [aCoder encodeDouble:_to forKey:kDBHExchangeNoticeModelDataBaseTo];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHExchangeNoticeModelDataBase *copy = [[DBHExchangeNoticeModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.lastPageUrl = [self.lastPageUrl copyWithZone:zone];
        copy.prevPageUrl = [self.prevPageUrl copyWithZone:zone];
        copy.from = self.from;
        copy.total = self.total;
        copy.path = [self.path copyWithZone:zone];
        copy.firstPageUrl = [self.firstPageUrl copyWithZone:zone];
        copy.nextPageUrl = [self.nextPageUrl copyWithZone:zone];
        copy.lastPage = self.lastPage;
        copy.data = [self.data copyWithZone:zone];
        copy.currentPage = self.currentPage;
        copy.perPage = [self.perPage copyWithZone:zone];
        copy.to = self.to;
    }
    
    return copy;
}


@end
