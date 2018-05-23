//
//  DBHCandyBowlModelDataBase.m
//
//  Created by   on 2018/1/31
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHCandyBowlModelDataBase.h"
#import "DBHCandyBowlModelData.h"


NSString *const kDBHCandyBowlModelDataBaseLastPageUrl = @"last_page_url";
NSString *const kDBHCandyBowlModelDataBasePrevPageUrl = @"prev_page_url";
NSString *const kDBHCandyBowlModelDataBaseFrom = @"from";
NSString *const kDBHCandyBowlModelDataBaseTotal = @"total";
NSString *const kDBHCandyBowlModelDataBasePath = @"path";
NSString *const kDBHCandyBowlModelDataBaseFirstPageUrl = @"first_page_url";
NSString *const kDBHCandyBowlModelDataBaseNextPageUrl = @"next_page_url";
NSString *const kDBHCandyBowlModelDataBaseLastPage = @"last_page";
NSString *const kDBHCandyBowlModelDataBaseData = @"data";
NSString *const kDBHCandyBowlModelDataBaseCurrentPage = @"current_page";
NSString *const kDBHCandyBowlModelDataBasePerPage = @"per_page";
NSString *const kDBHCandyBowlModelDataBaseTo = @"to";


@interface DBHCandyBowlModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHCandyBowlModelDataBase

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
            self.lastPageUrl = [self objectOrNilForKey:kDBHCandyBowlModelDataBaseLastPageUrl fromDictionary:dict];
            self.prevPageUrl = [self objectOrNilForKey:kDBHCandyBowlModelDataBasePrevPageUrl fromDictionary:dict];
            self.from = [[self objectOrNilForKey:kDBHCandyBowlModelDataBaseFrom fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kDBHCandyBowlModelDataBaseTotal fromDictionary:dict] doubleValue];
            self.path = [self objectOrNilForKey:kDBHCandyBowlModelDataBasePath fromDictionary:dict];
            self.firstPageUrl = [self objectOrNilForKey:kDBHCandyBowlModelDataBaseFirstPageUrl fromDictionary:dict];
            self.nextPageUrl = [self objectOrNilForKey:kDBHCandyBowlModelDataBaseNextPageUrl fromDictionary:dict];
            self.lastPage = [[self objectOrNilForKey:kDBHCandyBowlModelDataBaseLastPage fromDictionary:dict] doubleValue];
    NSObject *receivedDBHCandyBowlModelData = [dict objectForKey:kDBHCandyBowlModelDataBaseData];
    NSMutableArray *parsedDBHCandyBowlModelData = [NSMutableArray array];
    
    if ([receivedDBHCandyBowlModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHCandyBowlModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHCandyBowlModelData addObject:[DBHCandyBowlModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHCandyBowlModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHCandyBowlModelData addObject:[DBHCandyBowlModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHCandyBowlModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHCandyBowlModelData];
            self.currentPage = [[self objectOrNilForKey:kDBHCandyBowlModelDataBaseCurrentPage fromDictionary:dict] doubleValue];
            self.perPage = [[self objectOrNilForKey:kDBHCandyBowlModelDataBasePerPage fromDictionary:dict] doubleValue];
            self.to = [[self objectOrNilForKey:kDBHCandyBowlModelDataBaseTo fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lastPageUrl forKey:kDBHCandyBowlModelDataBaseLastPageUrl];
    [mutableDict setValue:self.prevPageUrl forKey:kDBHCandyBowlModelDataBasePrevPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.from] forKey:kDBHCandyBowlModelDataBaseFrom];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kDBHCandyBowlModelDataBaseTotal];
    [mutableDict setValue:self.path forKey:kDBHCandyBowlModelDataBasePath];
    [mutableDict setValue:self.firstPageUrl forKey:kDBHCandyBowlModelDataBaseFirstPageUrl];
    [mutableDict setValue:self.nextPageUrl forKey:kDBHCandyBowlModelDataBaseNextPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastPage] forKey:kDBHCandyBowlModelDataBaseLastPage];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHCandyBowlModelDataBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.currentPage] forKey:kDBHCandyBowlModelDataBaseCurrentPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perPage] forKey:kDBHCandyBowlModelDataBasePerPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.to] forKey:kDBHCandyBowlModelDataBaseTo];

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

    self.lastPageUrl = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataBaseLastPageUrl];
    self.prevPageUrl = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataBasePrevPageUrl];
    self.from = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataBaseFrom];
    self.total = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataBaseTotal];
    self.path = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataBasePath];
    self.firstPageUrl = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataBaseFirstPageUrl];
    self.nextPageUrl = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataBaseNextPageUrl];
    self.lastPage = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataBaseLastPage];
    self.data = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataBaseData];
    self.currentPage = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataBaseCurrentPage];
    self.perPage = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataBasePerPage];
    self.to = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataBaseTo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lastPageUrl forKey:kDBHCandyBowlModelDataBaseLastPageUrl];
    [aCoder encodeObject:_prevPageUrl forKey:kDBHCandyBowlModelDataBasePrevPageUrl];
    [aCoder encodeDouble:_from forKey:kDBHCandyBowlModelDataBaseFrom];
    [aCoder encodeDouble:_total forKey:kDBHCandyBowlModelDataBaseTotal];
    [aCoder encodeObject:_path forKey:kDBHCandyBowlModelDataBasePath];
    [aCoder encodeObject:_firstPageUrl forKey:kDBHCandyBowlModelDataBaseFirstPageUrl];
    [aCoder encodeObject:_nextPageUrl forKey:kDBHCandyBowlModelDataBaseNextPageUrl];
    [aCoder encodeDouble:_lastPage forKey:kDBHCandyBowlModelDataBaseLastPage];
    [aCoder encodeObject:_data forKey:kDBHCandyBowlModelDataBaseData];
    [aCoder encodeDouble:_currentPage forKey:kDBHCandyBowlModelDataBaseCurrentPage];
    [aCoder encodeDouble:_perPage forKey:kDBHCandyBowlModelDataBasePerPage];
    [aCoder encodeDouble:_to forKey:kDBHCandyBowlModelDataBaseTo];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHCandyBowlModelDataBase *copy = [[DBHCandyBowlModelDataBase alloc] init];
    
    
    
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
