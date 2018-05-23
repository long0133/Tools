//
//  DBHProjectDetailInformationModelCategoryStructure.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelCategoryStructure.h"


NSString *const kDBHProjectDetailInformationModelCategoryStructurePercentage = @"percentage";
NSString *const kDBHProjectDetailInformationModelCategoryStructureColorValue = @"color_value";
NSString *const kDBHProjectDetailInformationModelCategoryStructureLang = @"lang";
NSString *const kDBHProjectDetailInformationModelCategoryStructureColorName = @"color_name";
NSString *const kDBHProjectDetailInformationModelCategoryStructureDesc = @"desc";


@interface DBHProjectDetailInformationModelCategoryStructure ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelCategoryStructure

@synthesize percentage = _percentage;
@synthesize colorValue = _colorValue;
@synthesize lang = _lang;
@synthesize colorName = _colorName;
@synthesize desc = _desc;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.percentage = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryStructurePercentage fromDictionary:dict] doubleValue];
            self.colorValue = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryStructureColorValue fromDictionary:dict];
            self.lang = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryStructureLang fromDictionary:dict];
            self.colorName = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryStructureColorName fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryStructureDesc fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.percentage] forKey:kDBHProjectDetailInformationModelCategoryStructurePercentage];
    [mutableDict setValue:self.colorValue forKey:kDBHProjectDetailInformationModelCategoryStructureColorValue];
    [mutableDict setValue:self.lang forKey:kDBHProjectDetailInformationModelCategoryStructureLang];
    [mutableDict setValue:self.colorName forKey:kDBHProjectDetailInformationModelCategoryStructureColorName];
    [mutableDict setValue:self.desc forKey:kDBHProjectDetailInformationModelCategoryStructureDesc];

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

    self.percentage = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelCategoryStructurePercentage];
    self.colorValue = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryStructureColorValue];
    self.lang = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryStructureLang];
    self.colorName = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryStructureColorName];
    self.desc = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryStructureDesc];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_percentage forKey:kDBHProjectDetailInformationModelCategoryStructurePercentage];
    [aCoder encodeObject:_colorValue forKey:kDBHProjectDetailInformationModelCategoryStructureColorValue];
    [aCoder encodeObject:_lang forKey:kDBHProjectDetailInformationModelCategoryStructureLang];
    [aCoder encodeObject:_colorName forKey:kDBHProjectDetailInformationModelCategoryStructureColorName];
    [aCoder encodeObject:_desc forKey:kDBHProjectDetailInformationModelCategoryStructureDesc];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelCategoryStructure *copy = [[DBHProjectDetailInformationModelCategoryStructure alloc] init];
    
    
    
    if (copy) {

        copy.percentage = self.percentage;
        copy.colorValue = [self.colorValue copyWithZone:zone];
        copy.lang = [self.lang copyWithZone:zone];
        copy.colorName = [self.colorName copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
    }
    
    return copy;
}


@end
