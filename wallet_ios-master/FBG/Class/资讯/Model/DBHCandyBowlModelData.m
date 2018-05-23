//
//  DBHCandyBowlModelData.m
//
//  Created by   on 2018/1/31
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHCandyBowlModelData.h"


NSString *const kDBHCandyBowlModelDataUrl = @"url";
NSString *const kDBHCandyBowlModelDataImg = @"img";
NSString *const kDBHCandyBowlModelDataLang = @"lang";
NSString *const kDBHCandyBowlModelDataId = @"id";
NSString *const kDBHCandyBowlModelDataCategoryId = @"category_id";
NSString *const kDBHCandyBowlModelDataDay = @"day";
NSString *const kDBHCandyBowlModelDataMonth = @"month";
NSString *const kDBHCandyBowlModelDataIsScroll = @"is_scroll";
NSString *const kDBHCandyBowlModelDataYear = @"year";
NSString *const kDBHCandyBowlModelDataDesc = @"desc";
NSString *const kDBHCandyBowlModelDataName = NAME;


@interface DBHCandyBowlModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHCandyBowlModelData

@synthesize url = _url;
@synthesize img = _img;
@synthesize lang = _lang;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize categoryId = _categoryId;
@synthesize day = _day;
@synthesize month = _month;
@synthesize isScroll = _isScroll;
@synthesize year = _year;
@synthesize desc = _desc;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.url = [self objectOrNilForKey:kDBHCandyBowlModelDataUrl fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHCandyBowlModelDataImg fromDictionary:dict];
            self.lang = [self objectOrNilForKey:kDBHCandyBowlModelDataLang fromDictionary:dict];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHCandyBowlModelDataId fromDictionary:dict] doubleValue];
            self.categoryId = [[self objectOrNilForKey:kDBHCandyBowlModelDataCategoryId fromDictionary:dict] doubleValue];
            self.day = [[self objectOrNilForKey:kDBHCandyBowlModelDataDay fromDictionary:dict] doubleValue];
            self.month = [[self objectOrNilForKey:kDBHCandyBowlModelDataMonth fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHCandyBowlModelDataIsScroll fromDictionary:dict] doubleValue];
            self.year = [[self objectOrNilForKey:kDBHCandyBowlModelDataYear fromDictionary:dict] doubleValue];
            self.desc = [self objectOrNilForKey:kDBHCandyBowlModelDataDesc fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHCandyBowlModelDataName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.url forKey:kDBHCandyBowlModelDataUrl];
    [mutableDict setValue:self.img forKey:kDBHCandyBowlModelDataImg];
    [mutableDict setValue:self.lang forKey:kDBHCandyBowlModelDataLang];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHCandyBowlModelDataId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHCandyBowlModelDataCategoryId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.day] forKey:kDBHCandyBowlModelDataDay];
    [mutableDict setValue:[NSNumber numberWithDouble:self.month] forKey:kDBHCandyBowlModelDataMonth];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isScroll] forKey:kDBHCandyBowlModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithDouble:self.year] forKey:kDBHCandyBowlModelDataYear];
    [mutableDict setValue:self.desc forKey:kDBHCandyBowlModelDataDesc];
    [mutableDict setValue:self.name forKey:kDBHCandyBowlModelDataName];

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

    self.url = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataUrl];
    self.img = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataImg];
    self.lang = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataLang];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataId];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataCategoryId];
    self.day = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataDay];
    self.month = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataMonth];
    self.isScroll = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataIsScroll];
    self.year = [aDecoder decodeDoubleForKey:kDBHCandyBowlModelDataYear];
    self.desc = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataDesc];
    self.name = [aDecoder decodeObjectForKey:kDBHCandyBowlModelDataName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_url forKey:kDBHCandyBowlModelDataUrl];
    [aCoder encodeObject:_img forKey:kDBHCandyBowlModelDataImg];
    [aCoder encodeObject:_lang forKey:kDBHCandyBowlModelDataLang];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHCandyBowlModelDataId];
    [aCoder encodeDouble:_categoryId forKey:kDBHCandyBowlModelDataCategoryId];
    [aCoder encodeDouble:_day forKey:kDBHCandyBowlModelDataDay];
    [aCoder encodeDouble:_month forKey:kDBHCandyBowlModelDataMonth];
    [aCoder encodeDouble:_isScroll forKey:kDBHCandyBowlModelDataIsScroll];
    [aCoder encodeDouble:_year forKey:kDBHCandyBowlModelDataYear];
    [aCoder encodeObject:_desc forKey:kDBHCandyBowlModelDataDesc];
    [aCoder encodeObject:_name forKey:kDBHCandyBowlModelDataName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHCandyBowlModelData *copy = [[DBHCandyBowlModelData alloc] init];
    
    
    
    if (copy) {

        copy.url = [self.url copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.lang = [self.lang copyWithZone:zone];
        copy.dataIdentifier = self.dataIdentifier;
        copy.categoryId = self.categoryId;
        copy.day = self.day;
        copy.month = self.month;
        copy.isScroll = self.isScroll;
        copy.year = self.year;
        copy.desc = [self.desc copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
