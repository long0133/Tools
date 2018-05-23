//
//  DBHProjectDetailInformationModelData.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelData.h"
#import "DBHProjectDetailInformationModelCategoryDesc.h"
#import "DBHProjectDetailInformationModelCategoryMedia.h"
#import "DBHProjectDetailInformationModelCategoryExplorer.h"
#import "DBHProjectDetailInformationModelCategoryUser.h"
#import "DBHProjectDetailInformationModelCategoryPresentation.h"
#import "DBHProjectDetailInformationModelCategoryIndustry.h"
#import "DBHProjectDetailInformationModelCategoryScore.h"
#import "DBHProjectDetailInformationModelIco.h"
#import "DBHProjectDetailInformationModelCategoryStructure.h"
#import "DBHProjectDetailInformationModelCategoryWallet.h"


NSString *const kDBHProjectDetailInformationModelDataTokenHolder = @"token_holder";
NSString *const kDBHProjectDetailInformationModelDataCategoryDesc = @"category_desc";
NSString *const kDBHProjectDetailInformationModelDataUrl = @"url";
NSString *const kDBHProjectDetailInformationModelDataImg = @"img";
NSString *const kDBHProjectDetailInformationModelDataCategoryMedia = @"category_media";
NSString *const kDBHProjectDetailInformationModelDataCategoryExplorer = @"category_explorer";
NSString *const kDBHProjectDetailInformationModelDataIndustry = @"industry";
NSString *const kDBHProjectDetailInformationModelDataCategoryUser = @"category_user";
NSString *const kDBHProjectDetailInformationModelDataCoverImg = @"cover_img";
NSString *const kDBHProjectDetailInformationModelDataName = NAME;
NSString *const kDBHProjectDetailInformationModelDataType = @"type";
NSString *const kDBHProjectDetailInformationModelDataIsScroll = @"is_scroll";
NSString *const kDBHProjectDetailInformationModelDataIsTop = @"is_top";
NSString *const kDBHProjectDetailInformationModelDataId = @"id";
NSString *const kDBHProjectDetailInformationModelDataWebsite = @"website";
NSString *const kDBHProjectDetailInformationModelDataCategoryPresentation = @"category_presentation";
NSString *const kDBHProjectDetailInformationModelDataCategoryIndustry = @"category_industry";
NSString *const kDBHProjectDetailInformationModelDataCategoryScore = @"category_score";
NSString *const kDBHProjectDetailInformationModelDataIcoPrice = @"ico_price";
NSString *const kDBHProjectDetailInformationModelDataUnit = @"unit";
NSString *const kDBHProjectDetailInformationModelDataTypeName = @"type_name";
NSString *const kDBHProjectDetailInformationModelDataIco = @"ico";
NSString *const kDBHProjectDetailInformationModelDataCategoryStructure = @"category_structure";
NSString *const kDBHProjectDetailInformationModelDataDesc = @"desc";
NSString *const kDBHProjectDetailInformationModelDataRoomId = @"room_id";
NSString *const kDBHProjectDetailInformationModelDataIsHot = @"is_hot";
NSString *const kDBHProjectDetailInformationModelDataCategoryWallet = @"category_wallet";
NSString *const kDBHProjectDetailInformationModelDataLongName = @"long_name";


@interface DBHProjectDetailInformationModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelData

