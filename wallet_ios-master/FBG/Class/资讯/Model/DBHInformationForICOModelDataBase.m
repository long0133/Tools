//
//  DBHInformationForICOModelDataBase.m
//
//  Created by   on 2018/2/11
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForICOModelDataBase.h"
#import "DBHInformationForICOModelNEO.h"


NSString *const kDBHInformationForICOModelDataBaseNEO = @"NEO";


@interface DBHInformationForICOModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForICOModelDataBase

@synthesize nEO = _nEO;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.nEO = [DBHInformationForICOModelNEO modelObjectWithDictionary:[dict objectForKey:kDBHInformationForICOModelDataBaseNEO]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.nEO dictionaryRepresentation] forKey:kDBHInformationForICOModelDataBaseNEO];

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

    self.nEO = [aDecoder decodeObjectForKey:kDBHInformationForICOModelDataBaseNEO];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_nEO forKey:kDBHInformationForICOModelDataBaseNEO];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForICOModelDataBase *copy = [[DBHInformationForICOModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.nEO = [self.nEO copyWithZone:zone];
    }
    
    return copy;
}


@end
