//
//  DBHInfomationModelDataBase.m
//
//  Created by   on 2018/2/7
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInfomationModelDataBase.h"
#import "DBHInfomationModelData.h"


NSString *const kDBHInfomationModelDataBaseLastPageUrl = @"last_page_url";
NSString *const kDBHInfomationModelDataBasePrevPageUrl = @"prev_page_url";
NSString *const kDBHInfomationModelDataBaseFrom = @"from";
NSString *const kDBHInfomationModelDataBaseTotal = @"total";
NSString *const kDBHInfomationModelDataBasePath = @"path";
NSString *const kDBHInfomationModelDataBaseFirstPageUrl = @"first_page_url";
NSString *const kDBHInfomationModelDataBaseNextPageUrl = @"next_page_url";
NSString *const kDBHInfomationModelDataBaseLastPage = @"last_page";
NSString *const kDBHInfomationModelDataBaseData = @"data";
NSString *const kDBHInfomationModelDataBaseCurrentPage = @"current_page";
NSString *const kDBHInfomationModelDataBasePerPage = @"per_page";
NSString *const kDBHInfomationModelDataBaseTo = @"to";


@interface DBHInfomationModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInfomationModelDataBase

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
            self.lastPageUrl = [self objectOrNilForKey:kDBHInfomationModelDataBaseLastPageUrl fromDictionary:dict];
            self.prevPageUrl = [self objectOrNilForKey:kDBHInfomationModelDataBasePrevPageUrl fromDictionary:dict];
            self.from = [[self objectOrNilForKey:kDBHInfomationModelDataBaseFrom fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kDBHInfomationModelDataBaseTotal fromDictionary:dict] doubleValue];
            self.path = [self objectOrNilForKey:kDBHInfomationModelDataBasePath fromDictionary:dict];
            self.firstPageUrl = [self objectOrNilForKey:kDBHInfomationModelDataBaseFirstPageUrl fromDictionary:dict];
            self.nextPageUrl = [self objectOrNilForKey:kDBHInfomationModelDataBaseNextPageUrl fromDictionary:dict];
            self.lastPage = [[self objectOrNilForKey:kDBHInfomationModelDataBaseLastPage fromDictionary:dict] doubleValue];
    NSObject *receivedDBHInfomationModelData = [dict objectForKey:kDBHInfomationModelDataBaseData];
    NSMutableArray *parsedDBHInfomationModelData = [NSMutableArray array];
    
    if ([receivedDBHInfomationModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInfomationModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInfomationModelData addObject:[DBHInfomationModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInfomationModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInfomationModelData addObject:[DBHInfomationModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHInfomationModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHInfomationModelData];
            self.currentPage = [[self objectOrNilForKey:kDBHInfomationModelDataBaseCurrentPage fromDictionary:dict] doubleValue];
            self.perPage = [[self objectOrNilForKey:kDBHInfomationModelDataBasePerPage fromDictionary:dict] doubleValue];
            self.to = [[self objectOrNilForKey:kDBHInfomationModelDataBaseTo fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lastPageUrl forKey:kDBHInfomationModelDataBaseLastPageUrl];
    [mutableDict setValue:self.prevPageUrl forKey:kDBHInfomationModelDataBasePrevPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.from] forKey:kDBHInfomationModelDataBaseFrom];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kDBHInfomationModelDataBaseTotal];
    [mutableDict setValue:self.path forKey:kDBHInfomationModelDataBasePath];
    [mutableDict setValue:self.firstPageUrl forKey:kDBHInfomationModelDataBaseFirstPageUrl];
    [mutableDict setValue:self.nextPageUrl forKey:kDBHInfomationModelDataBaseNextPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastPage] forKey:kDBHInfomationModelDataBaseLastPage];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHInfomationModelDataBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.currentPage] forKey:kDBHInfomationModelDataBaseCurrentPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perPage] forKey:kDBHInfomationModelDataBasePerPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.to] forKey:kDBHInfomationModelDataBaseTo];

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

    self.lastPageUrl = [aDecoder decodeObjectForKey:kDBHInfomationModelDataBaseLastPageUrl];
    self.prevPageUrl = [aDecoder decodeObjectForKey:kDBHInfomationModelDataBasePrevPageUrl];
    self.from = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataBaseFrom];
    self.total = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataBaseTotal];
    self.path = [aDecoder decodeObjectForKey:kDBHInfomationModelDataBasePath];
    self.firstPageUrl = [aDecoder decodeObjectForKey:kDBHInfomationModelDataBaseFirstPageUrl];
    self.nextPageUrl = [aDecoder decodeObjectForKey:kDBHInfomationModelDataBaseNextPageUrl];
    self.lastPage = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataBaseLastPage];
    self.data = [aDecoder decodeObjectForKey:kDBHInfomationModelDataBaseData];
    self.currentPage = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataBaseCurrentPage];
    self.perPage = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataBasePerPage];
    self.to = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataBaseTo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lastPageUrl forKey:kDBHInfomationModelDataBaseLastPageUrl];
    [aCoder encodeObject:_prevPageUrl forKey:kDBHInfomationModelDataBasePrevPageUrl];
    [aCoder encodeDouble:_from forKey:kDBHInfomationModelDataBaseFrom];
    [aCoder encodeDouble:_total forKey:kDBHInfomationModelDataBaseTotal];
    [aCoder encodeObject:_path forKey:kDBHInfomationModelDataBasePath];
    [aCoder encodeObject:_firstPageUrl forKey:kDBHInfomationModelDataBaseFirstPageUrl];
    [aCoder encodeObject:_nextPageUrl forKey:kDBHInfomationModelDataBaseNextPageUrl];
    [aCoder encodeDouble:_lastPage forKey:kDBHInfomationModelDataBaseLastPage];
    [aCoder encodeObject:_data forKey:kDBHInfomationModelDataBaseData];
    [aCoder encodeDouble:_currentPage forKey:kDBHInfomationModelDataBaseCurrentPage];
    [aCoder encodeDouble:_perPage forKey:kDBHInfomationModelDataBasePerPage];
    [aCoder encodeDouble:_to forKey:kDBHInfomationModelDataBaseTo];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInfomationModelDataBase *copy = [[DBHInfomationModelDataBase alloc] init];
    
    
    
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
