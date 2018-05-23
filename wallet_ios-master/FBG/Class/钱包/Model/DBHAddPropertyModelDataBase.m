//
//  DBHAddPropertyModelDataBase.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHAddPropertyModelDataBase.h"
#import "DBHAddPropertyModelList.h"


NSString *const kDBHAddPropertyModelDataBaseList = LIST;


@interface DBHAddPropertyModelDataBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHAddPropertyModelDataBase

@synthesize list = _list;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedDBHAddPropertyModelList = [dict objectForKey:kDBHAddPropertyModelDataBaseList];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForList] forKey:kDBHAddPropertyModelDataBaseList];

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

    self.list = [aDecoder decodeObjectForKey:kDBHAddPropertyModelDataBaseList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_list forKey:kDBHAddPropertyModelDataBaseList];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHAddPropertyModelDataBase *copy = [[DBHAddPropertyModelDataBase alloc] init];
    
    
    
    if (copy) {

        copy.list = [self.list copyWithZone:zone];
    }
    
    return copy;
}


@end
