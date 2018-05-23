//
//  DBHInfomationModelData.m
//
//  Created by   on 2018/2/7
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInfomationModelData.h"
#import "DBHInfomationModelCategory.h"
#import "DBHInfomationModelArticleUser.h"


NSString *const kDBHInfomationModelDataLang = @"lang";
NSString *const kDBHInfomationModelDataClickRate = @"click_rate";
NSString *const kDBHInfomationModelDataUrl = @"url";
NSString *const kDBHInfomationModelDataTitle = @"title";
NSString *const kDBHInfomationModelDataImg = @"img";
NSString *const kDBHInfomationModelDataUpdatedAt = @"updated_at";
NSString *const kDBHInfomationModelDataSort = @"sort";
NSString *const kDBHInfomationModelDataCategory = @"category";
NSString *const kDBHInfomationModelDataVideo = @"video";
NSString *const kDBHInfomationModelDataType = @"type";
NSString *const kDBHInfomationModelDataIsScroll = @"is_scroll";
NSString *const kDBHInfomationModelDataIsTop = @"is_top";
NSString *const kDBHInfomationModelDataId = @"id";
NSString *const kDBHInfomationModelDataArticleUser = @"article_user";
NSString *const kDBHInfomationModelDataIsSole = @"is_sole";
NSString *const kDBHInfomationModelDataCreatedAt = CREATED_AT;
NSString *const kDBHInfomationModelDataDesc = @"desc";
NSString *const kDBHInfomationModelDataCategoryId = @"category_id";
NSString *const kDBHInfomationModelDataIsHot = @"is_hot";
NSString *const kDBHInfomationModelDataAuthor = @"author";


