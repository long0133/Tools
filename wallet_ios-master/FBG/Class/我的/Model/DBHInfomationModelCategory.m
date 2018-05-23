//
//  DBHInfomationModelCategory.m
//
//  Created by   on 2018/2/7
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInfomationModelCategory.h"


NSString *const kDBHInfomationModelCategoryId = @"id";
NSString *const kDBHInfomationModelCategoryImg = @"img";
NSString *const kDBHInfomationModelCategoryName = NAME;
NSString *const kDBHInfomationModelCategoryType = @"type";


@interface DBHInfomationModelCategory ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInfomationModelCategory

@synthesize categoryIdentifier = _categoryIdentifier;
@synthesize img = _img;
@synthesize name = _name;
@synthesize type = _type;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.categoryIdentifier = [[self objectOrNilForKey:kDBHInfomationModelCategoryId fromDictionary:dict] doubleValue];
            self.img = [self objectOrNilForKey:kDBHInfomationModelCategoryImg fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInfomationModelCategoryName fromDictionary:dict];
            self.type = [self objectOrNilForKey:kDBHInfomationModelCategoryType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryIdentifier] forKey:kDBHInfomationModelCategoryId];
    [mutableDict setValue:self.img forKey:kDBHInfomationModelCategoryImg];
    [mutableDict setValue:self.name forKey:kDBHInfomationModelCategoryName];
    [mutableDict setValue:self.type forKey:kDBHInfomationModelCategoryType];

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

    self.categoryIdentifier = [aDecoder decodeDoubleForKey:kDBHInfomationModelCategoryId];
    self.img = [aDecoder decodeObjectForKey:kDBHInfomationModelCategoryImg];
    self.name = [aDecoder decodeObjectForKey:kDBHInfomationModelCategoryName];
    self.type = [aDecoder decodeObjectForKey:kDBHInfomationModelCategoryType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_categoryIdentifier forKey:kDBHInfomationModelCategoryId];
    [aCoder encodeObject:_img forKey:kDBHInfomationModelCategoryImg];
    [aCoder encodeObject:_name forKey:kDBHInfomationModelCategoryName];
    [aCoder encodeObject:_type forKey:kDBHInfomationModelCategoryType];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInfomationModelCategory *copy = [[DBHInfomationModelCategory alloc] init];
    
    
    
    if (copy) {

        copy.categoryIdentifier = self.categoryIdentifier;
        copy.img = [self.img copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
    }
    
    return copy;
}


@end
