//
//  DBHInfomationModelArticleUser.m
//
//  Created by   on 2018/2/7
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInfomationModelArticleUser.h"


NSString *const kDBHInfomationModelArticleUserUserId = @"user_id";


@interface DBHInfomationModelArticleUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInfomationModelArticleUser

@synthesize userId = _userId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.userId = [[self objectOrNilForKey:kDBHInfomationModelArticleUserUserId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHInfomationModelArticleUserUserId];

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

    self.userId = [aDecoder decodeDoubleForKey:kDBHInfomationModelArticleUserUserId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_userId forKey:kDBHInfomationModelArticleUserUserId];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInfomationModelArticleUser *copy = [[DBHInfomationModelArticleUser alloc] init];
    
    
    
    if (copy) {

        copy.userId = self.userId;
    }
    
    return copy;
}


@end
