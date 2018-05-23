//
//  DBHAddressBookModelWallet.m
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHAddressBookModelWallet.h"
#import "DBHAddressBookModelUser.h"


NSString *const kDBHAddressBookModelWalletAddress = @"address";
NSString *const kDBHAddressBookModelWalletId = @"id";
NSString *const kDBHAddressBookModelWalletDeletedAt = @"deleted_at";
NSString *const kDBHAddressBookModelWalletAddressHash160 = @"address_hash160";
NSString *const kDBHAddressBookModelWalletCreatedAt = CREATED_AT;
NSString *const kDBHAddressBookModelWalletCategoryId = @"category_id";
NSString *const kDBHAddressBookModelWalletUserId = @"user_id";
NSString *const kDBHAddressBookModelWalletUpdatedAt = @"updated_at";
NSString *const kDBHAddressBookModelWalletName = NAME;
NSString *const kDBHAddressBookModelWalletUser = @"user";


@interface DBHAddressBookModelWallet ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHAddressBookModelWallet

@synthesize address = _address;
@synthesize walletIdentifier = _walletIdentifier;
@synthesize deletedAt = _deletedAt;
@synthesize addressHash160 = _addressHash160;
@synthesize createdAt = _createdAt;
@synthesize categoryId = _categoryId;
@synthesize userId = _userId;
@synthesize updatedAt = _updatedAt;
@synthesize name = _name;
@synthesize user = _user;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.address = [self objectOrNilForKey:kDBHAddressBookModelWalletAddress fromDictionary:dict];
            self.walletIdentifier = [[self objectOrNilForKey:kDBHAddressBookModelWalletId fromDictionary:dict] doubleValue];
            self.deletedAt = [self objectOrNilForKey:kDBHAddressBookModelWalletDeletedAt fromDictionary:dict];
            self.addressHash160 = [self objectOrNilForKey:kDBHAddressBookModelWalletAddressHash160 fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHAddressBookModelWalletCreatedAt fromDictionary:dict];
            self.categoryId = [[self objectOrNilForKey:kDBHAddressBookModelWalletCategoryId fromDictionary:dict] doubleValue];
            self.userId = [[self objectOrNilForKey:kDBHAddressBookModelWalletUserId fromDictionary:dict] doubleValue];
            self.updatedAt = [self objectOrNilForKey:kDBHAddressBookModelWalletUpdatedAt fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHAddressBookModelWalletName fromDictionary:dict];
            self.user = [DBHAddressBookModelUser modelObjectWithDictionary:[dict objectForKey:kDBHAddressBookModelWalletUser]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.address forKey:kDBHAddressBookModelWalletAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.walletIdentifier] forKey:kDBHAddressBookModelWalletId];
    [mutableDict setValue:self.deletedAt forKey:kDBHAddressBookModelWalletDeletedAt];
    [mutableDict setValue:self.addressHash160 forKey:kDBHAddressBookModelWalletAddressHash160];
    [mutableDict setValue:self.createdAt forKey:kDBHAddressBookModelWalletCreatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHAddressBookModelWalletCategoryId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHAddressBookModelWalletUserId];
    [mutableDict setValue:self.updatedAt forKey:kDBHAddressBookModelWalletUpdatedAt];
    [mutableDict setValue:self.name forKey:kDBHAddressBookModelWalletName];
    [mutableDict setValue:[self.user dictionaryRepresentation] forKey:kDBHAddressBookModelWalletUser];

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

    self.address = [aDecoder decodeObjectForKey:kDBHAddressBookModelWalletAddress];
    self.walletIdentifier = [aDecoder decodeDoubleForKey:kDBHAddressBookModelWalletId];
    self.deletedAt = [aDecoder decodeObjectForKey:kDBHAddressBookModelWalletDeletedAt];
    self.addressHash160 = [aDecoder decodeObjectForKey:kDBHAddressBookModelWalletAddressHash160];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHAddressBookModelWalletCreatedAt];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHAddressBookModelWalletCategoryId];
    self.userId = [aDecoder decodeDoubleForKey:kDBHAddressBookModelWalletUserId];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHAddressBookModelWalletUpdatedAt];
    self.name = [aDecoder decodeObjectForKey:kDBHAddressBookModelWalletName];
    self.user = [aDecoder decodeObjectForKey:kDBHAddressBookModelWalletUser];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_address forKey:kDBHAddressBookModelWalletAddress];
    [aCoder encodeDouble:_walletIdentifier forKey:kDBHAddressBookModelWalletId];
    [aCoder encodeObject:_deletedAt forKey:kDBHAddressBookModelWalletDeletedAt];
    [aCoder encodeObject:_addressHash160 forKey:kDBHAddressBookModelWalletAddressHash160];
    [aCoder encodeObject:_createdAt forKey:kDBHAddressBookModelWalletCreatedAt];
    [aCoder encodeDouble:_categoryId forKey:kDBHAddressBookModelWalletCategoryId];
    [aCoder encodeDouble:_userId forKey:kDBHAddressBookModelWalletUserId];
    [aCoder encodeObject:_updatedAt forKey:kDBHAddressBookModelWalletUpdatedAt];
    [aCoder encodeObject:_name forKey:kDBHAddressBookModelWalletName];
    [aCoder encodeObject:_user forKey:kDBHAddressBookModelWalletUser];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHAddressBookModelWallet *copy = [[DBHAddressBookModelWallet alloc] init];
    
    
    
    if (copy) {

        copy.address = [self.address copyWithZone:zone];
        copy.walletIdentifier = self.walletIdentifier;
        copy.deletedAt = [self.deletedAt copyWithZone:zone];
        copy.addressHash160 = [self.addressHash160 copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.categoryId = self.categoryId;
        copy.userId = self.userId;
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.user = [self.user copyWithZone:zone];
    }
    
    return copy;
}


@end
