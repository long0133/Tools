//
//  DBHWalletManagerForNeoModelData.m
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHWalletManagerForNeoModelData.h"
#import "DBHWalletManagerForNeoModelList.h"


NSString *const kDBHWalletManagerForNeoModelDataList = LIST;


@interface DBHWalletManagerForNeoModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHWalletManagerForNeoModelData

@synthesize list = _list;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedDBHWalletManagerForNeoModelList = [dict objectForKey:kDBHWalletManagerForNeoModelDataList];
    NSMutableArray *parsedDBHWalletManagerForNeoModelList = [NSMutableArray array];
    
    if ([receivedDBHWalletManagerForNeoModelList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHWalletManagerForNeoModelList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHWalletManagerForNeoModelList addObject:[DBHWalletManagerForNeoModelList mj_objectWithKeyValues:item]];
            }
       }
    } else if ([receivedDBHWalletManagerForNeoModelList isKindOfClass:[NSDictionary class]]) {
       [parsedDBHWalletManagerForNeoModelList addObject:[DBHWalletManagerForNeoModelList mj_objectWithKeyValues:(NSDictionary *)receivedDBHWalletManagerForNeoModelList]];
    }

    self.list = [NSArray arrayWithArray:parsedDBHWalletManagerForNeoModelList];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForList = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.list) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kDBHWalletManagerForNeoModelDataList];

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

    self.list = [aDecoder decodeObjectForKey:kDBHWalletManagerForNeoModelDataList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_list forKey:kDBHWalletManagerForNeoModelDataList];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHWalletManagerForNeoModelData *copy = [[DBHWalletManagerForNeoModelData alloc] init];
    
    
    
    if (copy) {

        copy.list = [self.list copyWithZone:zone];
    }
    
    return copy;
}


@end
