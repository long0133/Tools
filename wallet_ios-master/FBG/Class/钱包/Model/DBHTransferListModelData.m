//
//  DBHTransferListModelData.m
//
//  Created by   on 2018/1/10
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHTransferListModelData.h"
#import "DBHTransferListModelList.h"


NSString *const kDBHTransferListModelDataList = LIST;


@interface DBHTransferListModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHTransferListModelData

@synthesize list = _list;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedDBHTransferListModelList = [dict objectForKey:kDBHTransferListModelDataList];
    NSMutableArray *parsedDBHTransferListModelList = [NSMutableArray array];
    
    if ([receivedDBHTransferListModelList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHTransferListModelList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHTransferListModelList addObject:[DBHTransferListModelList mj_objectWithKeyValues:item]];
            }
       }
    } else if ([receivedDBHTransferListModelList isKindOfClass:[NSDictionary class]]) {
       [parsedDBHTransferListModelList addObject:[DBHTransferListModelList mj_objectWithKeyValues:(NSDictionary *)receivedDBHTransferListModelList]];
    }

    self.list = [NSArray arrayWithArray:parsedDBHTransferListModelList];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kDBHTransferListModelDataList];

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

    self.list = [aDecoder decodeObjectForKey:kDBHTransferListModelDataList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_list forKey:kDBHTransferListModelDataList];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHTransferListModelData *copy = [[DBHTransferListModelData alloc] init];
    
    
    
    if (copy) {

        copy.list = [self.list copyWithZone:zone];
    }
    
    return copy;
}


@end
