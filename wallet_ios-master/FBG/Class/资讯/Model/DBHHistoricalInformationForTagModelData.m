//
//  DBHHistoricalInformationForTagModelData.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHHistoricalInformationForTagModelData.h"


NSString *const kDBHHistoricalInformationForTagModelDataId = @"id";
NSString *const kDBHHistoricalInformationForTagModelDataLang = @"lang";
NSString *const kDBHHistoricalInformationForTagModelDataName = NAME;
NSString *const kDBHHistoricalInformationForTagModelDataDesc = @"desc";


@interface DBHHistoricalInformationForTagModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHHistoricalInformationForTagModelData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize lang = _lang;
@synthesize name = _name;
@synthesize desc = _desc;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.dataIdentifier = [[self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataId fromDictionary:dict] doubleValue];
            self.lang = [self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataLang fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataName fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHHistoricalInformationForTagModelDataDesc fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHHistoricalInformationForTagModelDataId];
    [mutableDict setValue:self.lang forKey:kDBHHistoricalInformationForTagModelDataLang];
    [mutableDict setValue:self.name forKey:kDBHHistoricalInformationForTagModelDataName];
    [mutableDict setValue:self.desc forKey:kDBHHistoricalInformationForTagModelDataDesc];

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

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationForTagModelDataId];
    self.lang = [aDecoder decodeObjectForKey:kDBHHistoricalInformationForTagModelDataLang];
    self.name = [aDecoder decodeObjectForKey:kDBHHistoricalInformationForTagModelDataName];
    self.desc = [aDecoder decodeObjectForKey:kDBHHistoricalInformationForTagModelDataDesc];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kDBHHistoricalInformationForTagModelDataId];
    [aCoder encodeObject:_lang forKey:kDBHHistoricalInformationForTagModelDataLang];
    [aCoder encodeObject:_name forKey:kDBHHistoricalInformationForTagModelDataName];
    [aCoder encodeObject:_desc forKey:kDBHHistoricalInformationForTagModelDataDesc];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHHistoricalInformationForTagModelData *copy = [[DBHHistoricalInformationForTagModelData alloc] init];
    
    
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.lang = [self.lang copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
    }
    
    return copy;
}


@end
