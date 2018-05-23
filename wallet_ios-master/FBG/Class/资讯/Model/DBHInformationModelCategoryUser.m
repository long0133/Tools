//
//  DBHInformationModelCategoryUser.m
//
//  Created by   on 2018/2/13
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationModelCategoryUser.h"


NSString *const kDBHInformationModelCategoryUserId = @"id";
NSString *const kDBHInformationModelCategoryUserIsFavorite = @"is_favorite";
NSString *const kDBHInformationModelCategoryUserIsFavoriteDot = @"is_favorite_dot";
NSString *const kDBHInformationModelCategoryUserMarketLost = @"market_lost";
NSString *const kDBHInformationModelCategoryUserMarketHige = @"market_hige";
NSString *const kDBHInformationModelCategoryUserIsTop = @"is_top";
NSString *const kDBHInformationModelCategoryUserCategoryId = @"category_id";
NSString *const kDBHInformationModelCategoryUserCreatedAt = CREATED_AT;
NSString *const kDBHInformationModelCategoryUserUserId = @"user_id";
NSString *const kDBHInformationModelCategoryUserIsMarketFollow = @"is_market_follow";
NSString *const kDBHInformationModelCategoryUserUpdatedAt = @"updated_at";
NSString *const kDBHInformationModelCategoryUserScore = @"score";


@interface DBHInformationModelCategoryUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationModelCategoryUser

