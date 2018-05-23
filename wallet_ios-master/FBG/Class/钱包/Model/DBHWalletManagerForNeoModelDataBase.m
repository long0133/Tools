//
//  DBHWalletManagerForNeoModelDataBase.m
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHWalletManagerForNeoModelDataBase.h"
#import "DBHWalletManagerForNeoModelData.h"


NSString *const kDBHWalletManagerForNeoModelDataBaseCode = @"code";
NSString *const kDBHWalletManagerForNeoModelDataBaseData = @"data";
NSString *const kDBHWalletManagerForNeoModelDataBaseMsg = @"msg";
NSString *const kDBHWalletManagerForNeoModelDataBaseUrl = @"url";


@interface DBHWalletManagerForNeoModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHWalletManagerForNeoModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHWalletManagerForNeoModelDataBaseCode fromDictionary:dict] doubleValue];
            self.data = [DBHWalletManagerForNeoModelData modelObjectWithDictionary:[dict objectForKey:kDBHWalletManagerForNeoModelDataBaseData]];
            self.msg = [self objectOrNilForKey:kDBHWalletManagerForNeoModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHWalletManagerForNeoModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHWalletManagerForNeoModelDataBaseCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kDBHWalletManagerForNeoModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHWalletManagerForNeoModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHWalletManagerForNeoModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHWalletManagerForNeoModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHWalletManagerForNeoModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHWalletManagerForNeoModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHWalletManagerForNeoModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHWalletManagerForNeoModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHWalletManagerForNeoModelDataBase *copy = [[DBHWalletManagerForNeoModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
