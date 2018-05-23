//
//  DBHTransferListModelDataBase.m
//
//  Created by   on 2018/1/10
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHTransferListModelDataBase.h"
#import "DBHTransferListModelData.h"


NSString *const kDBHTransferListModelDataBaseCode = @"code";
NSString *const kDBHTransferListModelDataBaseData = @"data";
NSString *const kDBHTransferListModelDataBaseMsg = @"msg";
NSString *const kDBHTransferListModelDataBaseUrl = @"url";


@interface DBHTransferListModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHTransferListModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHTransferListModelDataBaseCode fromDictionary:dict] doubleValue];
            self.data = [DBHTransferListModelData modelObjectWithDictionary:[dict objectForKey:kDBHTransferListModelDataBaseData]];
            self.msg = [self objectOrNilForKey:kDBHTransferListModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHTransferListModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHTransferListModelDataBaseCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kDBHTransferListModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHTransferListModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHTransferListModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHTransferListModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHTransferListModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHTransferListModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHTransferListModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHTransferListModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHTransferListModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHTransferListModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHTransferListModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHTransferListModelDataBase *copy = [[DBHTransferListModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