@synthesize categoryUserIdentifier = _categoryUserIdentifier;
@synthesize isFavorite = _isFavorite;
@synthesize isFavoriteDot = _isFavoriteDot;
@synthesize marketLost = _marketLost;
@synthesize marketHige = _marketHige;
@synthesize isTop = _isTop;
@synthesize categoryId = _categoryId;
@synthesize createdAt = _createdAt;
@synthesize userId = _userId;
@synthesize isMarketFollow = _isMarketFollow;
@synthesize updatedAt = _updatedAt;
@synthesize score = _score;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.categoryUserIdentifier = [[self objectOrNilForKey:kDBHInformationModelCategoryUserId fromDictionary:dict] doubleValue];
            self.isFavorite = [[self objectOrNilForKey:kDBHInformationModelCategoryUserIsFavorite fromDictionary:dict] boolValue];
            self.isFavoriteDot = [[self objectOrNilForKey:kDBHInformationModelCategoryUserIsFavoriteDot fromDictionary:dict] boolValue];
            self.marketLost = [self objectOrNilForKey:kDBHInformationModelCategoryUserMarketLost fromDictionary:dict];
            self.marketHige = [self objectOrNilForKey:kDBHInformationModelCategoryUserMarketHige fromDictionary:dict];
            self.isTop = [[self objectOrNilForKey:kDBHInformationModelCategoryUserIsTop fromDictionary:dict] boolValue];
            self.categoryId = [[self objectOrNilForKey:kDBHInformationModelCategoryUserCategoryId fromDictionary:dict] doubleValue];
            self.createdAt = [self objectOrNilForKey:kDBHInformationModelCategoryUserCreatedAt fromDictionary:dict];
            self.userId = [[self objectOrNilForKey:kDBHInformationModelCategoryUserUserId fromDictionary:dict] doubleValue];
            self.isMarketFollow = [[self objectOrNilForKey:kDBHInformationModelCategoryUserIsMarketFollow fromDictionary:dict] boolValue];
            self.updatedAt = [self objectOrNilForKey:kDBHInformationModelCategoryUserUpdatedAt fromDictionary:dict];
            self.score = [self objectOrNilForKey:kDBHInformationModelCategoryUserScore fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryUserIdentifier] forKey:kDBHInformationModelCategoryUserId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isFavorite] forKey:kDBHInformationModelCategoryUserIsFavorite];
    [mutableDict setValue:[NSNumber numberWithBool:self.isFavoriteDot] forKey:kDBHInformationModelCategoryUserIsFavoriteDot];
    [mutableDict setValue:self.marketLost forKey:kDBHInformationModelCategoryUserMarketLost];
    [mutableDict setValue:self.marketHige forKey:kDBHInformationModelCategoryUserMarketHige];
    [mutableDict setValue:[NSNumber numberWithBool:self.isTop] forKey:kDBHInformationModelCategoryUserIsTop];
    [mutableDict setValue:[NSNumber numberWithDouble:self.categoryId] forKey:kDBHInformationModelCategoryUserCategoryId];
    [mutableDict setValue:self.createdAt forKey:kDBHInformationModelCategoryUserCreatedAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHInformationModelCategoryUserUserId];
    [mutableDict setValue:[NSNumber numberWithBool:self.isMarketFollow] forKey:kDBHInformationModelCategoryUserIsMarketFollow];
    [mutableDict setValue:self.updatedAt forKey:kDBHInformationModelCategoryUserUpdatedAt];
    [mutableDict setValue:self.score forKey:kDBHInformationModelCategoryUserScore];

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

    self.categoryUserIdentifier = [aDecoder decodeDoubleForKey:kDBHInformationModelCategoryUserId];
    self.isFavorite = [aDecoder decodeBoolForKey:kDBHInformationModelCategoryUserIsFavorite];
    self.isFavoriteDot = [aDecoder decodeBoolForKey:kDBHInformationModelCategoryUserIsFavoriteDot];
    self.marketLost = [aDecoder decodeObjectForKey:kDBHInformationModelCategoryUserMarketLost];
    self.marketHige = [aDecoder decodeObjectForKey:kDBHInformationModelCategoryUserMarketHige];
    self.isTop = [aDecoder decodeBoolForKey:kDBHInformationModelCategoryUserIsTop];
    self.categoryId = [aDecoder decodeDoubleForKey:kDBHInformationModelCategoryUserCategoryId];
    self.createdAt = [aDecoder decodeObjectForKey:kDBHInformationModelCategoryUserCreatedAt];
    self.userId = [aDecoder decodeDoubleForKey:kDBHInformationModelCategoryUserUserId];
    self.isMarketFollow = [aDecoder decodeBoolForKey:kDBHInformationModelCategoryUserIsMarketFollow];
    self.updatedAt = [aDecoder decodeObjectForKey:kDBHInformationModelCategoryUserUpdatedAt];
    self.score = [aDecoder decodeObjectForKey:kDBHInformationModelCategoryUserScore];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_categoryUserIdentifier forKey:kDBHInformationModelCategoryUserId];
    [aCoder encodeBool:_isFavorite forKey:kDBHInformationModelCategoryUserIsFavorite];
    [aCoder encodeBool:_isFavoriteDot forKey:kDBHInformationModelCategoryUserIsFavoriteDot];
    [aCoder encodeObject:_marketLost forKey:kDBHInformationModelCategoryUserMarketLost];
    [aCoder encodeObject:_marketHige forKey:kDBHInformationModelCategoryUserMarketHige];
    [aCoder encodeBool:_isTop forKey:kDBHInformationModelCategoryUserIsTop];
    [aCoder encodeDouble:_categoryId forKey:kDBHInformationModelCategoryUserCategoryId];
    [aCoder encodeObject:_createdAt forKey:kDBHInformationModelCategoryUserCreatedAt];
    [aCoder encodeDouble:_userId forKey:kDBHInformationModelCategoryUserUserId];
    [aCoder encodeBool:_isMarketFollow forKey:kDBHInformationModelCategoryUserIsMarketFollow];
    [aCoder encodeObject:_updatedAt forKey:kDBHInformationModelCategoryUserUpdatedAt];
    [aCoder encodeObject:_score forKey:kDBHInformationModelCategoryUserScore];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationModelCategoryUser *copy = [[DBHInformationModelCategoryUser alloc] init];
    
    
    
    if (copy) {

        copy.categoryUserIdentifier = self.categoryUserIdentifier;
        copy.isFavorite = self.isFavorite;
        copy.isFavoriteDot = self.isFavoriteDot;
        copy.marketLost = [self.marketLost copyWithZone:zone];
        copy.marketHige = [self.marketHige copyWithZone:zone];
        copy.isTop = self.isTop;
        copy.categoryId = self.categoryId;
        copy.createdAt = [self.createdAt copyWithZone:zone];
        copy.userId = self.userId;
        copy.isMarketFollow = self.isMarketFollow;
        copy.updatedAt = [self.updatedAt copyWithZone:zone];
        copy.score = [self.score copyWithZone:zone];
    }
    
    return copy;
}


@end
