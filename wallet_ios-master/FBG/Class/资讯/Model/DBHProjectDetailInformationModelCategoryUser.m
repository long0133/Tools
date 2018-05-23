//
//  DBHProjectDetailInformationModelCategoryUser.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelCategoryUser.h"


NSString *const kDBHProjectDetailInformationModelCategoryUserIsTop = @"is_top";
NSString *const kDBHProjectDetailInformationModelCategoryUserScore = @"score";
NSString *const kDBHProjectDetailInformationModelCategoryUserIsFavoriteDot = @"is_favorite_dot";
NSString *const kDBHProjectDetailInformationModelCategoryUserId = @"id";
NSString *const kDBHProjectDetailInformationModelCategoryUserCategoryId = @"category_id";
NSString *const kDBHProjectDetailInformationModelCategoryUserIsFavorite = @"is_favorite";
NSString *const kDBHProjectDetailInformationModelCategoryUserUserId = @"user_id";
NSString *const kDBHProjectDetailInformationModelCategoryUserIsMarketFollow = @"is_market_follow";
NSString *const kDBHProjectDetailInformationModelCategoryUserMarketLost = @"market_lost";
NSString *const kDBHProjectDetailInformationModelCategoryUserMarketHige = @"market_hige";


@interface DBHProjectDetailInformationModelCategoryUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelCategoryUser

@synthesize isTop = _isTop;
@synthesize score = _score;
@synthesize isFavoriteDot = _isFavoriteDot;
@synthesize categoryUserIdentifier = _categoryUserIdentifier;
@synthesize categoryId = _categoryId;
@synthesize isFavorite = _isFavorite;
@synthesize userId = _userId;
@synthesize isMarketFollow = _isMarketFollow;
@synthesize marketLost = _marketLost;
@synthesize marketHige = _marketHige;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.isTop = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserIsTop fromDictionary:dict] boolValue];
            self.score = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserScore fromDictionary:dict];
            self.isFavoriteDot = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserIsFavoriteDot fromDictionary:dict] boolValue];
            self.categoryUserIdentifier = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserId fromDictionary:dict] doubleValue];
            self.categoryId = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserCategoryId fromDictionary:dict] doubleValue];
            self.isFavorite = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserIsFavorite fromDictionary:dict] boolValue];
            self.userId = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserUserId fromDictionary:dict] doubleValue];
            self.isMarketFollow = [[self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserIsMarketFollow fromDictionary:dict] boolValue];
            self.marketLost = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserMarketLost fromDictionary:dict];
            self.marketHige = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryUserMarketHige fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.isTop] forKey:kDBHProjectDetailInformationModelCategoryUserIsTop];
    [mutableDict setValue:self.score forKey:kDBHProjectDetailInformationModelCategoryUserScore];
    [mutableDict setValue:[NSNumber numberWithBool:self.isFavoriteDot] forKey:kDBHProjectDetailInformationModelCategoryUserIsFavoriteDot];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryUserIdentifier] forKey:kDBHProjectDetailInformationModelCategoryUserId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHProjectDetailInformationModelCategoryUserCategoryId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isFavorite] forKey:kDBHProjectDetailInformationModelCategoryUserIsFavorite];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHProjectDetailInformationModelCategoryUserUserId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isMarketFollow] forKey:kDBHProjectDetailInformationModelCategoryUserIsMarketFollow];
    [mutableDict setValue:self.marketLost forKey:kDBHProjectDetailInformationModelCategoryUserMarketLost];
    [mutableDict setValue:self.marketHige forKey:kDBHProjectDetailInformationModelCategoryUserMarketHige];

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

    self.isTop = [aDecoder decodeBoolForKey:kDBHProjectDetailInformationModelCategoryUserIsTop];
    self.score = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryUserScore];
    self.isFavoriteDot = [aDecoder decodeBoolForKey:kDBHProjectDetailInformationModelCategoryUserIsFavoriteDot];
    self.categoryUserIdentifier = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelCategoryUserId];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelCategoryUserCategoryId];
    self.isFavorite = [aDecoder decodeBoolForKey:kDBHProjectDetailInformationModelCategoryUserIsFavorite];
    self.userId = [aDecoder decodeDoubleForKey:kDBHProjectDetailInformationModelCategoryUserUserId];
    self.isMarketFollow = [aDecoder decodeBoolForKey:kDBHProjectDetailInformationModelCategoryUserIsMarketFollow];
    self.marketLost = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryUserMarketLost];
    self.marketHige = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryUserMarketHige];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_isTop forKey:kDBHProjectDetailInformationModelCategoryUserIsTop];
    [aCoder encodeObject:_score forKey:kDBHProjectDetailInformationModelCategoryUserScore];
    [aCoder encodeBool:_isFavoriteDot forKey:kDBHProjectDetailInformationModelCategoryUserIsFavoriteDot];
    [aCoder encodeDouble:_categoryUserIdentifier forKey:kDBHProjectDetailInformationModelCategoryUserId];
    [aCoder encodeDouble:_categoryId forKey:kDBHProjectDetailInformationModelCategoryUserCategoryId];
    [aCoder encodeBool:_isFavorite forKey:kDBHProjectDetailInformationModelCategoryUserIsFavorite];
    [aCoder encodeDouble:_userId forKey:kDBHProjectDetailInformationModelCategoryUserUserId];
    [aCoder encodeBool:_isMarketFollow forKey:kDBHProjectDetailInformationModelCategoryUserIsMarketFollow];
    [aCoder encodeObject:_marketLost forKey:kDBHProjectDetailInformationModelCategoryUserMarketLost];
    [aCoder encodeObject:_marketHige forKey:kDBHProjectDetailInformationModelCategoryUserMarketHige];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelCategoryUser *copy = [[DBHProjectDetailInformationModelCategoryUser alloc] init];
    
    
    
    if (copy) {

        copy.isTop = self.isTop;
        copy.score = [self.score copyWithZone:zone];
        copy.isFavoriteDot = self.isFavoriteDot;
        copy.categoryUserIdentifier = self.categoryUserIdentifier;
        copy.categoryId = self.categoryId;
        copy.isFavorite = self.isFavorite;
        copy.userId = self.userId;
        copy.isMarketFollow = self.isMarketFollow;
        copy.marketLost = [self.marketLost copyWithZone:zone];
        copy.marketHige = [self.marketHige copyWithZone:zone];
    }
    
    return copy;
}


@end
