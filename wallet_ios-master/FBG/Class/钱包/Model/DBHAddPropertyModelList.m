//
//  DBHAddPropertyModelList.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHAddPropertyModelList.h"


NSString *const kDBHAddPropertyModelListAddress = @"address";
NSString *const kDBHAddPropertyModelListIcon = @"icon";
NSString *const kDBHAddPropertyModelListId = @"id";
NSString *const kDBHAddPropertyModelListCreatedAt = CREATED_AT;
NSString *const kDBHAddPropertyModelListCategoryId = @"category_id";
NSString *const kDBHAddPropertyModelListUpdatedAt = @"updated_at";
NSString *const kDBHAddPropertyModelListGas = @"gas";
NSString *const kDBHAddPropertyModelListName = NAME;


@interface DBHAddPropertyModelList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHAddPropertyModelList

@synthesize address = _address;
@synthesize icon = _icon;
@synthesize listIdentifier = _listIdentifier;
@synthesize createdAt = _createdAt;
@synthesize categoryId = _categoryId;
@synthesize updatedAt = _updatedAt;
@synthesize gas = _gas;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.address = [self objectOrNilForKey:kDBHAddPropertyModelListAddress fromDictionary:dict];
            self.icon = [self objectOrNilForKey:kDBHAddPropertyModelListIcon fromDictionary:dict];
            self.listIdentifier = [[self objectOrNilForKey:kDBHAddPropertyModelListId fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kDBHAddPropertyModelListCreatedAt fromDictionary:dict];
            self.categoryId = [self objectOrNilForKey:kDBHAddPropertyModelListCategoryId fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHAddPropertyModelListUpdatedAt fromDictionary:dict];
            self.gas = [self objectOrNilForKey:kDBHAddPropertyModelListGas fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHAddPropertyModelListName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.address forKey:kDBHAddPropertyModelListAddress];
    [mutableDict setValue:self.icon forKey:kDBHAddPropertyModelListIcon];
    [mutableDict setValue:[NSNumber numberWithDouble:self.listIdentifier] forKey:kDBHAddPropertyModelListId];
    [mutableDict setValue:self.createdAt forKey:kDBHAddPropertyModelListCreatedAt];
    [mutableDict setValue:self.categoryId forKey:kDBHAddPropertyModelListCategoryId];
    [mutableDict setValue:self.updatedAt forKey:kDBHAddPropertyModelListUpdatedAt];
    [mutableDict setValue:self.gas forKey:kDBHAddPropertyModelListGas];
    [mutableDict setValue:self.name forKey:kDBHAddPropertyModelListName];

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

    self.address = [aDecoder decodeObjectForKey:kDBHAddPropertyModelListAddress];
    self.icon = [aDecoder decodeObjectForKey:kDBHAddPropertyModelListIcon];
    self.listIdentifier = [aDecoder decodeDoubleForKey:kDBHAddPropertyModelListId];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHAddPropertyModelListCreatedAt];
    self.categoryId = [aDecoder decodeObjectForKey:kDBHAddPropertyModelListCategoryId];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHAddPropertyModelListUpdatedAt];
    self.gas = [aDecoder decodeObjectForKey:kDBHAddPropertyModelListGas];
    self.name = [aDecoder decodeObjectForKey:kDBHAddPropertyModelListName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_address forKey:kDBHAddPropertyModelListAddress];
    [aCoder encodeObject:_icon forKey:kDBHAddPropertyModelListIcon];
    [aCoder encodeDouble:_listIdentifier forKey:kDBHAddPropertyModelListId];
    [aCoder encodeObject:_createdAt forKey:kDBHAddPropertyModelListCreatedAt];
    [aCoder encodeObject:_categoryId forKey:kDBHAddPropertyModelListCategoryId];
    [aCoder encodeObject:_updatedAt forKey:kDBHAddPropertyModelListUpdatedAt];
    [aCoder encodeObject:_gas forKey:kDBHAddPropertyModelListGas];
    [aCoder encodeObject:_name forKey:kDBHAddPropertyModelListName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHAddPropertyModelList *copy = [[DBHAddPropertyModelList alloc] init];
    
    
    
    if (copy) {

        copy.address = [self.address copyWithZone:zone];
        copy.icon = [self.icon copyWithZone:zone];
        copy.listIdentifier = self.listIdentifier;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.categoryId = [self.categoryId copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.gas = [self.gas copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
