//
//  DBHHistoricalInformationModelCategory.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHHistoricalInformationModelCategory.h"


NSString *const kDBHHistoricalInformationModelCategoryId = @"id";
NSString *const kDBHHistoricalInformationModelCategoryImg = @"img";
NSString *const kDBHHistoricalInformationModelCategoryName = NAME;
NSString *const kDBHHistoricalInformationModelCategoryType = @"type";


@interface DBHHistoricalInformationModelCategory ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHHistoricalInformationModelCategory

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
            self.categoryIdentifier = [[self objectOrNilForKey:kDBHHistoricalInformationModelCategoryId fromDictionary:dict] doubleValue];
            self.img = [self objectOrNilForKey:kDBHHistoricalInformationModelCategoryImg fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHHistoricalInformationModelCategoryName fromDictionary:dict];
            self.type = [self objectOrNilForKey:kDBHHistoricalInformationModelCategoryType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryIdentifier] forKey:kDBHHistoricalInformationModelCategoryId];
    [mutableDict setValue:self.img forKey:kDBHHistoricalInformationModelCategoryImg];
    [mutableDict setValue:self.name forKey:kDBHHistoricalInformationModelCategoryName];
    [mutableDict setValue:self.type forKey:kDBHHistoricalInformationModelCategoryType];

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

    self.categoryIdentifier = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelCategoryId];
    self.img = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelCategoryImg];
    self.name = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelCategoryName];
    self.type = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelCategoryType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_categoryIdentifier forKey:kDBHHistoricalInformationModelCategoryId];
    [aCoder encodeObject:_img forKey:kDBHHistoricalInformationModelCategoryImg];
    [aCoder encodeObject:_name forKey:kDBHHistoricalInformationModelCategoryName];
    [aCoder encodeObject:_type forKey:kDBHHistoricalInformationModelCategoryType];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHHistoricalInformationModelCategory *copy = [[DBHHistoricalInformationModelCategory alloc] init];
    
    
    
    if (copy) {

        copy.categoryIdentifier = self.categoryIdentifier;
        copy.img = [self.img copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
    }
    
    return copy;
}


@end
