//
//  DBHAddPropertyModelData.m
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHAddPropertyModelData.h"
#import "DBHAddPropertyModelList.h"


NSString *const kDBHAddPropertyModelDataList = LIST;


@interface DBHAddPropertyModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHAddPropertyModelData

@synthesize list = _list;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedDBHAddPropertyModelList = [dict objectForKey:kDBHAddPropertyModelDataList];
    NSMutableArray *parsedDBHAddPropertyModelList = [NSMutableArray array];
    
    if ([receivedDBHAddPropertyModelList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDBHAddPropertyModelList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDBHAddPropertyModelList addObject:[DBHAddPropertyModelList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDBHAddPropertyModelList isKindOfClass:[NSDictionary class]]) {
       [parsedDBHAddPropertyModelList addObject:[DBHAddPropertyModelList modelObjectWithDictionary:(NSDictionary *)receivedDBHAddPropertyModelList]];
    }

    self.list = [NSArray arrayWithArray:parsedDBHAddPropertyModelList];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kDBHAddPropertyModelDataList];

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

    self.list = [aDecoder decodeObjectForKey:kDBHAddPropertyModelDataList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_list forKey:kDBHAddPropertyModelDataList];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHAddPropertyModelData *copy = [[DBHAddPropertyModelData alloc] init];
    
    
    
    if (copy) {

        copy.list = [self.list copyWithZone:zone];
    }
    
    return copy;
}


@end
