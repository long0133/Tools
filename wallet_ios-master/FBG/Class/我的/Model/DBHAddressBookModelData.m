//
//  DBHAddressBookModelData.m
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHAddressBookModelData.h"
#import "DBHAddressBookModelList.h"


NSString *const kDBHAddressBookModelDataList = LIST;


@interface DBHAddressBookModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHAddressBookModelData

@synthesize list = _list;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedDBHAddressBookModelList = [dict objectForKey:kDBHAddressBookModelDataList];
    NSMutableArray *parsedDBHAddressBookModelList = [NSMutableArray array];
    
    if ([receivedDBHAddressBookModelList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHAddressBookModelList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHAddressBookModelList addObject:[DBHAddressBookModelList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHAddressBookModelList isKindOfClass:[NSDictionary class]]) {
       [parsedDBHAddressBookModelList addObject:[DBHAddressBookModelList modelObjectWithDictionary:(NSDictionary *)receivedDBHAddressBookModelList]];
    }

    self.list = [NSArray arrayWithArray:parsedDBHAddressBookModelList];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kDBHAddressBookModelDataList];

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

    self.list = [aDecoder decodeObjectForKey:kDBHAddressBookModelDataList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_list forKey:kDBHAddressBookModelDataList];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHAddressBookModelData *copy = [[DBHAddressBookModelData alloc] init];
    
    
    
    if (copy) {

        copy.list = [self.list copyWithZone:zone];
    }
    
    return copy;
}


@end