@interface DBHInfomationModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInfomationModelData

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
            self.lang = [self objectOrNilForKey:kDBHInfomationModelDataLang fromDictionary:dict];
            self.clickRate = [[self objectOrNilForKey:kDBHInfomationModelDataClickRate fromDictionary:dict] doubleValue];
            self.url = [self objectOrNilForKey:kDBHInfomationModelDataUrl fromDictionary:dict];
            self.title = [self objectOrNilForKey:kDBHInfomationModelDataTitle fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHInfomationModelDataImg fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHInfomationModelDataUpdatedAt fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHInfomationModelDataSort fromDictionary:dict] doubleValue];
            self.category = [DBHInfomationModelCategory modelObjectWithDictionary:[dict objectForKey:kDBHInfomationModelDataCategory]];
            self.video = [self objectOrNilForKey:kDBHInfomationModelDataVideo fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kDBHInfomationModelDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHInfomationModelDataIsScroll fromDictionary:dict] boolValue];
            self.isTop = [[self objectOrNilForKey:kDBHInfomationModelDataIsTop fromDictionary:dict] boolValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHInfomationModelDataId fromDictionary:dict] doubleValue];
            self.articleUser = [DBHInfomationModelArticleUser modelObjectWithDictionary:[dict objectForKey:kDBHInfomationModelDataArticleUser]];
            self.isSole = [[self objectOrNilForKey:kDBHInfomationModelDataIsSole fromDictionary:dict] boolValue];
            self.createdAt = [self objectOrNilForKey:kDBHInfomationModelDataCreatedAt fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHInfomationModelDataDesc fromDictionary:dict];
            self.categoryId = [[self objectOrNilForKey:kDBHInfomationModelDataCategoryId fromDictionary:dict] doubleValue];
            self.isHot = [[self objectOrNilForKey:kDBHInfomationModelDataIsHot fromDictionary:dict] boolValue];
            self.author = [self objectOrNilForKey:kDBHInfomationModelDataAuthor fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lang forKey:kDBHInfomationModelDataLang];
    [mutableDict setValue:[NSNumber numberWithDouble:self.clickRate] forKey:kDBHInfomationModelDataClickRate];
    [mutableDict setValue:self.url forKey:kDBHInfomationModelDataUrl];
    [mutableDict setValue:self.title forKey:kDBHInfomationModelDataTitle];
    [mutableDict setValue:self.img forKey:kDBHInfomationModelDataImg];
    [mutableDict setValue:self.updatedAt forKey:kDBHInfomationModelDataUpdatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHInfomationModelDataSort];
    [mutableDict setValue:[self.category dictionaryRepresentation] forKey:kDBHInfomationModelDataCategory];
    [mutableDict setValue:self.video forKey:kDBHInfomationModelDataVideo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHInfomationModelDataType];
    [mutableDict setValue:[NSNumber numberWithBool:self.isScroll] forKey:kDBHInfomationModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithBool:self.isTop] forKey:kDBHInfomationModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHInfomationModelDataId];
    [mutableDict setValue:[self.articleUser dictionaryRepresentation] forKey:kDBHInfomationModelDataArticleUser];
    [mutableDict setValue:[NSNumber numberWithBool:self.isSole] forKey:kDBHInfomationModelDataIsSole];
    [mutableDict setValue:self.createdAt forKey:kDBHInfomationModelDataCreatedAt];
    [mutableDict setValue:self.desc forKey:kDBHInfomationModelDataDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHInfomationModelDataCategoryId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isHot] forKey:kDBHInfomationModelDataIsHot];
    [mutableDict setValue:self.author forKey:kDBHInfomationModelDataAuthor];

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

    self.lang = [aDecoder decodeObjectForKey:kDBHInfomationModelDataLang];
    self.clickRate = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataClickRate];
    self.url = [aDecoder decodeObjectForKey:kDBHInfomationModelDataUrl];
    self.title = [aDecoder decodeObjectForKey:kDBHInfomationModelDataTitle];
    self.img = [aDecoder decodeObjectForKey:kDBHInfomationModelDataImg];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHInfomationModelDataUpdatedAt];
    self.sort = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataSort];
    self.category = [aDecoder decodeObjectForKey:kDBHInfomationModelDataCategory];
    self.video = [aDecoder decodeObjectForKey:kDBHInfomationModelDataVideo];
    self.type = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataType];
    self.isScroll = [aDecoder decodeBoolForKey:kDBHInfomationModelDataIsScroll];
    self.isTop = [aDecoder decodeBoolForKey:kDBHInfomationModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataId];
    self.articleUser = [aDecoder decodeObjectForKey:kDBHInfomationModelDataArticleUser];
    self.isSole = [aDecoder decodeBoolForKey:kDBHInfomationModelDataIsSole];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInfomationModelDataCreatedAt];
    self.desc = [aDecoder decodeObjectForKey:kDBHInfomationModelDataDesc];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHInfomationModelDataCategoryId];
    self.isHot = [aDecoder decodeBoolForKey:kDBHInfomationModelDataIsHot];
    self.author = [aDecoder decodeObjectForKey:kDBHInfomationModelDataAuthor];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lang forKey:kDBHInfomationModelDataLang];
    [aCoder encodeDouble:_clickRate forKey:kDBHInfomationModelDataClickRate];
    [aCoder encodeObject:_url forKey:kDBHInfomationModelDataUrl];
    [aCoder encodeObject:_title forKey:kDBHInfomationModelDataTitle];
    [aCoder encodeObject:_img forKey:kDBHInfomationModelDataImg];
    [aCoder encodeObject:_updatedAt forKey:kDBHInfomationModelDataUpdatedAt];
    [aCoder encodeDouble:_sort forKey:kDBHInfomationModelDataSort];
    [aCoder encodeObject:_category forKey:kDBHInfomationModelDataCategory];
    [aCoder encodeObject:_video forKey:kDBHInfomationModelDataVideo];
    [aCoder encodeDouble:_type forKey:kDBHInfomationModelDataType];
    [aCoder encodeBool:_isScroll forKey:kDBHInfomationModelDataIsScroll];
    [aCoder encodeBool:_isTop forKey:kDBHInfomationModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHInfomationModelDataId];
    [aCoder encodeObject:_articleUser forKey:kDBHInfomationModelDataArticleUser];
    [aCoder encodeBool:_isSole forKey:kDBHInfomationModelDataIsSole];
    [aCoder encodeObject:_createdAt forKey:kDBHInfomationModelDataCreatedAt];
    [aCoder encodeObject:_desc forKey:kDBHInfomationModelDataDesc];
    [aCoder encodeDouble:_categoryId forKey:kDBHInfomationModelDataCategoryId];
    [aCoder encodeBool:_isHot forKey:kDBHInfomationModelDataIsHot];
    [aCoder encodeObject:_author forKey:kDBHInfomationModelDataAuthor];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInfomationModelData *copy = [[DBHInfomationModelData alloc] init];
    
    
    
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
