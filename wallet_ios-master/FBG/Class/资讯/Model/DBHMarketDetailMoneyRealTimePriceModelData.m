//
//  DBHMarketDetailMoneyRealTimePriceModelData.m
//
//  Created by   on 2017/12/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "DBHMarketDetailMoneyRealTimePriceModelData.h"


NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataVolume = @"volume";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataPriceCny = PRICE_CNY;
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataMinPrice24h = @"24h_min_price";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataPrice = @"price";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataChangeCny24h = @"24h_change_cny";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataMaxPrice24h = @"24h_max_price";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataMinPriceCny24h = @"24h_min_price_cny";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataVolumeCny = @"volume_cny";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataChange24h = @"24h_change";
NSString *const kDBHMarketDetailMoneyRealTimePriceModelDataMaxPriceCny24h = @"24h_max_price_cny";


@interface DBHMarketDetailMoneyRealTimePriceModelData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHMarketDetailMoneyRealTimePriceModelData

@synthesize volume = _volume;
@synthesize priceCny = _priceCny;
@synthesize minPrice24h = _minPrice24h;
@synthesize price = _price;
@synthesize changeCny24h = _changeCny24h;
@synthesize maxPrice24h = _maxPrice24h;
@synthesize minPriceCny24h = _minPriceCny24h;
@synthesize volumeCny = _volumeCny;
@synthesize change24h = _change24h;
@synthesize maxPriceCny24h = _maxPriceCny24h;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.volume = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataVolume fromDictionary:dict];
            self.priceCny = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataPriceCny fromDictionary:dict];
            self.minPrice24h = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataMinPrice24h fromDictionary:dict];
            self.price = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataPrice fromDictionary:dict];
            self.changeCny24h = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataChangeCny24h fromDictionary:dict];
            self.maxPrice24h = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataMaxPrice24h fromDictionary:dict];
            self.minPriceCny24h = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataMinPriceCny24h fromDictionary:dict];
            self.volumeCny = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataVolumeCny fromDictionary:dict];
            self.change24h = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataChange24h fromDictionary:dict];
            self.maxPriceCny24h = [self objectOrNilForKey:kDBHMarketDetailMoneyRealTimePriceModelDataMaxPriceCny24h fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.volume forKey:kDBHMarketDetailMoneyRealTimePriceModelDataVolume];
    [mutableDict setValue:self.priceCny forKey:kDBHMarketDetailMoneyRealTimePriceModelDataPriceCny];
    [mutableDict setValue:self.minPrice24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataMinPrice24h];
    [mutableDict setValue:self.price forKey:kDBHMarketDetailMoneyRealTimePriceModelDataPrice];
    [mutableDict setValue:self.changeCny24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataChangeCny24h];
    [mutableDict setValue:self.maxPrice24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataMaxPrice24h];
    [mutableDict setValue:self.minPriceCny24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataMinPriceCny24h];
    [mutableDict setValue:self.volumeCny forKey:kDBHMarketDetailMoneyRealTimePriceModelDataVolumeCny];
    [mutableDict setValue:self.change24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataChange24h];
    [mutableDict setValue:self.maxPriceCny24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataMaxPriceCny24h];

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

    self.volume = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataVolume];
    self.priceCny = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataPriceCny];
    self.minPrice24h = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataMinPrice24h];
    self.price = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataPrice];
    self.changeCny24h = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataChangeCny24h];
    self.maxPrice24h = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataMaxPrice24h];
    self.minPriceCny24h = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataMinPriceCny24h];
    self.volumeCny = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataVolumeCny];
    self.change24h = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataChange24h];
    self.maxPriceCny24h = [aDecoder decodeObjectForKey:kDBHMarketDetailMoneyRealTimePriceModelDataMaxPriceCny24h];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_volume forKey:kDBHMarketDetailMoneyRealTimePriceModelDataVolume];
    [aCoder encodeObject:_priceCny forKey:kDBHMarketDetailMoneyRealTimePriceModelDataPriceCny];
    [aCoder encodeObject:_minPrice24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataMinPrice24h];
    [aCoder encodeObject:_price forKey:kDBHMarketDetailMoneyRealTimePriceModelDataPrice];
    [aCoder encodeObject:_changeCny24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataChangeCny24h];
    [aCoder encodeObject:_maxPrice24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataMaxPrice24h];
    [aCoder encodeObject:_minPriceCny24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataMinPriceCny24h];
    [aCoder encodeObject:_volumeCny forKey:kDBHMarketDetailMoneyRealTimePriceModelDataVolumeCny];
    [aCoder encodeObject:_change24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataChange24h];
    [aCoder encodeObject:_maxPriceCny24h forKey:kDBHMarketDetailMoneyRealTimePriceModelDataMaxPriceCny24h];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHMarketDetailMoneyRealTimePriceModelData *copy = [[DBHMarketDetailMoneyRealTimePriceModelData alloc] init];
    
    
    
    if (copy) {

        copy.volume = [self.volume copyWithZone:zone];
        copy.priceCny = [self.priceCny copyWithZone:zone];
        copy.minPrice24h = [self.minPrice24h copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.changeCny24h = [self.changeCny24h copyWithZone:zone];
        copy.maxPrice24h = [self.maxPrice24h copyWithZone:zone];
        copy.minPriceCny24h = [self.minPriceCny24h copyWithZone:zone];
        copy.volumeCny = [self.volumeCny copyWithZone:zone];
        copy.change24h = [self.change24h copyWithZone:zone];
        copy.maxPriceCny24h = [self.maxPriceCny24h copyWithZone:zone];
    }
    
    return copy;
}


@end
