//
//  DBHProjectDetailInformationModelIco.m
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHProjectDetailInformationModelIco.h"


NSString *const kDBHProjectDetailInformationModelIcoId = @"id";
NSString *const kDBHProjectDetailInformationModelIcoPriceCny = PRICE_CNY;
NSString *const kDBHProjectDetailInformationModelIcoMaxSupply = @"max_supply";
NSString *const kDBHProjectDetailInformationModelIcoMarketCapCny = @"market_cap_cny";
NSString *const kDBHProjectDetailInformationModelIcoPercentChange24h = @"percent_change_24h";
NSString *const kDBHProjectDetailInformationModelIcoSymbol = @"symbol";
NSString *const kDBHProjectDetailInformationModelIcoLastUpdated = @"last_updated";
NSString *const kDBHProjectDetailInformationModelIcoMarketCapUsd = @"market_cap_usd";
NSString *const kDBHProjectDetailInformationModelIcoTotalSupply = @"total_supply";
NSString *const kDBHProjectDetailInformationModelIcoPriceUsd = PRICE_USD;
NSString *const kDBHProjectDetailInformationModelIcoVolumeUsd24h = @"24h_volume_usd";
NSString *const kDBHProjectDetailInformationModelIcoPercentChange7d = @"percent_change_7d";
NSString *const kDBHProjectDetailInformationModelIcoRank = @"rank";
NSString *const kDBHProjectDetailInformationModelIcoPriceBtc = @"price_btc";
NSString *const kDBHProjectDetailInformationModelIcoVolumeCny24h = @"24h_volume_cny";
NSString *const kDBHProjectDetailInformationModelIcoAvailableSupply = @"available_supply";
NSString *const kDBHProjectDetailInformationModelIcoName = NAME;
NSString *const kDBHProjectDetailInformationModelIcoPercentChange1h = @"percent_change_1h";


@interface DBHProjectDetailInformationModelIco ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHProjectDetailInformationModelIco

