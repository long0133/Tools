//
//  DBHProjectDetailInformationModelDataBase.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelDataBase.h"
#import "DBHProjectDetailInformationModelData.h"


NSString *const kDBHProjectDetailInformationModelDataBaseCode = @"code";
NSString *const kDBHProjectDetailInformationModelDataBaseData = @"data";
NSString *const kDBHProjectDetailInformationModelDataBaseMsg = @"msg";
NSString *const kDBHProjectDetailInformationModelDataBaseUrl = @"url";


@interface DBHProjectDetailInformationModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHProjectDetailInformationModelDataBaseCode fromDictionary:dict] doubleValue];
            self.data = [DBHProjectDetailInformationModelData modelObjectWithDictionary:[dict objectForKey:kDBHProjectDetailInformationModelDataBaseData]];
            self.msg = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHProjectDetailInformationModelDataBaseCode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kDBHProjectDetailInformationModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHProjectDetailInformationModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHProjectDetailInformationModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHProjectDetailInformationModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHProjectDetailInformationModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHProjectDetailInformationModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHProjectDetailInformationModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelDataBase *copy = [[DBHProjectDetailInformationModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
