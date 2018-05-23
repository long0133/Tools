//
//  DBHInformationModelLastArticle.m
//
//  Created by   on 2018/1/26
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationModelLastArticle.h"


NSString *const kDBHInformationModelLastArticleImg = @"img";
NSString *const kDBHInformationModelLastArticleId = @"id";
NSString *const kDBHInformationModelLastArticleCategoryId = @"category_id";
NSString *const kDBHInformationModelLastArticleTitle = @"title";
NSString *const kDBHInformationModelLastArticleCreatedAt = CREATED_AT;
NSString *const kDBHInformationModelLastArticleDesc = @"desc";
NSString *const kDBHInformationModelLastArticleUrl = @"url";


@interface DBHInformationModelLastArticle ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationModelLastArticle

@synthesize img = _img;
@synthesize lastArticleIdentifier = _lastArticleIdentifier;
@synthesize categoryId = _categoryId;
@synthesize title = _title;
@synthesize createdAt = _createdAt;
@synthesize desc = _desc;
@synthesize url = _url;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.img = [self objectOrNilForKey:kDBHInformationModelLastArticleImg fromDictionary:dict];
            self.lastArticleIdentifier = [[self objectOrNilForKey:kDBHInformationModelLastArticleId fromDictionary:dict] doubleValue];
            self.categoryId = [[self objectOrNilForKey:kDBHInformationModelLastArticleCategoryId fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kDBHInformationModelLastArticleTitle fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kDBHInformationModelLastArticleCreatedAt fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInformationModelLastArticleDesc fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationModelLastArticleUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.img forKey:kDBHInformationModelLastArticleImg];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastArticleIdentifier] forKey:kDBHInformationModelLastArticleId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHInformationModelLastArticleCategoryId];
    [mutableDict setValue:self.title forKey:kDBHInformationModelLastArticleTitle];
    [mutableDict setValue:self.createdAt forKey:kDBHInformationModelLastArticleCreatedAt];
    [mutableDict setValue:self.desc forKey:kDBHInformationModelLastArticleDesc];
    [mutableDict setValue:self.url forKey:kDBHInformationModelLastArticleUrl];

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

    self.img = [aDecoder decodeObjectForKey:kDBHInformationModelLastArticleImg];
    self.lastArticleIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationModelLastArticleId];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHInformationModelLastArticleCategoryId];
    self.title = [aDecoder decodeObjectForKey:kDBHInformationModelLastArticleTitle];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInformationModelLastArticleCreatedAt];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationModelLastArticleDesc];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationModelLastArticleUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_img forKey:kDBHInformationModelLastArticleImg];
    [aCoder encodeDouble:_lastArticleIdentifier forKey:kDBHInformationModelLastArticleId];
    [aCoder encodeDouble:_categoryId forKey:kDBHInformationModelLastArticleCategoryId];
    [aCoder encodeObject:_title forKey:kDBHInformationModelLastArticleTitle];
    [aCoder encodeObject:_createdAt forKey:kDBHInformationModelLastArticleCreatedAt];
    [aCoder encodeObject:_desc forKey:kDBHInformationModelLastArticleDesc];
    [aCoder encodeObject:_url forKey:kDBHInformationModelLastArticleUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationModelLastArticle *copy = [[DBHInformationModelLastArticle alloc] init];
    
    
    
    if (copy) {

        copy.img = [self.img copyWithZone:zone];
        copy.lastArticleIdentifier = self.lastArticleIdentifier;
        copy.categoryId = self.categoryId;
        copy.title = [self.title copyWithZone:zone];
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
