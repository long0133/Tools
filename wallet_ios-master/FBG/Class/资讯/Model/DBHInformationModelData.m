//
//  DBHInformationModelData.m
//
//  Created by   on 2018/1/26
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationModelData.h"
#import "DBHInformationModelCategoryUser.h"
#import "DBHInformationModelLastArticle.h"
#import "DBHInformationModelIco.h"


NSString *const kDBHInformationModelDataLongName = @"long_name";
NSString *const kDBHInformationModelDataUrl = @"url";
NSString *const kDBHInformationModelDataImg = @"img";
NSString *const kDBHInformationModelDataIndustry = @"industry";
NSString *const kDBHInformationModelDataCategoryUser = @"category_user";
NSString *const kDBHInformationModelDataCoverImg = @"cover_img";
NSString *const kDBHInformationModelDataName = NAME;
NSString *const kDBHInformationModelDataType = @"type";
NSString *const kDBHInformationModelDataIsScroll = @"is_scroll";
NSString *const kDBHInformationModelDataIsTop = @"is_top";
NSString *const kDBHInformationModelDataId = @"id";
NSString *const kDBHInformationModelDataWebsite = @"website";
NSString *const kDBHInformationModelDataTypeName = @"type_name";
NSString *const kDBHInformationModelDataUnit = @"unit";
NSString *const kDBHInformationModelDataLastArticle = @"last_article";
NSString *const kDBHInformationModelDataIco = @"ico";
NSString *const kDBHInformationModelDataRoomId = @"room_id";
NSString *const kDBHInformationModelDataDesc = @"desc";
NSString *const kDBHInformationModelDataIsHot = @"is_hot";
NSString *const kDBHInformationModelDataTokenHolder = @"token_holder";


@interface DBHInformationModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationModelData

@synthesize longName = _longName;
@synthesize url = _url;
@synthesize img = _img;
@synthesize industry = _industry;
@synthesize categoryUser = _categoryUser;
@synthesize coverImg = _coverImg;
@synthesize name = _name;
@synthesize type = _type;
@synthesize isScroll = _isScroll;
@synthesize isTop = _isTop;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize website = _website;
@synthesize typeName = _typeName;
@synthesize unit = _unit;
@synthesize lastArticle = _lastArticle;
@synthesize ico = _ico;
@synthesize roomId = _roomId;
@synthesize desc = _desc;
@synthesize isHot = _isHot;
@synthesize tokenHolder = _tokenHolder;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.longName = [self objectOrNilForKey:kDBHInformationModelDataLongName fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHInformationModelDataUrl fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHInformationModelDataImg fromDictionary:dict];
            self.industry = [self objectOrNilForKey:kDBHInformationModelDataIndustry fromDictionary:dict];
            self.categoryUser = [DBHInformationModelCategoryUser modelObjectWithDictionary:[dict objectForKey:kDBHInformationModelDataCategoryUser]];
            self.coverImg = [self objectOrNilForKey:kDBHInformationModelDataCoverImg fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationModelDataName fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kDBHInformationModelDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHInformationModelDataIsScroll fromDictionary:dict] boolValue];
            self.isTop = [[self objectOrNilForKey:kDBHInformationModelDataIsTop fromDictionary:dict] boolValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHInformationModelDataId fromDictionary:dict] doubleValue];
            self.website = [self objectOrNilForKey:kDBHInformationModelDataWebsite fromDictionary:dict];
            self.typeName = [self objectOrNilForKey:kDBHInformationModelDataTypeName fromDictionary:dict];
            self.unit = [self objectOrNilForKey:kDBHInformationModelDataUnit fromDictionary:dict];
            self.lastArticle = [DBHInformationModelLastArticle modelObjectWithDictionary:[dict objectForKey:kDBHInformationModelDataLastArticle]];
            self.ico = [DBHInformationModelIco modelObjectWithDictionary:[dict objectForKey:kDBHInformationModelDataIco]];
            self.roomId = [[self objectOrNilForKey:kDBHInformationModelDataRoomId fromDictionary:dict] doubleValue];
            self.desc = [self objectOrNilForKey:kDBHInformationModelDataDesc fromDictionary:dict];
            self.isHot = [[self objectOrNilForKey:kDBHInformationModelDataIsHot fromDictionary:dict] boolValue];
            self.tokenHolder = [self objectOrNilForKey:kDBHInformationModelDataTokenHolder fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.longName forKey:kDBHInformationModelDataLongName];
    [mutableDict setValue:self.url forKey:kDBHInformationModelDataUrl];
    [mutableDict setValue:self.img forKey:kDBHInformationModelDataImg];
    [mutableDict setValue:self.industry forKey:kDBHInformationModelDataIndustry];
    [mutableDict setValue:[self.categoryUser dictionaryRepresentation] forKey:kDBHInformationModelDataCategoryUser];
    [mutableDict setValue:self.coverImg forKey:kDBHInformationModelDataCoverImg];
    [mutableDict setValue:self.name forKey:kDBHInformationModelDataName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHInformationModelDataType];
    [mutableDict setValue:[NSNumber numberWithBool:self.isScroll] forKey:kDBHInformationModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithBool:self.isTop] forKey:kDBHInformationModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHInformationModelDataId];
    [mutableDict setValue:self.website forKey:kDBHInformationModelDataWebsite];
    [mutableDict setValue:self.typeName forKey:kDBHInformationModelDataTypeName];
    [mutableDict setValue:self.unit forKey:kDBHInformationModelDataUnit];
    [mutableDict setValue:[self.lastArticle dictionaryRepresentation] forKey:kDBHInformationModelDataLastArticle];
    [mutableDict setValue:[self.ico dictionaryRepresentation] forKey:kDBHInformationModelDataIco];
    [mutableDict setValue:[NSNumber numberWithDouble:self.roomId] forKey:kDBHInformationModelDataRoomId];
    [mutableDict setValue:self.desc forKey:kDBHInformationModelDataDesc];
    [mutableDict setValue:[NSNumber numberWithBool:self.isHot] forKey:kDBHInformationModelDataIsHot];
    [mutableDict setValue:self.tokenHolder forKey:kDBHInformationModelDataTokenHolder];

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

    self.longName = [aDecoder decodeObjectForKey:kDBHInformationModelDataLongName];
    self.url = [aDecoder decodeObjectForKey:kDBHInformationModelDataUrl];
    self.img = [aDecoder decodeObjectForKey:kDBHInformationModelDataImg];
    self.industry = [aDecoder decodeObjectForKey:kDBHInformationModelDataIndustry];
    self.categoryUser = [aDecoder decodeObjectForKey:kDBHInformationModelDataCategoryUser];
    self.coverImg = [aDecoder decodeObjectForKey:kDBHInformationModelDataCoverImg];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationModelDataName];
    self.type = [aDecoder decodeDoubleForKey:kDBHInformationModelDataType];
    self.isScroll = [aDecoder decodeBoolForKey:kDBHInformationModelDataIsScroll];
    self.isTop = [aDecoder decodeBoolForKey:kDBHInformationModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationModelDataId];
    self.website = [aDecoder decodeObjectForKey:kDBHInformationModelDataWebsite];
    self.typeName = [aDecoder decodeObjectForKey:kDBHInformationModelDataTypeName];
    self.unit = [aDecoder decodeObjectForKey:kDBHInformationModelDataUnit];
    self.lastArticle = [aDecoder decodeObjectForKey:kDBHInformationModelDataLastArticle];
    self.ico = [aDecoder decodeObjectForKey:kDBHInformationModelDataIco];
    self.roomId = [aDecoder decodeDoubleForKey:kDBHInformationModelDataRoomId];
    self.desc = [aDecoder decodeObjectForKey:kDBHInformationModelDataDesc];
    self.isHot = [aDecoder decodeBoolForKey:kDBHInformationModelDataIsHot];
    self.tokenHolder = [aDecoder decodeObjectForKey:kDBHInformationModelDataTokenHolder];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_longName forKey:kDBHInformationModelDataLongName];
    [aCoder encodeObject:_url forKey:kDBHInformationModelDataUrl];
    [aCoder encodeObject:_img forKey:kDBHInformationModelDataImg];
    [aCoder encodeObject:_industry forKey:kDBHInformationModelDataIndustry];
    [aCoder encodeObject:_categoryUser forKey:kDBHInformationModelDataCategoryUser];
    [aCoder encodeObject:_coverImg forKey:kDBHInformationModelDataCoverImg];
    [aCoder encodeObject:_name forKey:kDBHInformationModelDataName];
    [aCoder encodeDouble:_type forKey:kDBHInformationModelDataType];
    [aCoder encodeBool:_isScroll forKey:kDBHInformationModelDataIsScroll];
    [aCoder encodeBool:_isTop forKey:kDBHInformationModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHInformationModelDataId];
    [aCoder encodeObject:_website forKey:kDBHInformationModelDataWebsite];
    [aCoder encodeObject:_typeName forKey:kDBHInformationModelDataTypeName];
    [aCoder encodeObject:_unit forKey:kDBHInformationModelDataUnit];
    [aCoder encodeObject:_lastArticle forKey:kDBHInformationModelDataLastArticle];
    [aCoder encodeObject:_ico forKey:kDBHInformationModelDataIco];
    [aCoder encodeDouble:_roomId forKey:kDBHInformationModelDataRoomId];
    [aCoder encodeObject:_desc forKey:kDBHInformationModelDataDesc];
    [aCoder encodeBool:_isHot forKey:kDBHInformationModelDataIsHot];
    [aCoder encodeObject:_tokenHolder forKey:kDBHInformationModelDataTokenHolder];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationModelData *copy = [[DBHInformationModelData alloc] init];
    
    
    
    if (copy) {

        copy.longName = [self.longName copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.industry = [self.industry copyWithZone:zone];
        copy.categoryUser = [self.categoryUser copyWithZone:zone];
        copy.coverImg = [self.coverImg copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.type = self.type;
        copy.isScroll = self.isScroll;
        copy.isTop = self.isTop;
        copy.dataIdentifier = self.dataIdentifier;
        copy.website = [self.website copyWithZone:zone];
        copy.typeName = [self.typeName copyWithZone:zone];
        copy.unit = [self.unit copyWithZone:zone];
        copy.lastArticle = [self.lastArticle copyWithZone:zone];
        copy.ico = [self.ico copyWithZone:zone];
        copy.roomId = self.roomId;
        copy.desc = [self.desc copyWithZone:zone];
        copy.isHot = self.isHot;
        copy.tokenHolder = [self.tokenHolder copyWithZone:zone];
    }
    
    return copy;
}


@end
