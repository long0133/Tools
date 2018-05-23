//
//  DBHHistoricalInformationModelArticleUser.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHHistoricalInformationModelArticleUser.h"


NSString *const kDBHHistoricalInformationModelArticleUserUserId = @"user_id";


@interface DBHHistoricalInformationModelArticleUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHHistoricalInformationModelArticleUser

@synthesize userId = _userId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.userId = [[self objectOrNilForKey:kDBHHistoricalInformationModelArticleUserUserId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHHistoricalInformationModelArticleUserUserId];

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

    self.userId = [aDecoder decodeDoubleForKey:kDBHHistoricalInformationModelArticleUserUserId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_userId forKey:kDBHHistoricalInformationModelArticleUserUserId];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHHistoricalInformationModelArticleUser *copy = [[DBHHistoricalInformationModelArticleUser alloc] init];
    
    
    
    if (copy) {

        copy.userId = self.userId;
    }
    
    return copy;
}


@end
