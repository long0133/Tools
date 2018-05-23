//
//  DBHExchangeNoticeModelData.m
//
//  Created by   on 2018/2/8
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHExchangeNoticeModelData.h"


NSString *const kDBHExchangeNoticeModelDataId = @"id";
NSString *const kDBHExchangeNoticeModelDataIsHot = @"is_hot";
NSString *const kDBHExchangeNoticeModelDataIsTop = @"is_top";
NSString *const kDBHExchangeNoticeModelDataCreatedAt = CREATED_AT;
NSString *const kDBHExchangeNoticeModelDataUrl = @"url";
NSString *const kDBHExchangeNoticeModelDataIsScroll = @"is_scroll";
NSString *const kDBHExchangeNoticeModelDataDesc = @"desc";
NSString *const kDBHExchangeNoticeModelDataSourceName = @"source_name";
NSString *const kDBHExchangeNoticeModelDataSourceUrl = @"source_url";
NSString *const kDBHExchangeNoticeModelDataUpdatedAt = @"updated_at";
NSString *const kDBHExchangeNoticeModelDataLang = @"lang";
NSString *const kDBHExchangeNoticeModelDataContent = @"content";


@interface DBHExchangeNoticeModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHExchangeNoticeModelData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize isHot = _isHot;
@synthesize isTop = _isTop;
@synthesize createdAt = _createdAt;
@synthesize url = _url;
@synthesize isScroll = _isScroll;
@synthesize desc = _desc;
@synthesize sourceName = _sourceName;
@synthesize sourceUrl = _sourceUrl;
@synthesize updatedAt = _updatedAt;
@synthesize lang = _lang;
@synthesize content = _content;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.dataIdentifier = [[self objectOrNilForKey:kDBHExchangeNoticeModelDataId fromDictionary:dict] doubleValue];
            self.isHot = [[self objectOrNilForKey:kDBHExchangeNoticeModelDataIsHot fromDictionary:dict] boolValue];
            self.isTop = [[self objectOrNilForKey:kDBHExchangeNoticeModelDataIsTop fromDictionary:dict] boolValue];
            self.createdAt = [self objectOrNilForKey:kDBHExchangeNoticeModelDataCreatedAt fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHExchangeNoticeModelDataUrl fromDictionary:dict];
            self.isScroll = [[self objectOrNilForKey:kDBHExchangeNoticeModelDataIsScroll fromDictionary:dict] boolValue];
            self.desc = [self objectOrNilForKey:kDBHExchangeNoticeModelDataDesc fromDictionary:dict];
            self.sourceName = [self objectOrNilForKey:kDBHExchangeNoticeModelDataSourceName fromDictionary:dict];
            self.sourceUrl = [self objectOrNilForKey:kDBHExchangeNoticeModelDataSourceUrl fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:kDBHExchangeNoticeModelDataUpdatedAt fromDictionary:dict];
            self.lang = [self objectOrNilForKey:kDBHExchangeNoticeModelDataLang fromDictionary:dict];
            self.content = [self objectOrNilForKey:kDBHExchangeNoticeModelDataContent fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHExchangeNoticeModelDataId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isHot] forKey:kDBHExchangeNoticeModelDataIsHot];
    [mutableDict setValue:[NSNumber numberWithBool:self.isTop] forKey:kDBHExchangeNoticeModelDataIsTop];
    [mutableDict setValue:self.createdAt forKey:kDBHExchangeNoticeModelDataCreatedAt];
    [mutableDict setValue:self.url forKey:kDBHExchangeNoticeModelDataUrl];
    [mutableDict setValue:[NSNumber numberWithBool:self.isScroll] forKey:kDBHExchangeNoticeModelDataIsScroll];
    [mutableDict setValue:self.desc forKey:kDBHExchangeNoticeModelDataDesc];
    [mutableDict setValue:self.sourceName forKey:kDBHExchangeNoticeModelDataSourceName];
    [mutableDict setValue:self.sourceUrl forKey:kDBHExchangeNoticeModelDataSourceUrl];
    [mutableDict setValue:self.updatedAt forKey:kDBHExchangeNoticeModelDataUpdatedAt];
    [mutableDict setValue:self.lang forKey:kDBHExchangeNoticeModelDataLang];
    [mutableDict setValue:self.content forKey:kDBHExchangeNoticeModelDataContent];

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

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHExchangeNoticeModelDataId];
    self.isHot = [aDecoder decodeBoolForKey:kDBHExchangeNoticeModelDataIsHot];
    self.isTop = [aDecoder decodeBoolForKey:kDBHExchangeNoticeModelDataIsTop];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataCreatedAt];
    self.url = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataUrl];
    self.isScroll = [aDecoder decodeBoolForKey:kDBHExchangeNoticeModelDataIsScroll];
    self.desc = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataDesc];
    self.sourceName = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataSourceName];
    self.sourceUrl = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataSourceUrl];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataUpdatedAt];
    self.lang = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataLang];
    self.content = [aDecoder decodeObjectForKey:kDBHExchangeNoticeModelDataContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kDBHExchangeNoticeModelDataId];
    [aCoder encodeBool:_isHot forKey:kDBHExchangeNoticeModelDataIsHot];
    [aCoder encodeBool:_isTop forKey:kDBHExchangeNoticeModelDataIsTop];
    [aCoder encodeObject:_createdAt forKey:kDBHExchangeNoticeModelDataCreatedAt];
    [aCoder encodeObject:_url forKey:kDBHExchangeNoticeModelDataUrl];
    [aCoder encodeBool:_isScroll forKey:kDBHExchangeNoticeModelDataIsScroll];
    [aCoder encodeObject:_desc forKey:kDBHExchangeNoticeModelDataDesc];
    [aCoder encodeObject:_sourceName forKey:kDBHExchangeNoticeModelDataSourceName];
    [aCoder encodeObject:_sourceUrl forKey:kDBHExchangeNoticeModelDataSourceUrl];
    [aCoder encodeObject:_updatedAt forKey:kDBHExchangeNoticeModelDataUpdatedAt];
    [aCoder encodeObject:_lang forKey:kDBHExchangeNoticeModelDataLang];
    [aCoder encodeObject:_content forKey:kDBHExchangeNoticeModelDataContent];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHExchangeNoticeModelData *copy = [[DBHExchangeNoticeModelData alloc] init];
    
    
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.isHot = self.isHot;
        copy.isTop = self.isTop;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.isScroll = self.isScroll;
        copy.desc = [self.desc copyWithZone:zone];
        copy.sourceName = [self.sourceName copyWithZone:zone];
        copy.sourceUrl = [self.sourceUrl copyWithZone:zone];
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.lang = [self.lang copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
    }
    
    return copy;
}


@end
