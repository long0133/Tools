//
//  DBHHistoricalInformationForTagModelDataBase.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHHistoricalInformationForTagModelDataBase.h"
#import "DBHHistoricalInformationForTagModelData.h"


NSString *const kDBHHistoricalInformationForTagModelDataBaseLastPageUrl = @"last_page_url";
NSString *const kDBHHistoricalInformationForTagModelDataBasePrevPageUrl = @"prev_page_url";
NSString *const kDBHHistoricalInformationForTagModelDataBaseFrom = @"from";
NSString *const kDBHHistoricalInformationForTagModelDataBaseTotal = @"total";
NSString *const kDBHHistoricalInformationForTagModelDataBasePath = @"path";
NSString *const kDBHHistoricalInformationForTagModelDataBaseFirstPageUrl = @"first_page_url";
NSString *const kDBHHistoricalInformationForTagModelDataBaseNextPageUrl = @"next_page_url";
NSString *const kDBHHistoricalInformationForTagModelDataBaseLastPage = @"last_page";
NSString *const kDBHHistoricalInformationForTagModelDataBaseData = @"data";
NSString *const kDBHHistoricalInformationForTagModelDataBaseCurrentPage = @"current_page";
NSString *const kDBHHistoricalInformationForTagModelDataBasePerPage = @"per_page";
NSString *const kDBHHistoricalInformationForTagModelDataBaseTo = @"to";


@interface DBHHistoricalInformationForTagModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHHistoricalInformationForTagModelDataBase

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
            self.lastPageUrl = [self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBaseLastPageUrl fromDictionary:dict];
            self.prevPageUrl = [self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBasePrevPageUrl fromDictionary:dict];
            self.from = [[self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBaseFrom fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBaseTotal fromDictionary:dict] doubleValue];
            self.path = [self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBasePath fromDictionary:dict];
            self.firstPageUrl = [self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBaseFirstPageUrl fromDictionary:dict];
            self.nextPageUrl = [self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBaseNextPageUrl fromDictionary:dict];
            self.lastPage = [[self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBaseLastPage fromDictionary:dict] doubleValue];
    NSObject *receivedDBHHistoricalInformationForTagModelData = [dict objectForKey:kDBHHistoricalInformationForTagModelDataBaseData];
    NSMutableArray *parsedDBHHistoricalInformationForTagModelData = [NSMutableArray array];
    
    if ([receivedDBHHistoricalInformationForTagModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHHistoricalInformationForTagModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHHistoricalInformationForTagModelData addObject:[DBHHistoricalInformationForTagModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHHistoricalInformationForTagModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHHistoricalInformationForTagModelData addObject:[DBHHistoricalInformationForTagModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHHistoricalInformationForTagModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHHistoricalInformationForTagModelData];
            self.currentPage = [[self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBaseCurrentPage fromDictionary:dict] doubleValue];
            self.perPage = [[self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBasePerPage fromDictionary:dict] doubleValue];
            self.to = [[self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataBaseTo fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lastPageUrl forKey:kDBHHistoricalInformationForTagModelDataBaseLastPageUrl];
    [mutableDict setValue:self.prevPageUrl forKey:kDBHHistoricalInformationForTagModelDataBasePrevPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.from] forKey:kDBHHistoricalInformationForTagModelDataBaseFrom];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kDBHHistoricalInformationForTagModelDataBaseTotal];
    [mutableDict setValue:self.path forKey:kDBHHistoricalInformationForTagModelDataBasePath];
    [mutableDict setValue:self.firstPageUrl forKey:kDBHHistoricalInformationForTagModelDataBaseFirstPageUrl];
    [mutableDict setValue:self.nextPageUrl forKey:kDBHHistoricalInformationForTagModelDataBaseNextPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastPage] forKey:kDBHHistoricalInformationForTagModelDataBaseLastPage];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHHistoricalInformationForTagModelDataBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.currentPage] forKey:kDBHHistoricalInformationForTagModelDataBaseCurrentPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perPage] forKey:kDBHHistoricalInformationForTagModelDataBasePerPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.to] forKey:kDBHHistoricalInformationForTagModelDataBaseTo];

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

    self.lastPageUrl = [aDecoder decodeObjectForKey:kDBHHistoricalInformationForTagModelDataBaseLastPageUrl];
    self.prevPageUrl = [aDecoder decodeObjectForKey:kDBHHistoricalInformationForTagModelDataBasePrevPageUrl];
    self.from = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationForTagModelDataBaseFrom];
    self.total = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationForTagModelDataBaseTotal];
    self.path = [aDecoder decodeObjectForKey:kDBHHistoricalInformationForTagModelDataBasePath];
    self.firstPageUrl = [aDecoder decodeObjectForKey:kDBHHistoricalInformationForTagModelDataBaseFirstPageUrl];
    self.nextPageUrl = [aDecoder decodeObjectForKey:kDBHHistoricalInformationForTagModelDataBaseNextPageUrl];
    self.lastPage = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationForTagModelDataBaseLastPage];
    self.data = [aDecoder decodeObjectForKey:kDBHHistoricalInformationForTagModelDataBaseData];
    self.currentPage = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationForTagModelDataBaseCurrentPage];
    self.perPage = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationForTagModelDataBasePerPage];
    self.to = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationForTagModelDataBaseTo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lastPageUrl forKey:kDBHHistoricalInformationForTagModelDataBaseLastPageUrl];
    [aCoder encodeObject:_prevPageUrl forKey:kDBHHistoricalInformationForTagModelDataBasePrevPageUrl];
    [aCoder encodeDouble:_from forKey:kDBHHistoricalInformationForTagModelDataBaseFrom];
    [aCoder encodeDouble:_total forKey:kDBHHistoricalInformationForTagModelDataBaseTotal];
    [aCoder encodeObject:_path forKey:kDBHHistoricalInformationForTagModelDataBasePath];
    [aCoder encodeObject:_firstPageUrl forKey:kDBHHistoricalInformationForTagModelDataBaseFirstPageUrl];
    [aCoder encodeObject:_nextPageUrl forKey:kDBHHistoricalInformationForTagModelDataBaseNextPageUrl];
    [aCoder encodeDouble:_lastPage forKey:kDBHHistoricalInformationForTagModelDataBaseLastPage];
    [aCoder encodeObject:_data forKey:kDBHHistoricalInformationForTagModelDataBaseData];
    [aCoder encodeDouble:_currentPage forKey:kDBHHistoricalInformationForTagModelDataBaseCurrentPage];
    [aCoder encodeDouble:_perPage forKey:kDBHHistoricalInformationForTagModelDataBasePerPage];
    [aCoder encodeDouble:_to forKey:kDBHHistoricalInformationForTagModelDataBaseTo];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHHistoricalInformationForTagModelDataBase *copy = [[DBHHistoricalInformationForTagModelDataBase alloc] init];
    
    
    
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
