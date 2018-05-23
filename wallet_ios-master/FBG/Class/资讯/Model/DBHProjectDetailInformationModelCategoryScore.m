//
//  DBHProjectDetailInformationModelCategoryScore.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelCategoryScore.h"


NSString *const kDBHProjectDetailInformationModelCategoryScoreValue = VALUE;
NSString *const kDBHProjectDetailInformationModelCategoryScoreSort = @"sort";


@interface DBHProjectDetailInformationModelCategoryScore ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelCategoryScore

@synthesize value = _value;
@synthesize sort = _sort;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.value = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryScoreValue fromDictionary:dict] doubleValue];
            self.sort = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryScoreSort fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.value] forKey:kDBHProjectDetailInformationModelCategoryScoreValue];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHProjectDetailInformationModelCategoryScoreSort];

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

    self.value = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelCategoryScoreValue];
    self.sort = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelCategoryScoreSort];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_value forKey:kDBHProjectDetailInformationModelCategoryScoreValue];
    [aCoder encodeDouble:_sort forKey:kDBHProjectDetailInformationModelCategoryScoreSort];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelCategoryScore *copy = [[DBHProjectDetailInformationModelCategoryScore alloc] init];
    
    
    
    if (copy) {

        copy.value = self.value;
        copy.sort = self.sort;
    }
    
    return copy;
}


@end