@synthesize icoIdentifier = _icoIdentifier;
@synthesize priceCny = _priceCny;
@synthesize maxSupply = _maxSupply;
@synthesize marketCapCny = _marketCapCny;
@synthesize percentChange24h = _percentChange24h;
@synthesize symbol = _symbol;
@synthesize lastUpdated = _lastUpdated;
@synthesize marketCapUsd = _marketCapUsd;
@synthesize totalSupply = _totalSupply;
@synthesize priceUsd = _priceUsd;
@synthesize volumeUsd24h = _volumeUsd24h;
@synthesize percentChange7d = _percentChange7d;
@synthesize rank = _rank;
@synthesize priceBtc = _priceBtc;
@synthesize volumeCny24h = _volumeCny24h;
@synthesize availableSupply = _availableSupply;
@synthesize name = _name;
@synthesize percentChange1h = _percentChange1h;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"icoIdentifier" : @"id",
             @"volumeUsd24h" : @"24h_volume_usd",
             @"volumeCny24h" : @"24h_volume_cny",
             @"availableSupply" : @"available_supply",
             @"lastUpdated" : @"last_updated",
             @"marketCapCny" : @"market_cap_cny",
             @"marketCapUsd" : @"market_cap_usd",
             @"maxSupply" : @"max_supply",
             @"percentChange1h" : @"percent_change_1h",
             @"percentChange24h" : @"percent_change_24h",
             @"percentChange7d" : @"percent_change_7d",
             @"priceBtc" : @"price_btc",
             @"priceCny" : @"price_cny",
             @"priceUsd" : @"price_usd",
             @"totalSupply" : @"total_supply"
             };
}

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.icoIdentifier = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoId fromDictionary:dict];
            self.priceCny = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoPriceCny fromDictionary:dict];
            self.maxSupply = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoMaxSupply fromDictionary:dict];
            self.marketCapCny = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoMarketCapCny fromDictionary:dict];
            self.percentChange24h = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoPercentChange24h fromDictionary:dict];
            self.symbol = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoSymbol fromDictionary:dict];
            self.lastUpdated = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoLastUpdated fromDictionary:dict];
            self.marketCapUsd = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoMarketCapUsd fromDictionary:dict];
            self.totalSupply = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoTotalSupply fromDictionary:dict];
            self.priceUsd = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoPriceUsd fromDictionary:dict];
            self.volumeUsd24h = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoVolumeUsd24h fromDictionary:dict];
            self.percentChange7d = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoPercentChange7d fromDictionary:dict];
            self.rank = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoRank fromDictionary:dict];
            self.priceBtc = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoPriceBtc fromDictionary:dict];
            self.volumeCny24h = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoVolumeCny24h fromDictionary:dict];
            self.availableSupply = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoAvailableSupply fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoName fromDictionary:dict];
            self.percentChange1h = [self objectOrNilForKey:kDBHProjectDetailInformationModelIcoPercentChange1h fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.icoIdentifier forKey:kDBHProjectDetailInformationModelIcoId];
    [mutableDict setValue:self.priceCny forKey:kDBHProjectDetailInformationModelIcoPriceCny];
    [mutableDict setValue:self.maxSupply forKey:kDBHProjectDetailInformationModelIcoMaxSupply];
    [mutableDict setValue:self.marketCapCny forKey:kDBHProjectDetailInformationModelIcoMarketCapCny];
    [mutableDict setValue:self.percentChange24h forKey:kDBHProjectDetailInformationModelIcoPercentChange24h];
    [mutableDict setValue:self.symbol forKey:kDBHProjectDetailInformationModelIcoSymbol];
    [mutableDict setValue:self.lastUpdated forKey:kDBHProjectDetailInformationModelIcoLastUpdated];
    [mutableDict setValue:self.marketCapUsd forKey:kDBHProjectDetailInformationModelIcoMarketCapUsd];
    [mutableDict setValue:self.totalSupply forKey:kDBHProjectDetailInformationModelIcoTotalSupply];
    [mutableDict setValue:self.priceUsd forKey:kDBHProjectDetailInformationModelIcoPriceUsd];
    [mutableDict setValue:self.volumeUsd24h forKey:kDBHProjectDetailInformationModelIcoVolumeUsd24h];
    [mutableDict setValue:self.percentChange7d forKey:kDBHProjectDetailInformationModelIcoPercentChange7d];
    [mutableDict setValue:self.rank forKey:kDBHProjectDetailInformationModelIcoRank];
    [mutableDict setValue:self.priceBtc forKey:kDBHProjectDetailInformationModelIcoPriceBtc];
    [mutableDict setValue:self.volumeCny24h forKey:kDBHProjectDetailInformationModelIcoVolumeCny24h];
    [mutableDict setValue:self.availableSupply forKey:kDBHProjectDetailInformationModelIcoAvailableSupply];
    [mutableDict setValue:self.name forKey:kDBHProjectDetailInformationModelIcoName];
    [mutableDict setValue:self.percentChange1h forKey:kDBHProjectDetailInformationModelIcoPercentChange1h];

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

    self.icoIdentifier = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoId];
    self.priceCny = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoPriceCny];
    self.maxSupply = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoMaxSupply];
    self.marketCapCny = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoMarketCapCny];
    self.percentChange24h = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoPercentChange24h];
    self.symbol = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoSymbol];
    self.lastUpdated = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoLastUpdated];
    self.marketCapUsd = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoMarketCapUsd];
    self.totalSupply = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoTotalSupply];
    self.priceUsd = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoPriceUsd];
    self.volumeUsd24h = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoVolumeUsd24h];
    self.percentChange7d = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoPercentChange7d];
    self.rank = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoRank];
    self.priceBtc = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoPriceBtc];
    self.volumeCny24h = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoVolumeCny24h];
    self.availableSupply = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoAvailableSupply];
    self.name = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoName];
    self.percentChange1h = [aDecoder decodeObjectForKey:kDBHProjectDetailInformationModelIcoPercentChange1h];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_icoIdentifier forKey:kDBHProjectDetailInformationModelIcoId];
    [aCoder encodeObject:_priceCny forKey:kDBHProjectDetailInformationModelIcoPriceCny];
    [aCoder encodeObject:_maxSupply forKey:kDBHProjectDetailInformationModelIcoMaxSupply];
    [aCoder encodeObject:_marketCapCny forKey:kDBHProjectDetailInformationModelIcoMarketCapCny];
    [aCoder encodeObject:_percentChange24h forKey:kDBHProjectDetailInformationModelIcoPercentChange24h];
    [aCoder encodeObject:_symbol forKey:kDBHProjectDetailInformationModelIcoSymbol];
    [aCoder encodeObject:_lastUpdated forKey:kDBHProjectDetailInformationModelIcoLastUpdated];
    [aCoder encodeObject:_marketCapUsd forKey:kDBHProjectDetailInformationModelIcoMarketCapUsd];
    [aCoder encodeObject:_totalSupply forKey:kDBHProjectDetailInformationModelIcoTotalSupply];
    [aCoder encodeObject:_priceUsd forKey:kDBHProjectDetailInformationModelIcoPriceUsd];
    [aCoder encodeObject:_volumeUsd24h forKey:kDBHProjectDetailInformationModelIcoVolumeUsd24h];
    [aCoder encodeObject:_percentChange7d forKey:kDBHProjectDetailInformationModelIcoPercentChange7d];
    [aCoder encodeObject:_rank forKey:kDBHProjectDetailInformationModelIcoRank];
    [aCoder encodeObject:_priceBtc forKey:kDBHProjectDetailInformationModelIcoPriceBtc];
    [aCoder encodeObject:_volumeCny24h forKey:kDBHProjectDetailInformationModelIcoVolumeCny24h];
    [aCoder encodeObject:_availableSupply forKey:kDBHProjectDetailInformationModelIcoAvailableSupply];
    [aCoder encodeObject:_name forKey:kDBHProjectDetailInformationModelIcoName];
    [aCoder encodeObject:_percentChange1h forKey:kDBHProjectDetailInformationModelIcoPercentChange1h];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHProjectDetailInformationModelIco *copy = [[DBHProjectDetailInformationModelIco alloc] init];
    
    
    
    if (copy) {

        copy.icoIdentifier = [self.icoIdentifier copyWithZone:zone];
        copy.priceCny = [self.priceCny copyWithZone:zone];
        copy.maxSupply = [self.maxSupply copyWithZone:zone];
        copy.marketCapCny = [self.marketCapCny copyWithZone:zone];
        copy.percentChange24h = [self.percentChange24h copyWithZone:zone];
        copy.symbol = [self.symbol copyWithZone:zone];
        copy.lastUpdated = [self.lastUpdated copyWithZone:zone];
        copy.marketCapUsd = [self.marketCapUsd copyWithZone:zone];
        copy.totalSupply = [self.totalSupply copyWithZone:zone];
        copy.priceUsd = [self.priceUsd copyWithZone:zone];
        copy.volumeUsd24h = [self.volumeUsd24h copyWithZone:zone];
        copy.percentChange7d = [self.percentChange7d copyWithZone:zone];
        copy.rank = [self.rank copyWithZone:zone];
        copy.priceBtc = [self.priceBtc copyWithZone:zone];
        copy.volumeCny24h = [self.volumeCny24h copyWithZone:zone];
        copy.availableSupply = [self.availableSupply copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.percentChange1h = [self.percentChange1h copyWithZone:zone];
    }
    
    return copy;
}


@end
