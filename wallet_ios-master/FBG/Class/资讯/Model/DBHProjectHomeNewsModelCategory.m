//
//  DBHProjectHomeNewsModelCategory.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectHomeNewsModelCategory.h"


NSString *const kDBHProjectHomeNewsModelCategoryId = @"id";
NSString *const kDBHProjectHomeNewsModelCategoryImg = @"img";
NSString *const kDBHProjectHomeNewsModelCategoryName = NAME;
NSString *const kDBHProjectHomeNewsModelCategoryType = @"type";


@interface DBHProjectHomeNewsModelCategory ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectHomeNewsModelCategory

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
            self.categoryIdentifier = [[self objectOrNilForKey:kDBHProjectHomeNewsModelCategoryId fromDictionary:dict] doubleValue];
            self.img = [self objectOrNilForKey:kDBHProjectHomeNewsModelCategoryImg fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHProjectHomeNewsModelCategoryName fromDictionary:dict];
            self.type = [self objectOrNilForKey:kDBHProjectHomeNewsModelCategoryType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryIdentifier] forKey:kDBHProjectHomeNewsModelCategoryId];
    [mutableDict setValue:self.img forKey:kDBHProjectHomeNewsModelCategoryImg];
    [mutableDict setValue:self.name forKey:kDBHProjectHomeNewsModelCategoryName];
    [mutableDict setValue:self.type forKey:kDBHProjectHomeNewsModelCategoryType];

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

    self.categoryIdentifier = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelCategoryId];
    self.img = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelCategoryImg];
    self.name = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelCategoryName];
    self.type = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelCategoryType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_categoryIdentifier forKey:kDBHProjectHomeNewsModelCategoryId];
    [aCoder encodeObject:_img forKey:kDBHProjectHomeNewsModelCategoryImg];
    [aCoder encodeObject:_name forKey:kDBHProjectHomeNewsModelCategoryName];
    [aCoder encodeObject:_type forKey:kDBHProjectHomeNewsModelCategoryType];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectHomeNewsModelCategory *copy = [[DBHProjectHomeNewsModelCategory alloc] init];
    
    
    
    if (copy) {

        copy.categoryIdentifier = self.categoryIdentifier;
        copy.img = [self.img copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
    }
    
    return copy;
}


@end
