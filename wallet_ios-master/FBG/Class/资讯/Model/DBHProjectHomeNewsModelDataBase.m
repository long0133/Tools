//
//  DBHProjectHomeNewsModelDataBase.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectHomeNewsModelDataBase.h"
#import "DBHProjectHomeNewsModelData.h"


NSString *const kDBHProjectHomeNewsModelDataBaseLastPageUrl = @"last_page_url";
NSString *const kDBHProjectHomeNewsModelDataBasePrevPageUrl = @"prev_page_url";
NSString *const kDBHProjectHomeNewsModelDataBaseFrom = @"from";
NSString *const kDBHProjectHomeNewsModelDataBaseTotal = @"total";
NSString *const kDBHProjectHomeNewsModelDataBasePath = @"path";
NSString *const kDBHProjectHomeNewsModelDataBaseFirstPageUrl = @"first_page_url";
NSString *const kDBHProjectHomeNewsModelDataBaseNextPageUrl = @"next_page_url";
NSString *const kDBHProjectHomeNewsModelDataBaseLastPage = @"last_page";
NSString *const kDBHProjectHomeNewsModelDataBaseData = @"data";
NSString *const kDBHProjectHomeNewsModelDataBaseCurrentPage = @"current_page";
NSString *const kDBHProjectHomeNewsModelDataBasePerPage = @"per_page";
NSString *const kDBHProjectHomeNewsModelDataBaseTo = @"to";


@interface DBHProjectHomeNewsModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectHomeNewsModelDataBase

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
            self.lastPageUrl = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataBaseLastPageUrl fromDictionary:dict];
            self.prevPageUrl = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataBasePrevPageUrl fromDictionary:dict];
            self.from = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataBaseFrom fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataBaseTotal fromDictionary:dict] doubleValue];
            self.path = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataBasePath fromDictionary:dict];
            self.firstPageUrl = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataBaseFirstPageUrl fromDictionary:dict];
            self.nextPageUrl = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataBaseNextPageUrl fromDictionary:dict];
            self.lastPage = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataBaseLastPage fromDictionary:dict] doubleValue];
    NSObject *receivedDBHProjectHomeNewsModelData = [dict objectForKey:kDBHProjectHomeNewsModelDataBaseData];
    NSMutableArray *parsedDBHProjectHomeNewsModelData = [NSMutableArray array];
    
    if ([receivedDBHProjectHomeNewsModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHProjectHomeNewsModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHProjectHomeNewsModelData addObject:[DBHProjectHomeNewsModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHProjectHomeNewsModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHProjectHomeNewsModelData addObject:[DBHProjectHomeNewsModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHProjectHomeNewsModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHProjectHomeNewsModelData];
            self.currentPage = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataBaseCurrentPage fromDictionary:dict] doubleValue];
            self.perPage = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataBasePerPage fromDictionary:dict] doubleValue];
            self.to = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataBaseTo fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lastPageUrl forKey:kDBHProjectHomeNewsModelDataBaseLastPageUrl];
    [mutableDict setValue:self.prevPageUrl forKey:kDBHProjectHomeNewsModelDataBasePrevPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.from] forKey:kDBHProjectHomeNewsModelDataBaseFrom];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kDBHProjectHomeNewsModelDataBaseTotal];
    [mutableDict setValue:self.path forKey:kDBHProjectHomeNewsModelDataBasePath];
    [mutableDict setValue:self.firstPageUrl forKey:kDBHProjectHomeNewsModelDataBaseFirstPageUrl];
    [mutableDict setValue:self.nextPageUrl forKey:kDBHProjectHomeNewsModelDataBaseNextPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastPage] forKey:kDBHProjectHomeNewsModelDataBaseLastPage];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHProjectHomeNewsModelDataBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.currentPage] forKey:kDBHProjectHomeNewsModelDataBaseCurrentPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perPage] forKey:kDBHProjectHomeNewsModelDataBasePerPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.to] forKey:kDBHProjectHomeNewsModelDataBaseTo];

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

    self.lastPageUrl = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataBaseLastPageUrl];
    self.prevPageUrl = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataBasePrevPageUrl];
    self.from = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataBaseFrom];
    self.total = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataBaseTotal];
    self.path = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataBasePath];
    self.firstPageUrl = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataBaseFirstPageUrl];
    self.nextPageUrl = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataBaseNextPageUrl];
    self.lastPage = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataBaseLastPage];
    self.data = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataBaseData];
    self.currentPage = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataBaseCurrentPage];
    self.perPage = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataBasePerPage];
    self.to = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataBaseTo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lastPageUrl forKey:kDBHProjectHomeNewsModelDataBaseLastPageUrl];
    [aCoder encodeObject:_prevPageUrl forKey:kDBHProjectHomeNewsModelDataBasePrevPageUrl];
    [aCoder encodeDouble:_from forKey:kDBHProjectHomeNewsModelDataBaseFrom];
    [aCoder encodeDouble:_total forKey:kDBHProjectHomeNewsModelDataBaseTotal];
    [aCoder encodeObject:_path forKey:kDBHProjectHomeNewsModelDataBasePath];
    [aCoder encodeObject:_firstPageUrl forKey:kDBHProjectHomeNewsModelDataBaseFirstPageUrl];
    [aCoder encodeObject:_nextPageUrl forKey:kDBHProjectHomeNewsModelDataBaseNextPageUrl];
    [aCoder encodeDouble:_lastPage forKey:kDBHProjectHomeNewsModelDataBaseLastPage];
    [aCoder encodeObject:_data forKey:kDBHProjectHomeNewsModelDataBaseData];
    [aCoder encodeDouble:_currentPage forKey:kDBHProjectHomeNewsModelDataBaseCurrentPage];
    [aCoder encodeDouble:_perPage forKey:kDBHProjectHomeNewsModelDataBasePerPage];
    [aCoder encodeDouble:_to forKey:kDBHProjectHomeNewsModelDataBaseTo];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectHomeNewsModelDataBase *copy = [[DBHProjectHomeNewsModelDataBase alloc] init];
    
    
    
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
