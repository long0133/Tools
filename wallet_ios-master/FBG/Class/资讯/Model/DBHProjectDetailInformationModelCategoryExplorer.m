//
//  DBHProjectDetailInformationModelCategoryExplorer.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelCategoryExplorer.h"


NSString *const kDBHProjectDetailInformationModelCategoryExplorerName = NAME;
NSString *const kDBHProjectDetailInformationModelCategoryExplorerDesc = @"desc";
NSString *const kDBHProjectDetailInformationModelCategoryExplorerUrl = @"url";


@interface DBHProjectDetailInformationModelCategoryExplorer ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelCategoryExplorer

@synthesize name = _name;
@synthesize desc = _desc;
@synthesize url = _url;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.name = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryExplorerName fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryExplorerDesc fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryExplorerUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kDBHProjectDetailInformationModelCategoryExplorerName];
    [mutableDict setValue:self.desc forKey:kDBHProjectDetailInformationModelCategoryExplorerDesc];
    [mutableDict setValue:self.url forKey:kDBHProjectDetailInformationModelCategoryExplorerUrl];

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

    self.name = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryExplorerName];
    self.desc = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryExplorerDesc];
    self.url = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryExplorerUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kDBHProjectDetailInformationModelCategoryExplorerName];
    [aCoder encodeObject:_desc forKey:kDBHProjectDetailInformationModelCategoryExplorerDesc];
    [aCoder encodeObject:_url forKey:kDBHProjectDetailInformationModelCategoryExplorerUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelCategoryExplorer *copy = [[DBHProjectDetailInformationModelCategoryExplorer alloc] init];
    
    
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
