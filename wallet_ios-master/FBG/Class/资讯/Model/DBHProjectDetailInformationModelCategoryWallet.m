//
//  DBHProjectDetailInformationModelCategoryWallet.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelCategoryWallet.h"


NSString *const kDBHProjectDetailInformationModelCategoryWalletName = NAME;
NSString *const kDBHProjectDetailInformationModelCategoryWalletDesc = @"desc";
NSString *const kDBHProjectDetailInformationModelCategoryWalletUrl = @"url";


@interface DBHProjectDetailInformationModelCategoryWallet ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelCategoryWallet

@synthesize name = _name;
@synthesize desc = _desc;
@synthesize url = _url;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.name = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryWalletName fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryWalletDesc fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryWalletUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kDBHProjectDetailInformationModelCategoryWalletName];
    [mutableDict setValue:self.desc forKey:kDBHProjectDetailInformationModelCategoryWalletDesc];
    [mutableDict setValue:self.url forKey:kDBHProjectDetailInformationModelCategoryWalletUrl];

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

    self.name = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryWalletName];
    self.desc = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryWalletDesc];
    self.url = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryWalletUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kDBHProjectDetailInformationModelCategoryWalletName];
    [aCoder encodeObject:_desc forKey:kDBHProjectDetailInformationModelCategoryWalletDesc];
    [aCoder encodeObject:_url forKey:kDBHProjectDetailInformationModelCategoryWalletUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelCategoryWallet *copy = [[DBHProjectDetailInformationModelCategoryWallet alloc] init];
    
    
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
