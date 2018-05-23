//
//  DBHProjectDetailInformationModelCategoryPresentation.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelCategoryPresentation.h"


NSString *const kDBHProjectDetailInformationModelCategoryPresentationId = @"id";
NSString *const kDBHProjectDetailInformationModelCategoryPresentationCategoryId = @"category_id";
NSString *const kDBHProjectDetailInformationModelCategoryPresentationContent = @"content";


@interface DBHProjectDetailInformationModelCategoryPresentation ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelCategoryPresentation

@synthesize categoryPresentationIdentifier = _categoryPresentationIdentifier;
@synthesize categoryId = _categoryId;
@synthesize content = _content;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.categoryPresentationIdentifier = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryPresentationId fromDictionary:dict] doubleValue];
            self.categoryId = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryPresentationCategoryId fromDictionary:dict] doubleValue];
            self.content = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryPresentationContent fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryPresentationIdentifier] forKey:kDBHProjectDetailInformationModelCategoryPresentationId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHProjectDetailInformationModelCategoryPresentationCategoryId];
    [mutableDict setValue:self.content forKey:kDBHProjectDetailInformationModelCategoryPresentationContent];

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

    self.categoryPresentationIdentifier = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelCategoryPresentationId];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelCategoryPresentationCategoryId];
    self.content = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryPresentationContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_categoryPresentationIdentifier forKey:kDBHProjectDetailInformationModelCategoryPresentationId];
    [aCoder encodeDouble:_categoryId forKey:kDBHProjectDetailInformationModelCategoryPresentationCategoryId];
    [aCoder encodeObject:_content forKey:kDBHProjectDetailInformationModelCategoryPresentationContent];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelCategoryPresentation *copy = [[DBHProjectDetailInformationModelCategoryPresentation alloc] init];
    
    
    
    if (copy) {

        copy.categoryPresentationIdentifier = self.categoryPresentationIdentifier;
        copy.categoryId = self.categoryId;
        copy.content = [self.content copyWithZone:zone];
    }
    
    return copy;
}


@end
