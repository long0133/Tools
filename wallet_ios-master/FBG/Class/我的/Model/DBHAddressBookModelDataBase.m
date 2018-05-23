//
//  DBHAddressBookModelDataBase.m
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHAddressBookModelDataBase.h"
#import "DBHAddressBookModelData.h"


NSString *const kDBHAddressBookModelDataBaseCode = @"code";
NSString *const kDBHAddressBookModelDataBaseData = @"data";
NSString *const kDBHAddressBookModelDataBaseMsg = @"msg";
NSString *const kDBHAddressBookModelDataBaseUrl = @"url";


@interface DBHAddressBookModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHAddressBookModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHAddressBookModelDataBaseCode fromDictionary:dict] doubleValue];
            self.data = [DBHAddressBookModelData modelObjectWithDictionary:[dict objectForKey:kDBHAddressBookModelDataBaseData]];
            self.msg = [self objectOrNilForKey:kDBHAddressBookModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHAddressBookModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHAddressBookModelDataBaseCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kDBHAddressBookModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHAddressBookModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHAddressBookModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHAddressBookModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHAddressBookModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHAddressBookModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHAddressBookModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHAddressBookModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHAddressBookModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHAddressBookModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHAddressBookModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHAddressBookModelDataBase *copy = [[DBHAddressBookModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
