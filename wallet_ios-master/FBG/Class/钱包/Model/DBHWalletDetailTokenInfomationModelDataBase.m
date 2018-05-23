//
//  DBHWalletDetailTokenInfomationModelDataBase.m
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHWalletDetailTokenInfomationModelDataBase.h"
#import "DBHWalletDetailTokenInfomationModelData.h"


NSString *const kDBHWalletDetailTokenInfomationModelDataBaseCode = @"code";
NSString *const kDBHWalletDetailTokenInfomationModelDataBaseData = @"data";
NSString *const kDBHWalletDetailTokenInfomationModelDataBaseMsg = @"msg";
NSString *const kDBHWalletDetailTokenInfomationModelDataBaseUrl = @"url";


@interface DBHWalletDetailTokenInfomationModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHWalletDetailTokenInfomationModelDataBase

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
            self.code = [[self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataBaseCode fromDictionary:dict] doubleValue];
    NSObject *receivedDBHWalletDetailTokenInfomationModelData = [dict objectForKey:kDBHWalletDetailTokenInfomationModelDataBaseData];
    NSMutableArray *parsedDBHWalletDetailTokenInfomationModelData = [NSMutableArray array];
    
    if ([receivedDBHWalletDetailTokenInfomationModelData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHWalletDetailTokenInfomationModelData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHWalletDetailTokenInfomationModelData addObject:[DBHWalletDetailTokenInfomationModelData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHWalletDetailTokenInfomationModelData isKindOfClass:[NSDictionary class]]) {
       [parsedDBHWalletDetailTokenInfomationModelData addObject:[DBHWalletDetailTokenInfomationModelData modelObjectWithDictionary:(NSDictionary *)receivedDBHWalletDetailTokenInfomationModelData]];
    }

    self.data = [NSArray arrayWithArray:parsedDBHWalletDetailTokenInfomationModelData];
            self.msg = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataBaseMsg fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHWalletDetailTokenInfomationModelDataBaseUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kDBHWalletDetailTokenInfomationModelDataBaseCode];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kDBHWalletDetailTokenInfomationModelDataBaseData];
    [mutableDict setValue:self.msg forKey:kDBHWalletDetailTokenInfomationModelDataBaseMsg];
    [mutableDict setValue:self.url forKey:kDBHWalletDetailTokenInfomationModelDataBaseUrl];

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

    self.code = [aDecoder decodeDoubleForKey:kDBHWalletDetailTokenInfomationModelDataBaseCode];
    self.data = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataBaseData];
    self.msg = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataBaseMsg];
    self.url = [aDecoder decodeObjectForKey:kDBHWalletDetailTokenInfomationModelDataBaseUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_code forKey:kDBHWalletDetailTokenInfomationModelDataBaseCode];
    [aCoder encodeObject:_data forKey:kDBHWalletDetailTokenInfomationModelDataBaseData];
    [aCoder encodeObject:_msg forKey:kDBHWalletDetailTokenInfomationModelDataBaseMsg];
    [aCoder encodeObject:_url forKey:kDBHWalletDetailTokenInfomationModelDataBaseUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHWalletDetailTokenInfomationModelDataBase *copy = [[DBHWalletDetailTokenInfomationModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.code = self.code;
        copy.data = [self.data copyWithZone:zone];
        copy.msg = [self.msg copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
