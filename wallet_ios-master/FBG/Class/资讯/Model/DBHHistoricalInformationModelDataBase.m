//
//  DBHHistoricalInformationModelDataBase.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHHistoricalInformationModelDataBase.h"
#import "DBHHistoricalInformationModelData.h"


NSString *const kDBHHistoricalInformationModelDataBaseLastPageUrl = @"last_page_url";
NSString *const kDBHHistoricalInformationModelDataBasePrevPageUrl = @"prev_page_url";
NSString *const kDBHHistoricalInformationModelDataBaseFrom = @"from";
NSString *const kDBHHistoricalInformationModelDataBaseTotal = @"total";
NSString *const kDBHHistoricalInformationModelDataBasePath = @"path";
NSString *const kDBHHistoricalInformationModelDataBaseFirstPageUrl = @"first_page_url";
NSString *const kDBHHistoricalInformationModelDataBaseNextPageUrl = @"next_page_url";
NSString *const kDBHHistoricalInformationModelDataBaseLastPage = @"last_page";
NSString *const kDBHHistoricalInformationModelDataBaseData = @"data";
NSString *const kDBHHistoricalInformationModelDataBaseCurrentPage = @"current_page";
NSString *const kDBHHistoricalInformationModelDataBasePerPage = @"per_page";
NSString *const kDBHHistoricalInformationModelDataBaseTo = @"to";


@interface DBHHistoricalInformationModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHHistoricalInformationModelDataBase

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
            self.lastPageUrl = [self objectOrNilForKey:kDBHHistoricalInformationModelDataBaseLastPageUrl fromDictionary:dict];
            self.prevPageUrl = [self objectOrNilForKey:kDBHHistoricalInformationModelDataBasePrevPageUrl fromDictionary:dict];
            self.from = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataBaseFrom fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataBaseTotal fromDictionary:dict] doubleValue];
            self.path = [self objectOrNilForKey:kDBHHistoricalInformationModelDataBasePath fromDictionary:dict];
            self.firstPageUrl = [self objectOrNilForKey:kDBHHistoricalInformationModelDataBaseFirstPageUrl fromDictionary:dict];
            self.nextPageUrl = [self objectOrNilForKey:kDBHHistoricalInformationModelDataBaseNextPageUrl fromDictionary:dict];
            self.lastPage = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataBaseLastPage fromDictionary:dict] doubleValue];
    NSObject *receivedDBHHistoricalInformationModelData = [dict objectForKey:kDBHHistoricalInformationModelDataBaseData];
    NSMutableArray *parsedDBHHistoricalInformationModelData = [NSMutableArray array];
    
    if ([receivedDBHHistoricalInformationModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHHistoricalInformationModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHHistoricalInformationModelData addObject:[DBHHistoricalInformationModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHHistoricalInformationModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHHistoricalInformationModelData addObject:[DBHHistoricalInformationModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHHistoricalInformationModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHHistoricalInformationModelData];
            self.currentPage = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataBaseCurrentPage fromDictionary:dict] doubleValue];
            self.perPage = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataBasePerPage fromDictionary:dict] doubleValue];
            self.to = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataBaseTo fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lastPageUrl forKey:kDBHHistoricalInformationModelDataBaseLastPageUrl];
    [mutableDict setValue:self.prevPageUrl forKey:kDBHHistoricalInformationModelDataBasePrevPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.from] forKey:kDBHHistoricalInformationModelDataBaseFrom];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kDBHHistoricalInformationModelDataBaseTotal];
    [mutableDict setValue:self.path forKey:kDBHHistoricalInformationModelDataBasePath];
    [mutableDict setValue:self.firstPageUrl forKey:kDBHHistoricalInformationModelDataBaseFirstPageUrl];
    [mutableDict setValue:self.nextPageUrl forKey:kDBHHistoricalInformationModelDataBaseNextPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastPage] forKey:kDBHHistoricalInformationModelDataBaseLastPage];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHHistoricalInformationModelDataBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.currentPage] forKey:kDBHHistoricalInformationModelDataBaseCurrentPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perPage] forKey:kDBHHistoricalInformationModelDataBasePerPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.to] forKey:kDBHHistoricalInformationModelDataBaseTo];

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

    self.lastPageUrl = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataBaseLastPageUrl];
    self.prevPageUrl = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataBasePrevPageUrl];
    self.from = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataBaseFrom];
    self.total = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataBaseTotal];
    self.path = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataBasePath];
    self.firstPageUrl = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataBaseFirstPageUrl];
    self.nextPageUrl = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataBaseNextPageUrl];
    self.lastPage = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataBaseLastPage];
    self.data = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataBaseData];
    self.currentPage = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataBaseCurrentPage];
    self.perPage = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataBasePerPage];
    self.to = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataBaseTo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lastPageUrl forKey:kDBHHistoricalInformationModelDataBaseLastPageUrl];
    [aCoder encodeObject:_prevPageUrl forKey:kDBHHistoricalInformationModelDataBasePrevPageUrl];
    [aCoder encodeDouble:_from forKey:kDBHHistoricalInformationModelDataBaseFrom];
    [aCoder encodeDouble:_total forKey:kDBHHistoricalInformationModelDataBaseTotal];
    [aCoder encodeObject:_path forKey:kDBHHistoricalInformationModelDataBasePath];
    [aCoder encodeObject:_firstPageUrl forKey:kDBHHistoricalInformationModelDataBaseFirstPageUrl];
    [aCoder encodeObject:_nextPageUrl forKey:kDBHHistoricalInformationModelDataBaseNextPageUrl];
    [aCoder encodeDouble:_lastPage forKey:kDBHHistoricalInformationModelDataBaseLastPage];
    [aCoder encodeObject:_data forKey:kDBHHistoricalInformationModelDataBaseData];
    [aCoder encodeDouble:_currentPage forKey:kDBHHistoricalInformationModelDataBaseCurrentPage];
    [aCoder encodeDouble:_perPage forKey:kDBHHistoricalInformationModelDataBasePerPage];
    [aCoder encodeDouble:_to forKey:kDBHHistoricalInformationModelDataBaseTo];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHHistoricalInformationModelDataBase *copy = [[DBHHistoricalInformationModelDataBase alloc] init];
    
    
    
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
        copy.perPage = self.perPage;
        copy.to = self.to;
    }
    
    return copy;
}


@end