@synthesize tokenHolder = _tokenHolder;
@synthesize categoryDesc = _categoryDesc;
@synthesize url = _url;
@synthesize img = _img;
@synthesize categoryMedia = _categoryMedia;
@synthesize categoryExplorer = _categoryExplorer;
@synthesize industry = _industry;
@synthesize categoryUser = _categoryUser;
@synthesize coverImg = _coverImg;
@synthesize name = _name;
@synthesize type = _type;
@synthesize isScroll = _isScroll;
@synthesize isTop = _isTop;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize website = _website;
@synthesize categoryPresentation = _categoryPresentation;
@synthesize categoryIndustry = _categoryIndustry;
@synthesize categoryScore = _categoryScore;
@synthesize icoPrice = _icoPrice;
@synthesize unit = _unit;
@synthesize typeName = _typeName;
@synthesize ico = _ico;
@synthesize categoryStructure = _categoryStructure;
@synthesize desc = _desc;
@synthesize roomId = _roomId;
@synthesize isHot = _isHot;
@synthesize categoryWallet = _categoryWallet;
@synthesize longName = _longName;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.tokenHolder = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataTokenHolder fromDictionary:dict];
            self.categoryDesc = [DBHProjectDetailInformationModelCategoryDesc modelObjectWithDictionary:[dict objectForKey:kDBHProjectDetailInformationModelDataCategoryDesc]];
            self.url = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataUrl fromDictionary:dict];
            self.img = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataImg fromDictionary:dict];
    NSObject *receivedDBHProjectDetailInformationModelCategoryMedia = [dict objectForKey:kDBHProjectDetailInformationModelDataCategoryMedia];
    NSMutableArray *parsedDBHProjectDetailInformationModelCategoryMedia = [NSMutableArray array];
    
    if ([receivedDBHProjectDetailInformationModelCategoryMedia isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHProjectDetailInformationModelCategoryMedia) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHProjectDetailInformationModelCategoryMedia addObject:[DBHProjectDetailInformationModelCategoryMedia modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHProjectDetailInformationModelCategoryMedia isKindOfClass:[NSDictionary class]]) {
       [parsedDBHProjectDetailInformationModelCategoryMedia addObject:[DBHProjectDetailInformationModelCategoryMedia modelObjectWithDictionary:(NSDictionary *)receivedDBHProjectDetailInformationModelCategoryMedia]];
    }

    self.categoryMedia = [NSArray arrayWithArray:parsedDBHProjectDetailInformationModelCategoryMedia];
    NSObject *receivedDBHProjectDetailInformationModelCategoryExplorer = [dict objectForKey:kDBHProjectDetailInformationModelDataCategoryExplorer];
    NSMutableArray *parsedDBHProjectDetailInformationModelCategoryExplorer = [NSMutableArray array];
    
    if ([receivedDBHProjectDetailInformationModelCategoryExplorer isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHProjectDetailInformationModelCategoryExplorer) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHProjectDetailInformationModelCategoryExplorer addObject:[DBHProjectDetailInformationModelCategoryExplorer modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHProjectDetailInformationModelCategoryExplorer isKindOfClass:[NSDictionary class]]) {
       [parsedDBHProjectDetailInformationModelCategoryExplorer addObject:[DBHProjectDetailInformationModelCategoryExplorer modelObjectWithDictionary:(NSDictionary *)receivedDBHProjectDetailInformationModelCategoryExplorer]];
    }

    self.categoryExplorer = [NSArray arrayWithArray:parsedDBHProjectDetailInformationModelCategoryExplorer];
            self.industry = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataIndustry fromDictionary:dict];
            self.categoryUser = [DBHProjectDetailInformationModelCategoryUser modelObjectWithDictionary:[dict objectForKey:kDBHProjectDetailInformationModelDataCategoryUser]];
            self.coverImg = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataCoverImg fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataName fromDictionary:dict];
            self.type = [[self objectOrNilForKey:kDBHProjectDetailInformationModelDataType fromDictionary:dict] doubleValue];
            self.isScroll = [[self objectOrNilForKey:kDBHProjectDetailInformationModelDataIsScroll fromDictionary:dict] boolValue];
            self.isTop = [[self objectOrNilForKey:kDBHProjectDetailInformationModelDataIsTop fromDictionary:dict] boolValue];
            self.dataIdentifier = [[self objectOrNilForKey:kDBHProjectDetailInformationModelDataId fromDictionary:dict] doubleValue];
            self.website = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataWebsite fromDictionary:dict];
            self.categoryPresentation = [DBHProjectDetailInformationModelCategoryPresentation modelObjectWithDictionary:[dict objectForKey:kDBHProjectDetailInformationModelDataCategoryPresentation]];
    NSObject *receivedDBHProjectDetailInformationModelCategoryIndustry = [dict objectForKey:kDBHProjectDetailInformationModelDataCategoryIndustry];
    NSMutableArray *parsedDBHProjectDetailInformationModelCategoryIndustry = [NSMutableArray array];
    
    if ([receivedDBHProjectDetailInformationModelCategoryIndustry isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHProjectDetailInformationModelCategoryIndustry) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHProjectDetailInformationModelCategoryIndustry addObject:[DBHProjectDetailInformationModelCategoryIndustry modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHProjectDetailInformationModelCategoryIndustry isKindOfClass:[NSDictionary class]]) {
       [parsedDBHProjectDetailInformationModelCategoryIndustry addObject:[DBHProjectDetailInformationModelCategoryIndustry modelObjectWithDictionary:(NSDictionary *)receivedDBHProjectDetailInformationModelCategoryIndustry]];
    }

    self.categoryIndustry = [NSArray arrayWithArray:parsedDBHProjectDetailInformationModelCategoryIndustry];
            self.categoryScore = [DBHProjectDetailInformationModelCategoryScore modelObjectWithDictionary:[dict objectForKey:kDBHProjectDetailInformationModelDataCategoryScore]];
            self.icoPrice = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataIcoPrice fromDictionary:dict];
            self.unit = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataUnit fromDictionary:dict];
            self.typeName = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataTypeName fromDictionary:dict];
            self.ico = [DBHProjectDetailInformationModelIco modelObjectWithDictionary:[dict objectForKey:kDBHProjectDetailInformationModelDataIco]];
    NSObject *receivedDBHProjectDetailInformationModelCategoryStructure = [dict objectForKey:kDBHProjectDetailInformationModelDataCategoryStructure];
    NSMutableArray *parsedDBHProjectDetailInformationModelCategoryStructure = [NSMutableArray array];
    
    if ([receivedDBHProjectDetailInformationModelCategoryStructure isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHProjectDetailInformationModelCategoryStructure) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHProjectDetailInformationModelCategoryStructure addObject:[DBHProjectDetailInformationModelCategoryStructure modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHProjectDetailInformationModelCategoryStructure isKindOfClass:[NSDictionary class]]) {
       [parsedDBHProjectDetailInformationModelCategoryStructure addObject:[DBHProjectDetailInformationModelCategoryStructure modelObjectWithDictionary:(NSDictionary *)receivedDBHProjectDetailInformationModelCategoryStructure]];
    }

    self.categoryStructure = [NSArray arrayWithArray:parsedDBHProjectDetailInformationModelCategoryStructure];
            self.desc = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataDesc fromDictionary:dict];
            self.roomId = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataRoomId fromDictionary:dict];
            self.isHot = [[self objectOrNilForKey:kDBHProjectDetailInformationModelDataIsHot fromDictionary:dict] boolValue];
    NSObject *receivedDBHProjectDetailInformationModelCategoryWallet = [dict objectForKey:kDBHProjectDetailInformationModelDataCategoryWallet];
    NSMutableArray *parsedDBHProjectDetailInformationModelCategoryWallet = [NSMutableArray array];
    
    if ([receivedDBHProjectDetailInformationModelCategoryWallet isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHProjectDetailInformationModelCategoryWallet) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHProjectDetailInformationModelCategoryWallet addObject:[DBHProjectDetailInformationModelCategoryWallet modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHProjectDetailInformationModelCategoryWallet isKindOfClass:[NSDictionary class]]) {
       [parsedDBHProjectDetailInformationModelCategoryWallet addObject:[DBHProjectDetailInformationModelCategoryWallet modelObjectWithDictionary:(NSDictionary *)receivedDBHProjectDetailInformationModelCategoryWallet]];
    }

    self.categoryWallet = [NSArray arrayWithArray:parsedDBHProjectDetailInformationModelCategoryWallet];
            self.longName = [self objectOrNilForKey:kDBHProjectDetailInformationModelDataLongName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.tokenHolder forKey:kDBHProjectDetailInformationModelDataTokenHolder];
    [mutableDict setValue:[self.categoryDesc dictionaryRepresentation] forKey:kDBHProjectDetailInformationModelDataCategoryDesc];
    [mutableDict setValue:self.url forKey:kDBHProjectDetailInformationModelDataUrl];
    [mutableDict setValue:self.img forKey:kDBHProjectDetailInformationModelDataImg];
    NSMutableArray *tempArrayForCategoryMedia = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.categoryMedia) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCategoryMedia addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCategoryMedia addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCategoryMedia] forKey:kDBHProjectDetailInformationModelDataCategoryMedia];
    NSMutableArray *tempArrayForCategoryExplorer = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.categoryExplorer) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCategoryExplorer addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCategoryExplorer addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCategoryExplorer] forKey:kDBHProjectDetailInformationModelDataCategoryExplorer];
    [mutableDict setValue:self.industry forKey:kDBHProjectDetailInformationModelDataIndustry];
    [mutableDict setValue:[self.categoryUser dictionaryRepresentation] forKey:kDBHProjectDetailInformationModelDataCategoryUser];
    [mutableDict setValue:self.coverImg forKey:kDBHProjectDetailInformationModelDataCoverImg];
    [mutableDict setValue:self.name forKey:kDBHProjectDetailInformationModelDataName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kDBHProjectDetailInformationModelDataType];
    [mutableDict setValue:[NSNumber numberWithBool:self.isScroll] forKey:kDBHProjectDetailInformationModelDataIsScroll];
    [mutableDict setValue:[NSNumber numberWithBool:self.isTop] forKey:kDBHProjectDetailInformationModelDataIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDBHProjectDetailInformationModelDataId];
    [mutableDict setValue:self.website forKey:kDBHProjectDetailInformationModelDataWebsite];
    [mutableDict setValue:[self.categoryPresentation dictionaryRepresentation] forKey:kDBHProjectDetailInformationModelDataCategoryPresentation];
    NSMutableArray *tempArrayForCategoryIndustry = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.categoryIndustry) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCategoryIndustry addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCategoryIndustry addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCategoryIndustry] forKey:kDBHProjectDetailInformationModelDataCategoryIndustry];
    [mutableDict setValue:[self.categoryScore dictionaryRepresentation] forKey:kDBHProjectDetailInformationModelDataCategoryScore];
    [mutableDict setValue:self.icoPrice forKey:kDBHProjectDetailInformationModelDataIcoPrice];
    [mutableDict setValue:self.unit forKey:kDBHProjectDetailInformationModelDataUnit];
    [mutableDict setValue:self.typeName forKey:kDBHProjectDetailInformationModelDataTypeName];
    [mutableDict setValue:[self.ico dictionaryRepresentation] forKey:kDBHProjectDetailInformationModelDataIco];
    NSMutableArray *tempArrayForCategoryStructure = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.categoryStructure) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCategoryStructure addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCategoryStructure addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCategoryStructure] forKey:kDBHProjectDetailInformationModelDataCategoryStructure];
    [mutableDict setValue:self.desc forKey:kDBHProjectDetailInformationModelDataDesc];
    [mutableDict setValue:self.roomId forKey:kDBHProjectDetailInformationModelDataRoomId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isHot] forKey:kDBHProjectDetailInformationModelDataIsHot];
    NSMutableArray *tempArrayForCategoryWallet = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.categoryWallet) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCategoryWallet addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCategoryWallet addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCategoryWallet] forKey:kDBHProjectDetailInformationModelDataCategoryWallet];
    [mutableDict setValue:self.longName forKey:kDBHProjectDetailInformationModelDataLongName];

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

    self.tokenHolder = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataTokenHolder];
    self.categoryDesc = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCategoryDesc];
    self.url = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataUrl];
    self.img = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataImg];
    self.categoryMedia = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCategoryMedia];
    self.categoryExplorer = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCategoryExplorer];
    self.industry = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataIndustry];
    self.categoryUser = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCategoryUser];
    self.coverImg = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCoverImg];
    self.name = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataName];
    self.type = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelDataType];
    self.isScroll = [aDecoder decodeBoolForKey:kDBHProjectDetailInformationModelDataIsScroll];
    self.isTop = [aDecoder decodeBoolForKey:kDBHProjectDetailInformationModelDataIsTop];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelDataId];
    self.website = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataWebsite];
    self.categoryPresentation = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCategoryPresentation];
    self.categoryIndustry = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCategoryIndustry];
    self.categoryScore = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCategoryScore];
    self.icoPrice = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataIcoPrice];
    self.unit = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataUnit];
    self.typeName = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataTypeName];
    self.ico = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataIco];
    self.categoryStructure = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCategoryStructure];
    self.desc = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataDesc];
    self.roomId = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataRoomId];
    self.isHot = [aDecoder decodeBoolForKey:kDBHProjectDetailInformationModelDataIsHot];
    self.categoryWallet = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataCategoryWallet];
    self.longName = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelDataLongName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_tokenHolder forKey:kDBHProjectDetailInformationModelDataTokenHolder];
    [aCoder encodeObject:_categoryDesc forKey:kDBHProjectDetailInformationModelDataCategoryDesc];
    [aCoder encodeObject:_url forKey:kDBHProjectDetailInformationModelDataUrl];
    [aCoder encodeObject:_img forKey:kDBHProjectDetailInformationModelDataImg];
    [aCoder encodeObject:_categoryMedia forKey:kDBHProjectDetailInformationModelDataCategoryMedia];
    [aCoder encodeObject:_categoryExplorer forKey:kDBHProjectDetailInformationModelDataCategoryExplorer];
    [aCoder encodeObject:_industry forKey:kDBHProjectDetailInformationModelDataIndustry];
    [aCoder encodeObject:_categoryUser forKey:kDBHProjectDetailInformationModelDataCategoryUser];
    [aCoder encodeObject:_coverImg forKey:kDBHProjectDetailInformationModelDataCoverImg];
    [aCoder encodeObject:_name forKey:kDBHProjectDetailInformationModelDataName];
    [aCoder encodeDouble:_type forKey:kDBHProjectDetailInformationModelDataType];
    [aCoder encodeBool:_isScroll forKey:kDBHProjectDetailInformationModelDataIsScroll];
    [aCoder encodeBool:_isTop forKey:kDBHProjectDetailInformationModelDataIsTop];
    [aCoder encodeDouble:_dataIdentifier forKey:kDBHProjectDetailInformationModelDataId];
    [aCoder encodeObject:_website forKey:kDBHProjectDetailInformationModelDataWebsite];
    [aCoder encodeObject:_categoryPresentation forKey:kDBHProjectDetailInformationModelDataCategoryPresentation];
    [aCoder encodeObject:_categoryIndustry forKey:kDBHProjectDetailInformationModelDataCategoryIndustry];
    [aCoder encodeObject:_categoryScore forKey:kDBHProjectDetailInformationModelDataCategoryScore];
    [aCoder encodeObject:_icoPrice forKey:kDBHProjectDetailInformationModelDataIcoPrice];
    [aCoder encodeObject:_unit forKey:kDBHProjectDetailInformationModelDataUnit];
    [aCoder encodeObject:_typeName forKey:kDBHProjectDetailInformationModelDataTypeName];
    [aCoder encodeObject:_ico forKey:kDBHProjectDetailInformationModelDataIco];
    [aCoder encodeObject:_categoryStructure forKey:kDBHProjectDetailInformationModelDataCategoryStructure];
    [aCoder encodeObject:_desc forKey:kDBHProjectDetailInformationModelDataDesc];
    [aCoder encodeObject:_roomId forKey:kDBHProjectDetailInformationModelDataRoomId];
    [aCoder encodeBool:_isHot forKey:kDBHProjectDetailInformationModelDataIsHot];
    [aCoder encodeObject:_categoryWallet forKey:kDBHProjectDetailInformationModelDataCategoryWallet];
    [aCoder encodeObject:_longName forKey:kDBHProjectDetailInformationModelDataLongName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelData *copy = [[DBHProjectDetailInformationModelData alloc] init];
    
    
    
    if (copy) {

        copy.tokenHolder = [self.tokenHolder copyWithZone:zone];
        copy.categoryDesc = [self.categoryDesc copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.categoryMedia = [self.categoryMedia copyWithZone:zone];
        copy.categoryExplorer = [self.categoryExplorer copyWithZone:zone];
        copy.industry = [self.industry copyWithZone:zone];
        copy.categoryUser = [self.categoryUser copyWithZone:zone];
        copy.coverImg = [self.coverImg copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.type = self.type;
        copy.isScroll = self.isScroll;
        copy.isTop = self.isTop;
        copy.dataIdentifier = self.dataIdentifier;
        copy.website = [self.website copyWithZone:zone];
        copy.categoryPresentation = [self.categoryPresentation copyWithZone:zone];
        copy.categoryIndustry = [self.categoryIndustry copyWithZone:zone];
        copy.categoryScore = [self.categoryScore copyWithZone:zone];
        copy.icoPrice = [self.icoPrice copyWithZone:zone];
        copy.unit = [self.unit copyWithZone:zone];
        copy.typeName = [self.typeName copyWithZone:zone];
        copy.ico = [self.ico copyWithZone:zone];
        copy.categoryStructure = [self.categoryStructure copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.roomId = [self.roomId copyWithZone:zone];
        copy.isHot = self.isHot;
        copy.categoryWallet = [self.categoryWallet copyWithZone:zone];
        copy.longName = [self.longName copyWithZone:zone];
    }
    
    return copy;
}


@end
