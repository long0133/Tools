//
//  DBHProjectHomeNewsModelArticleUser.m
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectHomeNewsModelArticleUser.h"


NSString *const kDBHProjectHomeNewsModelArticleUserUserId = @"user_id";


@interface DBHProjectHomeNewsModelArticleUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectHomeNewsModelArticleUser

@synthesize userId = _userId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.userId = [[self objectOrNilForKey:kDBHProjectHomeNewsModelArticleUserUserId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kDBHProjectHomeNewsModelArticleUserUserId];

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

    self.userId = [aDecoder decodeDoubleForKey:kDBHProjectHomeNewsModelArticleUserUserId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_userId forKey:kDBHProjectHomeNewsModelArticleUserUserId];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectHomeNewsModelArticleUser *copy = [[DBHProjectHomeNewsModelArticleUser alloc] init];
    
    
    
    if (copy) {

        copy.userId = self.userId;
    }
    
    return copy;
}


@end
