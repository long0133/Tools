//
//  DBHAddressBookModelList.m
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHAddressBookModelList.h"
#import "DBHAddressBookModelWallet.h"


NSString *const kDBHAddressBookModelListRemark = REMARK;
NSString *const kDBHAddressBookModelListWallet = @"wallet";
NSString *const kDBHAddressBookModelListAddress = @"address";
NSString *const kDBHAddressBookModelListId = @"id";
NSString *const kDBHAddressBookModelListCreatedAt = CREATED_AT;
NSString *const kDBHAddressBookModelListCategoryId = @"category_id";
NSString *const kDBHAddressBookModelListUserId = @"user_id";
NSString *const kDBHAddressBookModelListUpdatedAt = @"updated_at";
NSString *const kDBHAddressBookModelListName = NAME;


@interface DBHAddressBookModelList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHAddressBookModelList

@synthesize remark = _remark;
@synthesize wallet = _wallet;
@synthesize address = _address;
@synthesize listIdentifier = _listIdentifier;
@synthesize createdAt = _createdAt;
@synthesize categoryId = _categoryId;
@synthesize userId = _userId;
@synthesize updatedAt = _updatedAt;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.remark = [self objectOrNilForKey:kDBHAddressBookModelListRemark fromDictionary:dict];
            self.wallet = [DBHAddressBookModelWallet modelObjectWithDictionary:[dict objectForKey:kDBHAddressBookModelListWallet]];
            self.address = [self objectOrNilForKey:kDBHAddressBookModelListAddress fromDictionary:dict];
            self.listIdentifier = [[self objectOrNilForKey:kDBHAddressBookModelListId fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kDBHAddressBookModelListCreatedAt fromDictionary:dict];
            self.categoryId = [[self objectOrNilForKey:kDBHAddressBookModelListCategoryId fromDictionary:dict] doubleValue];
            self.userId = [[self objectOrNilForKey:kDBHAddressBookModelListUserId fromDictionary:dict] doubleValue];
            self.updatedAt = [self objectOrNilForKey:kDBHAddressBookModelListUpdatedAt fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHAddressBookModelListName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.remark forKey:kDBHAddressBookModelListRemark];
    [mutableDict setValue:[self.wallet dictionaryRepresentation] forKey:kDBHAddressBookModelListWallet];
    [mutableDict setValue:self.address forKey:kDBHAddressBookModelListAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.listIdentifier] forKey:kDBHAddressBookModelListId];
    [mutableDict setValue:self.createdAt forKey:kDBHAddressBookModelListCreatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHAddressBookModelListCategoryId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHAddressBookModelListUserId];
    [mutableDict setValue:self.updatedAt forKey:kDBHAddressBookModelListUpdatedAt];
    [mutableDict setValue:self.name forKey:kDBHAddressBookModelListName];

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

    self.remark = [aDecoder decodeObjectForKey:kDBHAddressBookModelListRemark];
    self.wallet = [aDecoder decodeObjectForKey:kDBHAddressBookModelListWallet];
    self.address = [aDecoder decodeObjectForKey:kDBHAddressBookModelListAddress];
    self.listIdentifier = [aDecoder decodeDoubleForKey:kDBHAddressBookModelListId];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHAddressBookModelListCreatedAt];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHAddressBookModelListCategoryId];
    self.userId = [aDecoder decodeDoubleForKey:kDBHAddressBookModelListUserId];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHAddressBookModelListUpdatedAt];
    self.name = [aDecoder decodeObjectForKey:kDBHAddressBookModelListName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_remark forKey:kDBHAddressBookModelListRemark];
    [aCoder encodeObject:_wallet forKey:kDBHAddressBookModelListWallet];
    [aCoder encodeObject:_address forKey:kDBHAddressBookModelListAddress];
    [aCoder encodeDouble:_listIdentifier forKey:kDBHAddressBookModelListId];
    [aCoder encodeObject:_createdAt forKey:kDBHAddressBookModelListCreatedAt];
    [aCoder encodeDouble:_categoryId forKey:kDBHAddressBookModelListCategoryId];
    [aCoder encodeDouble:_userId forKey:kDBHAddressBookModelListUserId];
    [aCoder encodeObject:_updatedAt forKey:kDBHAddressBookModelListUpdatedAt];
    [aCoder encodeObject:_name forKey:kDBHAddressBookModelListName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHAddressBookModelList *copy = [[DBHAddressBookModelList alloc] init];
    
    
    
    if (copy) {

        copy.remark = [self.remark copyWithZone:zone];
        copy.wallet = [self.wallet copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.listIdentifier = self.listIdentifier;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.categoryId = self.categoryId;
        copy.userId = self.userId;
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
