//
//  DBHInformationModelDataBase.m
//
//  Created by   on 2018/1/26
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationModelDataBase.h"
#import "DBHInformationModelData.h"


NSString *const kDBHInformationModelDataBaseLastPageUrl = @"last_page_url";
NSString *const kDBHInformationModelDataBasePrevPageUrl = @"prev_page_url";
NSString *const kDBHInformationModelDataBaseFrom = @"from";
NSString *const kDBHInformationModelDataBaseTotal = @"total";
NSString *const kDBHInformationModelDataBasePath = @"path";
NSString *const kDBHInformationModelDataBaseFirstPageUrl = @"first_page_url";
NSString *const kDBHInformationModelDataBaseNextPageUrl = @"next_page_url";
NSString *const kDBHInformationModelDataBaseLastPage = @"last_page";
NSString *const kDBHInformationModelDataBaseData = @"data";
NSString *const kDBHInformationModelDataBaseCurrentPage = @"current_page";
NSString *const kDBHInformationModelDataBasePerPage = @"per_page";
NSString *const kDBHInformationModelDataBaseTo = @"to";


@interface DBHInformationModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationModelDataBase

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
            self.lastPageUrl = [self objectOrNilForKey:kDBHInformationModelDataBaseLastPageUrl fromDictionary:dict];
            self.prevPageUrl = [self objectOrNilForKey:kDBHInformationModelDataBasePrevPageUrl fromDictionary:dict];
            self.from = [[self objectOrNilForKey:kDBHInformationModelDataBaseFrom fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kDBHInformationModelDataBaseTotal fromDictionary:dict] doubleValue];
            self.path = [self objectOrNilForKey:kDBHInformationModelDataBasePath fromDictionary:dict];
            self.firstPageUrl = [self objectOrNilForKey:kDBHInformationModelDataBaseFirstPageUrl fromDictionary:dict];
            self.nextPageUrl = [self objectOrNilForKey:kDBHInformationModelDataBaseNextPageUrl fromDictionary:dict];
            self.lastPage = [[self objectOrNilForKey:kDBHInformationModelDataBaseLastPage fromDictionary:dict] doubleValue];
    NSObject *receivedDBHInformationModelData = [dict objectForKey:kDBHInformationModelDataBaseData];
    NSMutableArray *parsedDBHInformationModelData = [NSMutableArray array];
    
    if ([receivedDBHInformationModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHInformationModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHInformationModelData addObject:[DBHInformationModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHInformationModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHInformationModelData addObject:[DBHInformationModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHInformationModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHInformationModelData];
            self.currentPage = [[self objectOrNilForKey:kDBHInformationModelDataBaseCurrentPage fromDictionary:dict] doubleValue];
            self.perPage = [[self objectOrNilForKey:kDBHInformationModelDataBasePerPage fromDictionary:dict] doubleValue];
            self.to = [[self objectOrNilForKey:kDBHInformationModelDataBaseTo fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lastPageUrl forKey:kDBHInformationModelDataBaseLastPageUrl];
    [mutableDict setValue:self.prevPageUrl forKey:kDBHInformationModelDataBasePrevPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.from] forKey:kDBHInformationModelDataBaseFrom];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kDBHInformationModelDataBaseTotal];
    [mutableDict setValue:self.path forKey:kDBHInformationModelDataBasePath];
    [mutableDict setValue:self.firstPageUrl forKey:kDBHInformationModelDataBaseFirstPageUrl];
    [mutableDict setValue:self.nextPageUrl forKey:kDBHInformationModelDataBaseNextPageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastPage] forKey:kDBHInformationModelDataBaseLastPage];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHInformationModelDataBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.currentPage] forKey:kDBHInformationModelDataBaseCurrentPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perPage] forKey:kDBHInformationModelDataBasePerPage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.to] forKey:kDBHInformationModelDataBaseTo];

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

    self.lastPageUrl = [aDecoder decodeObjectForKey:kDBHInformationModelDataBaseLastPageUrl];
    self.prevPageUrl = [aDecoder decodeObjectForKey:kDBHInformationModelDataBasePrevPageUrl];
    self.from = [aDecoder decodeDoubleForKey:kDBHInformationModelDataBaseFrom];
    self.total = [aDecoder decodeDoubleForKey:kDBHInformationModelDataBaseTotal];
    self.path = [aDecoder decodeObjectForKey:kDBHInformationModelDataBasePath];
    self.firstPageUrl = [aDecoder decodeObjectForKey:kDBHInformationModelDataBaseFirstPageUrl];
    self.nextPageUrl = [aDecoder decodeObjectForKey:kDBHInformationModelDataBaseNextPageUrl];
    self.lastPage = [aDecoder decodeDoubleForKey:kDBHInformationModelDataBaseLastPage];
    self.data = [aDecoder decodeObjectForKey:kDBHInformationModelDataBaseData];
    self.currentPage = [aDecoder decodeDoubleForKey:kDBHInformationModelDataBaseCurrentPage];
    self.perPage = [aDecoder decodeDoubleForKey:kDBHInformationModelDataBasePerPage];
    self.to = [aDecoder decodeDoubleForKey:kDBHInformationModelDataBaseTo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lastPageUrl forKey:kDBHInformationModelDataBaseLastPageUrl];
    [aCoder encodeObject:_prevPageUrl forKey:kDBHInformationModelDataBasePrevPageUrl];
    [aCoder encodeDouble:_from forKey:kDBHInformationModelDataBaseFrom];
    [aCoder encodeDouble:_total forKey:kDBHInformationModelDataBaseTotal];
    [aCoder encodeObject:_path forKey:kDBHInformationModelDataBasePath];
    [aCoder encodeObject:_firstPageUrl forKey:kDBHInformationModelDataBaseFirstPageUrl];
    [aCoder encodeObject:_nextPageUrl forKey:kDBHInformationModelDataBaseNextPageUrl];
    [aCoder encodeDouble:_lastPage forKey:kDBHInformationModelDataBaseLastPage];
    [aCoder encodeObject:_data forKey:kDBHInformationModelDataBaseData];
    [aCoder encodeDouble:_currentPage forKey:kDBHInformationModelDataBaseCurrentPage];
    [aCoder encodeDouble:_perPage forKey:kDBHInformationModelDataBasePerPage];
    [aCoder encodeDouble:_to forKey:kDBHInformationModelDataBaseTo];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationModelDataBase *copy = [[DBHInformationModelDataBase alloc] init];
    
    
    
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
