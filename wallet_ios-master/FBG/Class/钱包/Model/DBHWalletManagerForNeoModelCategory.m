//
//  DBHWalletManagerForNeoModelCategory.m
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHWalletManagerForNeoModelCategory.h"


NSString *const kDBHWalletManagerForNeoModelCategoryId = @"id";
NSString *const kDBHWalletManagerForNeoModelCategoryName = NAME;


@interface DBHWalletManagerForNeoModelCategory ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHWalletManagerForNeoModelCategory

@synthesize categoryIdentifier = _categoryIdentifier;
@synthesize name = _name;


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"categoryIdentifier" : @"id"
             };
}

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.categoryIdentifier = [[self objectOrNilForKey:kDBHWalletManagerForNeoModelCategoryId fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kDBHWalletManagerForNeoModelCategoryName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryIdentifier] forKey:kDBHWalletManagerForNeoModelCategoryId];
    [mutableDict setValue:self.name forKey:kDBHWalletManagerForNeoModelCategoryName];

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

    self.categoryIdentifier = [aDecoder decodeDoubleForKey:kDBHWalletManagerForNeoModelCategoryId];
    self.name = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelCategoryName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_categoryIdentifier forKey:kDBHWalletManagerForNeoModelCategoryId];
    [aCoder encodeObject:_name forKey:kDBHWalletManagerForNeoModelCategoryName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHWalletManagerForNeoModelCategory *copy = [[DBHWalletManagerForNeoModelCategory alloc] init];
    
    
    
    if (copy) {

        copy.categoryIdentifier = self.categoryIdentifier;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
