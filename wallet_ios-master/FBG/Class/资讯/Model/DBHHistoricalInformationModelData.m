//
//  DBHHistoricalInformationModelData.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHHistoricalInformationModelData.h"
#import "DBHHistoricalInformationModelCategory.h"
#import "DBHHistoricalInformationModelArticleUser.h"


NSString *const kDBHHistoricalInformationModelDataLang = @"lang";
NSString *const kDBHHistoricalInformationModelDataClickRate = @"click_rate";
NSString *const kDBHHistoricalInformationModelDataUrl = @"url";
NSString *const kDBHHistoricalInformationModelDataTitle = @"title";
NSString *const kDBHHistoricalInformationModelDataImg = @"img";
NSString *const kDBHHistoricalInformationModelDataUpdatedAt = @"updated_at";
NSString *const kDBHHistoricalInformationModelDataSort = @"sort";
NSString *const kDBHHistoricalInformationModelDataCategory = @"category";
NSString *const kDBHHistoricalInformationModelDataVideo = @"video";
NSString *const kDBHHistoricalInformationModelDataType = @"type";
NSString *const kDBHHistoricalInformationModelDataIsScroll = @"is_scroll";
NSString *const kDBHHistoricalInformationModelDataIsTop = @"is_top";
NSString *const kDBHHistoricalInformationModelDataId = @"id";
NSString *const kDBHHistoricalInformationModelDataArticleUser = @"article_user";
NSString *const kDBHHistoricalInformationModelDataIsSole = @"is_sole";
NSString *const kDBHHistoricalInformationModelDataCreatedAt = CREATED_AT;
NSString *const kDBHHistoricalInformationModelDataDesc = @"desc";
NSString *const kDBHHistoricalInformationModelDataCategoryId = @"category_id";
NSString *const kDBHHistoricalInformationModelDataIsHot = @"is_hot";
NSString *const kDBHHistoricalInformationModelDataAuthor = @"author";


@interface DBHHistoricalInformationModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHHistoricalInformationModelData

