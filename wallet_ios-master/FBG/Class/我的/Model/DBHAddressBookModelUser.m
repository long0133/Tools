//
//  DBHAddressBookModelUser.m
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHAddressBookModelUser.h"


NSString *const kDBHAddressBookModelUserEmail = @"email";
NSString *const kDBHAddressBookModelUserId = @"id";
NSString *const kDBHAddressBookModelUserImg = @"img";
NSString *const kDBHAddressBookModelUserLang = @"lang";
NSString *const kDBHAddressBookModelUserName = NAME;


@interface DBHAddressBookModelUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHAddressBookModelUser

@synthesize email = _email;
@synthesize userIdentifier = _userIdentifier;
@synthesize img = _img;
@synthesize lang = _lang;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.email = [self objectOrNilForKey:kDBHAddressBookModelUserEmail fromDictionary:dict];
            self.userIdentifier = [[self objectOrNilForKey:kDBHAddressBookModelUserId fromDictionary:dict] doubleValue];
            self.img = [self objectOrNilForKey:kDBHAddressBookModelUserImg fromDictionary:dict];
            self.lang = [self objectOrNilForKey:kDBHAddressBookModelUserLang fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHAddressBookModelUserName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.email forKey:kDBHAddressBookModelUserEmail];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userIdentifier] forKey:kDBHAddressBookModelUserId];
    [mutableDict setValue:self.img forKey:kDBHAddressBookModelUserImg];
    [mutableDict setValue:self.lang forKey:kDBHAddressBookModelUserLang];
    [mutableDict setValue:self.name forKey:kDBHAddressBookModelUserName];

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

    self.email = [aDecoder decodeObjectForKey:kDBHAddressBookModelUserEmail];
    self.userIdentifier = [aDecoder decodeDoubleForKey:kDBHAddressBookModelUserId];
    self.img = [aDecoder decodeObjectForKey:kDBHAddressBookModelUserImg];
    self.lang = [aDecoder decodeObjectForKey:kDBHAddressBookModelUserLang];
    self.name = [aDecoder decodeObjectForKey:kDBHAddressBookModelUserName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_email forKey:kDBHAddressBookModelUserEmail];
    [aCoder encodeDouble:_userIdentifier forKey:kDBHAddressBookModelUserId];
    [aCoder encodeObject:_img forKey:kDBHAddressBookModelUserImg];
    [aCoder encodeObject:_lang forKey:kDBHAddressBookModelUserLang];
    [aCoder encodeObject:_name forKey:kDBHAddressBookModelUserName];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHAddressBookModelUser *copy = [[DBHAddressBookModelUser alloc] init];
    
    
    
    if (copy) {

        copy.email = [self.email copyWithZone:zone];
        copy.userIdentifier = self.userIdentifier;
        copy.img = [self.img copyWithZone:zone];
        copy.lang = [self.lang copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
