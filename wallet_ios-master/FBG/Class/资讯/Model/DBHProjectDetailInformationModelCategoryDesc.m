//
//  DBHProjectDetailInformationModelCategoryDesc.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelCategoryDesc.h"


NSString *const kDBHProjectDetailInformationModelCategoryDescContent = @"content";
NSString *const kDBHProjectDetailInformationModelCategoryDescEndAt = @"end_at";
NSString *const kDBHProjectDetailInformationModelCategoryDescLang = @"lang";
NSString *const kDBHProjectDetailInformationModelCategoryDescStartAt = @"start_at";


@interface DBHProjectDetailInformationModelCategoryDesc ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelCategoryDesc

@synthesize content = _content;
@synthesize endAt = _endAt;
@synthesize lang = _lang;
@synthesize startAt = _startAt;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.content = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryDescContent fromDictionary:dict];
            self.endAt = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryDescEndAt fromDictionary:dict];
            self.lang = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryDescLang fromDictionary:dict];
            self.startAt = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryDescStartAt fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.content forKey:kDBHProjectDetailInformationModelCategoryDescContent];
    [mutableDict setValue:self.endAt forKey:kDBHProjectDetailInformationModelCategoryDescEndAt];
    [mutableDict setValue:self.lang forKey:kDBHProjectDetailInformationModelCategoryDescLang];
    [mutableDict setValue:self.startAt forKey:kDBHProjectDetailInformationModelCategoryDescStartAt];

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

    self.content = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryDescContent];
    self.endAt = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryDescEndAt];
    self.lang = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryDescLang];
    self.startAt = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryDescStartAt];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_content forKey:kDBHProjectDetailInformationModelCategoryDescContent];
    [aCoder encodeObject:_endAt forKey:kDBHProjectDetailInformationModelCategoryDescEndAt];
    [aCoder encodeObject:_lang forKey:kDBHProjectDetailInformationModelCategoryDescLang];
    [aCoder encodeObject:_startAt forKey:kDBHProjectDetailInformationModelCategoryDescStartAt];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelCategoryDesc *copy = [[DBHProjectDetailInformationModelCategoryDesc alloc] init];
    
    
    
    if (copy) {

        copy.content = [self.content copyWithZone:zone];
        copy.endAt = [self.endAt copyWithZone:zone];
        copy.lang = [self.lang copyWithZone:zone];
        copy.startAt = [self.startAt copyWithZone:zone];
    }
    
    return copy;
}


@end
