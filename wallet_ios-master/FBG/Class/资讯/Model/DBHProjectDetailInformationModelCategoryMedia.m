//
//  DBHProjectDetailInformationModelCategoryMedia.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelCategoryMedia.h"


NSString *const kDBHProjectDetailInformationModelCategoryMediaImg = @"img";
NSString *const kDBHProjectDetailInformationModelCategoryMediaQrImg = @"qr_img";
NSString *const kDBHProjectDetailInformationModelCategoryMediaName = NAME;
NSString *const kDBHProjectDetailInformationModelCategoryMediaDesc = @"desc";
NSString *const kDBHProjectDetailInformationModelCategoryMediaUrl = @"url";


@interface DBHProjectDetailInformationModelCategoryMedia ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelCategoryMedia

@synthesize img = _img;
@synthesize qrImg = _qrImg;
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
            self.img = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryMediaImg fromDictionary:dict];
            self.qrImg = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryMediaQrImg fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryMediaName fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryMediaDesc fromDictionary:dict];
            self.url = [self objectOrNilForKey:kDBHProjectDetailInformationModelCategoryMediaUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.img forKey:kDBHProjectDetailInformationModelCategoryMediaImg];
    [mutableDict setValue:self.qrImg forKey:kDBHProjectDetailInformationModelCategoryMediaQrImg];
    [mutableDict setValue:self.name forKey:kDBHProjectDetailInformationModelCategoryMediaName];
    [mutableDict setValue:self.desc forKey:kDBHProjectDetailInformationModelCategoryMediaDesc];
    [mutableDict setValue:self.url forKey:kDBHProjectDetailInformationModelCategoryMediaUrl];

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

    self.img = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryMediaImg];
    self.qrImg = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryMediaQrImg];
    self.name = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryMediaName];
    self.desc = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryMediaDesc];
    self.url = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelCategoryMediaUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_img forKey:kDBHProjectDetailInformationModelCategoryMediaImg];
    [aCoder encodeObject:_qrImg forKey:kDBHProjectDetailInformationModelCategoryMediaQrImg];
    [aCoder encodeObject:_name forKey:kDBHProjectDetailInformationModelCategoryMediaName];
    [aCoder encodeObject:_desc forKey:kDBHProjectDetailInformationModelCategoryMediaDesc];
    [aCoder encodeObject:_url forKey:kDBHProjectDetailInformationModelCategoryMediaUrl];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelCategoryMedia *copy = [[DBHProjectDetailInformationModelCategoryMedia alloc] init];
    
    
    
    if (copy) {

        copy.img = [self.img copyWithZone:zone];
        copy.qrImg = [self.qrImg copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
