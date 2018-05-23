//
//  DBHProjectHomeNewsModelData.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectHomeNewsModelData.h"
#import "DBHProjectHomeNewsModelCategory.h"
#import "DBHProjectHomeNewsModelArticleUser.h"


NSString *const kDBHProjectHomeNewsModelDataLang = @"lang";
NSString *const kDBHProjectHomeNewsModelDataClickRate = @"click_rate";
NSString *const kDBHProjectHomeNewsModelDataUrl = @"url";
NSString *const kDBHProjectHomeNewsModelDataTitle = @"title";
NSString *const kDBHProjectHomeNewsModelDataImg = @"img";
NSString *const kDBHProjectHomeNewsModelDataUpdatedAt = @"updated_at";
NSString *const kDBHProjectHomeNewsModelDataSort = @"sort";
NSString *const kDBHProjectHomeNewsModelDataCategory = @"category";
NSString *const kDBHProjectHomeNewsModelDataVideo = @"video";
NSString *const kDBHProjectHomeNewsModelDataType = @"type";
NSString *const kDBHProjectHomeNewsModelDataIsScroll = @"is_scroll";
NSString *const kDBHProjectHomeNewsModelDataIsTop = @"is_top";
NSString *const kDBHProjectHomeNewsModelDataId = @"id";
NSString *const kDBHProjectHomeNewsModelDataArticleUser = @"article_user";
NSString *const kDBHProjectHomeNewsModelDataIsSole = @"is_sole";
NSString *const kDBHProjectHomeNewsModelDataCreatedAt = CREATED_AT;
NSString *const kDBHProjectHomeNewsModelDataDesc = @"desc";
NSString *const kDBHProjectHomeNewsModelDataCategoryId = @"category_id";
NSString *const kDBHProjectHomeNewsModelDataIsHot = @"is_hot";
NSString *const kDBHProjectHomeNewsModelDataAuthor = @"author";


@interface DBHProjectHomeNewsModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectHomeNewsModelData

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
            self.lang = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataLang fromDictionary:dict];
            self.clickRate = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataClickRate fromDictionary:dict] doubleValue];
            self.url = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataUrl fromDictionary:dict];
            self.title = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataTitle fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataImg fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataUpdatedAt fromDictionary:dict];
            self.sort = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataSort fromDictionary:dict] doubleValue];
            self.category = [DBHProjectHomeNewsModelCategory modelObjectWithDictionary:[dict objectForKey:kDBHProjectHomeNewsModelDataCategory]];
            self.video = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataVideo fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataIsScroll fromDictionary:dict] boolValue];
            self.isTop = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataIsTop fromDictionary:dict] boolValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataId fromDictionary:dict] doubleValue];
            self.articleUser = [DBHProjectHomeNewsModelArticleUser modelObjectWithDictionary:[dict objectForKey:kDBHProjectHomeNewsModelDataArticleUser]];
            self.isSole = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataIsSole fromDictionary:dict] boolValue];
            self.createdAt = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataCreatedAt fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataDesc fromDictionary:dict];
            self.categoryId = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataCategoryId fromDictionary:dict] doubleValue];
            self.isHot = [[self objectOrNilForKey:kDBHProjectHomeNewsModelDataIsHot fromDictionary:dict] boolValue];
            self.author = [self objectOrNilForKey:kDBHProjectHomeNewsModelDataAuthor fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lang forKey:kDBHProjectHomeNewsModelDataLang];
    [mutableDict setValue:[NSNumber numberWithDouble:self.clickRate] forKey:kDBHProjectHomeNewsModelDataClickRate];
    [mutableDict setValue:self.url forKey:kDBHProjectHomeNewsModelDataUrl];
    [mutableDict setValue:self.title forKey:kDBHProjectHomeNewsModelDataTitle];
    [mutableDict setValue:self.img forKey:kDBHProjectHomeNewsModelDataImg];
    [mutableDict setValue:self.updatedAt forKey:kDBHProjectHomeNewsModelDataUpdatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sort] forKey:kDBHProjectHomeNewsModelDataSort];
    [mutableDict setValue:[self.category dictionaryRepresentation] forKey:kDBHProjectHomeNewsModelDataCategory];
    [mutableDict setValue:self.video forKey:kDBHProjectHomeNewsModelDataVideo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHProjectHomeNewsModelDataType];
    [mutableDict setValue:[NSNumber numberWithBool:self.isScroll] forKey:kDBHProjectHomeNewsModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithBool:self.isTop] forKey:kDBHProjectHomeNewsModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHProjectHomeNewsModelDataId];
    [mutableDict setValue:[self.articleUser dictionaryRepresentation] forKey:kDBHProjectHomeNewsModelDataArticleUser];
    [mutableDict setValue:[NSNumber numberWithBool:self.isSole] forKey:kDBHProjectHomeNewsModelDataIsSole];
    [mutableDict setValue:self.createdAt forKey:kDBHProjectHomeNewsModelDataCreatedAt];
    [mutableDict setValue:self.desc forKey:kDBHProjectHomeNewsModelDataDesc];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHProjectHomeNewsModelDataCategoryId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isHot] forKey:kDBHProjectHomeNewsModelDataIsHot];
    [mutableDict setValue:self.author forKey:kDBHProjectHomeNewsModelDataAuthor];

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

    self.lang = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataLang];
    self.clickRate = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataClickRate];
    self.url = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataUrl];
    self.title = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataTitle];
    self.img = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataImg];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataUpdatedAt];
    self.sort = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataSort];
    self.category = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataCategory];
    self.video = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataVideo];
    self.type = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataType];
    self.isScroll = [aDecoder decodeBoolForKey:kDBHProjectHomeNewsModelDataIsScroll];
    self.isTop = [aDecoder decodeBoolForKey:kDBHProjectHomeNewsModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataId];
    self.articleUser = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataArticleUser];
    self.isSole = [aDecoder decodeBoolForKey:kDBHProjectHomeNewsModelDataIsSole];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataCreatedAt];
    self.desc = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataDesc];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelDataCategoryId];
    self.isHot = [aDecoder decodeBoolForKey:kDBHProjectHomeNewsModelDataIsHot];
    self.author = [aDecoder decodeObjectForKey:kDBHProjectHomeNewsModelDataAuthor];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lang forKey:kDBHProjectHomeNewsModelDataLang];
    [aCoder encodeDouble:_clickRate forKey:kDBHProjectHomeNewsModelDataClickRate];
    [aCoder encodeObject:_url forKey:kDBHProjectHomeNewsModelDataUrl];
    [aCoder encodeObject:_title forKey:kDBHProjectHomeNewsModelDataTitle];
    [aCoder encodeObject:_img forKey:kDBHProjectHomeNewsModelDataImg];
    [aCoder encodeObject:_updatedAt forKey:kDBHProjectHomeNewsModelDataUpdatedAt];
    [aCoder encodeDouble:_sort forKey:kDBHProjectHomeNewsModelDataSort];
    [aCoder encodeObject:_category forKey:kDBHProjectHomeNewsModelDataCategory];
    [aCoder encodeObject:_video forKey:kDBHProjectHomeNewsModelDataVideo];
    [aCoder encodeDouble:_type forKey:kDBHProjectHomeNewsModelDataType];
    [aCoder encodeBool:_isScroll forKey:kDBHProjectHomeNewsModelDataIsScroll];
    [aCoder encodeBool:_isTop forKey:kDBHProjectHomeNewsModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHProjectHomeNewsModelDataId];
    [aCoder encodeObject:_articleUser forKey:kDBHProjectHomeNewsModelDataArticleUser];
    [aCoder encodeBool:_isSole forKey:kDBHProjectHomeNewsModelDataIsSole];
    [aCoder encodeObject:_createdAt forKey:kDBHProjectHomeNewsModelDataCreatedAt];
    [aCoder encodeObject:_desc forKey:kDBHProjectHomeNewsModelDataDesc];
    [aCoder encodeDouble:_categoryId forKey:kDBHProjectHomeNewsModelDataCategoryId];
    [aCoder encodeBool:_isHot forKey:kDBHProjectHomeNewsModelDataIsHot];
    [aCoder encodeObject:_author forKey:kDBHProjectHomeNewsModelDataAuthor];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectHomeNewsModelData *copy = [[DBHProjectHomeNewsModelData alloc] init];
    
    
    
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