@synthesize lang = _lang;
@synthesize clickRate = _clickRate;
@synthesize url = _url;
@synthesize title = _title;
@synthesize img = _img;
@synthesize updatedAt = _updatedAt;
@synthesize sort = _sort;
@synthesize category = _category;
@synthesize video = _video;
@synthesize type = _type;
@synthesize isScroll = _isScroll;
@synthesize isTop = _isTop;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize articleUser = _articleUser;
@synthesize isSole = _isSole;
@synthesize createdAt = _createdAt;
@synthesize desc = _desc;
@synthesize categoryId = _categoryId;
@synthesize isHot = _isHot;
@synthesize author = _author;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.lang = [self objectOrNilForKey:kDBHHistoricalInformationModelDataLang fromDictionary:dict];
            self.clickRate = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataClickRate fromDictionary:dict] doubleValue];
            self.url = [self objectOrNilForKey:kDBHHistoricalInformationModelDataUrl fromDictionary:dict];
            self.title = [self objectOrNilForKey:kDBHHistoricalInformationModelDataTitle fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHHistoricalInformationModelDataImg fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHHistoricalInformationModelDataUpdatedAt fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataSort fromDictionary:dict] doubleValue];
            self.category = [DBHHistoricalInformationModelCategory modelObjectWithDictionary:[dict objectForKey:kDBHHistoricalInformationModelDataCategory]];
            self.video = [self objectOrNilForKey:kDBHHistoricalInformationModelDataVideo fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataIsScroll fromDictionary:dict] boolValue];
            self.isTop = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataIsTop fromDictionary:dict] boolValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataId fromDictionary:dict] doubleValue];
            self.articleUser = [DBHHistoricalInformationModelArticleUser modelObjectWithDictionary:[dict objectForKey:kDBHHistoricalInformationModelDataArticleUser]];
            self.isSole = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataIsSole fromDictionary:dict] boolValue];
            self.createdAt = [self objectOrNilForKey:kDBHHistoricalInformationModelDataCreatedAt fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHHistoricalInformationModelDataDesc fromDictionary:dict];
            self.categoryId = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataCategoryId fromDictionary:dict] doubleValue];
            self.isHot = [[self objectOrNilForKey:kDBHHistoricalInformationModelDataIsHot fromDictionary:dict] boolValue];
            self.author = [self objectOrNilForKey:kDBHHistoricalInformationModelDataAuthor fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lang forKey:kDBHHistoricalInformationModelDataLang];
    [mutableDict setValue:[NSNumber numberWithDouble:self.clickRate] forKey:kDBHHistoricalInformationModelDataClickRate];
    [mutableDict setValue:self.url forKey:kDBHHistoricalInformationModelDataUrl];
    [mutableDict setValue:self.title forKey:kDBHHistoricalInformationModelDataTitle];
    [mutableDict setValue:self.img forKey:kDBHHistoricalInformationModelDataImg];
    [mutableDict setValue:self.updatedAt forKey:kDBHHistoricalInformationModelDataUpdatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHHistoricalInformationModelDataSort];
    [mutableDict setValue:[self.category dictionaryRepresentation] forKey:kDBHHistoricalInformationModelDataCategory];
    [mutableDict setValue:self.video forKey:kDBHHistoricalInformationModelDataVideo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHHistoricalInformationModelDataType];
    [mutableDict setValue:[NSNumber numberWithBool:self.isScroll] forKey:kDBHHistoricalInformationModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithBool:self.isTop] forKey:kDBHHistoricalInformationModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHHistoricalInformationModelDataId];
    [mutableDict setValue:[self.articleUser dictionaryRepresentation] forKey:kDBHHistoricalInformationModelDataArticleUser];
    [mutableDict setValue:[NSNumber numberWithBool:self.isSole] forKey:kDBHHistoricalInformationModelDataIsSole];
    [mutableDict setValue:self.createdAt forKey:kDBHHistoricalInformationModelDataCreatedAt];
    [mutableDict setValue:self.desc forKey:kDBHHistoricalInformationModelDataDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHHistoricalInformationModelDataCategoryId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isHot] forKey:kDBHHistoricalInformationModelDataIsHot];
    [mutableDict setValue:self.author forKey:kDBHHistoricalInformationModelDataAuthor];

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

    self.lang = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataLang];
    self.clickRate = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataClickRate];
    self.url = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataUrl];
    self.title = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataTitle];
    self.img = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataImg];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataUpdatedAt];
    self.sort = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataSort];
    self.category = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataCategory];
    self.video = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataVideo];
    self.type = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataType];
    self.isScroll = [aDecoder decodeBoolForKey:kDBHHistoricalInformationModelDataIsScroll];
    self.isTop = [aDecoder decodeBoolForKey:kDBHHistoricalInformationModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataId];
    self.articleUser = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataArticleUser];
    self.isSole = [aDecoder decodeBoolForKey:kDBHHistoricalInformationModelDataIsSole];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataCreatedAt];
    self.desc = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataDesc];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelDataCategoryId];
    self.isHot = [aDecoder decodeBoolForKey:kDBHHistoricalInformationModelDataIsHot];
    self.author = [aDecoder decodeObjectForKey:kDBHHistoricalInformationModelDataAuthor];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lang forKey:kDBHHistoricalInformationModelDataLang];
    [aCoder encodeDouble:_clickRate forKey:kDBHHistoricalInformationModelDataClickRate];
    [aCoder encodeObject:_url forKey:kDBHHistoricalInformationModelDataUrl];
    [aCoder encodeObject:_title forKey:kDBHHistoricalInformationModelDataTitle];
    [aCoder encodeObject:_img forKey:kDBHHistoricalInformationModelDataImg];
    [aCoder encodeObject:_updatedAt forKey:kDBHHistoricalInformationModelDataUpdatedAt];
    [aCoder encodeDouble:_sort forKey:kDBHHistoricalInformationModelDataSort];
    [aCoder encodeObject:_category forKey:kDBHHistoricalInformationModelDataCategory];
    [aCoder encodeObject:_video forKey:kDBHHistoricalInformationModelDataVideo];
    [aCoder encodeDouble:_type forKey:kDBHHistoricalInformationModelDataType];
    [aCoder encodeBool:_isScroll forKey:kDBHHistoricalInformationModelDataIsScroll];
    [aCoder encodeBool:_isTop forKey:kDBHHistoricalInformationModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHHistoricalInformationModelDataId];
    [aCoder encodeObject:_articleUser forKey:kDBHHistoricalInformationModelDataArticleUser];
    [aCoder encodeBool:_isSole forKey:kDBHHistoricalInformationModelDataIsSole];
    [aCoder encodeObject:_createdAt forKey:kDBHHistoricalInformationModelDataCreatedAt];
    [aCoder encodeObject:_desc forKey:kDBHHistoricalInformationModelDataDesc];
    [aCoder encodeDouble:_categoryId forKey:kDBHHistoricalInformationModelDataCategoryId];
    [aCoder encodeBool:_isHot forKey:kDBHHistoricalInformationModelDataIsHot];
    [aCoder encodeObject:_author forKey:kDBHHistoricalInformationModelDataAuthor];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHHistoricalInformationModelData *copy = [[DBHHistoricalInformationModelData alloc] init];
    
    
    
    if (copy) {

        copy.lang = [self.lang copyWithZone:zone];
        copy.clickRate = self.clickRate;
        copy.url = [self.url copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.sort = self.sort;
        copy.category = [self.category copyWithZone:zone];
        copy.video = [self.video copyWithZone:zone];
        copy.type = self.type;
        copy.isScroll = self.isScroll;
        copy.isTop = self.isTop;
        copy.dataIdentifier = self.dataIdentifier;
        copy.articleUser = [self.articleUser copyWithZone:zone];
        copy.isSole = self.isSole;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.categoryId = self.categoryId;
        copy.isHot = self.isHot;
        copy.author = [self.author copyWithZone:zone];
    }
    
    return copy;
}


@end
