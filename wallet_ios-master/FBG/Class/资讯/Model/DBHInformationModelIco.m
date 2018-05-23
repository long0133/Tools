//
//  DBHInformationModelIco.m
//
//  Created by   on 2018/1/26
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationModelIco.h"


NSString *const kDBHInformationModelIcoId = @"id";
NSString *const kDBHInformationModelIcoPriceCny = PRICE_CNY;
NSString *const kDBHInformationModelIcoMaxSupply = @"max_supply";
NSString *const kDBHInformationModelIcoPercentChange24h = @"percent_change_24h";
NSString *const kDBHInformationModelIcoSymbol = @"symbol";
NSString *const kDBHInformationModelIcoLastUpdated = @"last_updated";
NSString *const kDBHInformationModelIcoMarketCapUsd = @"market_cap_usd";
NSString *const kDBHInformationModelIcoPriceUsd = PRICE_USD;
NSString *const kDBHInformationModelIcoPercentChange7d = @"percent_change_7d";
NSString *const kDBHInformationModelIcoVolumeUsd24h = @"24h_volume_usd";
NSString *const kDBHInformationModelIcoRank = @"rank";
NSString *const kDBHInformationModelIcoPriceBtc = @"price_btc";
NSString *const kDBHInformationModelIcoAvailableSupply = @"available_supply";
NSString *const kDBHInformationModelIcoTotalSupply = @"total_supply";
NSString *const kDBHInformationModelIcoName = NAME;
NSString *const kDBHInformationModelIcoPercentChange1h = @"percent_change_1h";


@interface DBHInformationModelIco ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationModelIco

@synthesize icoIdentifier = _icoIdentifier;
@synthesize priceCny = _priceCny;
@synthesize maxSupply = _maxSupply;
@synthesize percentChange24h = _percentChange24h;
@synthesize symbol = _symbol;
@synthesize lastUpdated = _lastUpdated;
@synthesize marketCapUsd = _marketCapUsd;
@synthesize priceUsd = _priceUsd;
@synthesize percentChange7d = _percentChange7d;
@synthesize volumeUsd24h = _volumeUsd24h;
@synthesize rank = _rank;
@synthesize priceBtc = _priceBtc;
@synthesize availableSupply = _availableSupply;
@synthesize totalSupply = _totalSupply;
@synthesize name = _name;
@synthesize percentChange1h = _percentChange1h;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.icoIdentifier = [self objectOrNilForKey:kDBHInformationModelIcoId fromDictionary:dict];
            self.priceCny = [self objectOrNilForKey:kDBHInformationModelIcoPriceCny fromDictionary:dict];
            self.maxSupply = [self objectOrNilForKey:kDBHInformationModelIcoMaxSupply fromDictionary:dict];
            self.percentChange24h = [self objectOrNilForKey:kDBHInformationModelIcoPercentChange24h fromDictionary:dict];
            self.symbol = [self objectOrNilForKey:kDBHInformationModelIcoSymbol fromDictionary:dict];
            self.lastUpdated = [self objectOrNilForKey:kDBHInformationModelIcoLastUpdated fromDictionary:dict];
            self.marketCapUsd = [self objectOrNilForKey:kDBHInformationModelIcoMarketCapUsd fromDictionary:dict];
            self.priceUsd = [self objectOrNilForKey:kDBHInformationModelIcoPriceUsd fromDictionary:dict];
            self.percentChange7d = [self objectOrNilForKey:kDBHInformationModelIcoPercentChange7d fromDictionary:dict];
            self.volumeUsd24h = [self objectOrNilForKey:kDBHInformationModelIcoVolumeUsd24h fromDictionary:dict];
            self.rank = [self objectOrNilForKey:kDBHInformationModelIcoRank fromDictionary:dict];
            self.priceBtc = [self objectOrNilForKey:kDBHInformationModelIcoPriceBtc fromDictionary:dict];
            self.availableSupply = [self objectOrNilForKey:kDBHInformationModelIcoAvailableSupply fromDictionary:dict];
            self.totalSupply = [self objectOrNilForKey:kDBHInformationModelIcoTotalSupply fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationModelIcoName fromDictionary:dict];
            self.percentChange1h = [self objectOrNilForKey:kDBHInformationModelIcoPercentChange1h fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.icoIdentifier forKey:kDBHInformationModelIcoId];
    [mutableDict setValue:self.priceCny forKey:kDBHInformationModelIcoPriceCny];
    [mutableDict setValue:self.maxSupply forKey:kDBHInformationModelIcoMaxSupply];
    [mutableDict setValue:self.percentChange24h forKey:kDBHInformationModelIcoPercentChange24h];
    [mutableDict setValue:self.symbol forKey:kDBHInformationModelIcoSymbol];
    [mutableDict setValue:self.lastUpdated forKey:kDBHInformationModelIcoLastUpdated];
    [mutableDict setValue:self.marketCapUsd forKey:kDBHInformationModelIcoMarketCapUsd];
    [mutableDict setValue:self.priceUsd forKey:kDBHInformationModelIcoPriceUsd];
    [mutableDict setValue:self.percentChange7d forKey:kDBHInformationModelIcoPercentChange7d];
    [mutableDict setValue:self.volumeUsd24h forKey:kDBHInformationModelIcoVolumeUsd24h];
    [mutableDict setValue:self.rank forKey:kDBHInformationModelIcoRank];
    [mutableDict setValue:self.priceBtc forKey:kDBHInformationModelIcoPriceBtc];
    [mutableDict setValue:self.availableSupply forKey:kDBHInformationModelIcoAvailableSupply];
    [mutableDict setValue:self.totalSupply forKey:kDBHInformationModelIcoTotalSupply];
    [mutableDict setValue:self.name forKey:kDBHInformationModelIcoName];
    [mutableDict setValue:self.percentChange1h forKey:kDBHInformationModelIcoPercentChange1h];

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

    self.icoIdentifier = [aDecoder decodeObjectForKey:kDBHInformationModelIcoId];
    self.priceCny = [aDecoder decodeObjectForKey:kDBHInformationModelIcoPriceCny];
    self.maxSupply = [aDecoder decodeObjectForKey:kDBHInformationModelIcoMaxSupply];
    self.percentChange24h = [aDecoder decodeObjectForKey:kDBHInformationModelIcoPercentChange24h];
    self.symbol = [aDecoder decodeObjectForKey:kDBHInformationModelIcoSymbol];
    self.lastUpdated = [aDecoder decodeObjectForKey:kDBHInformationModelIcoLastUpdated];
    self.marketCapUsd = [aDecoder decodeObjectForKey:kDBHInformationModelIcoMarketCapUsd];
    self.priceUsd = [aDecoder decodeObjectForKey:kDBHInformationModelIcoPriceUsd];
    self.percentChange7d = [aDecoder decodeObjectForKey:kDBHInformationModelIcoPercentChange7d];
    self.volumeUsd24h = [aDecoder decodeObjectForKey:kDBHInformationModelIcoVolumeUsd24h];
    self.rank = [aDecoder decodeObjectForKey:kDBHInformationModelIcoRank];
    self.priceBtc = [aDecoder decodeObjectForKey:kDBHInformationModelIcoPriceBtc];
    self.availableSupply = [aDecoder decodeObjectForKey:kDBHInformationModelIcoAvailableSupply];
    self.totalSupply = [aDecoder decodeObjectForKey:kDBHInformationModelIcoTotalSupply];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationModelIcoName];
    self.percentChange1h = [aDecoder decodeObjectForKey:kDBHInformationModelIcoPercentChange1h];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_icoIdentifier forKey:kDBHInformationModelIcoId];
    [aCoder encodeObject:_priceCny forKey:kDBHInformationModelIcoPriceCny];
    [aCoder encodeObject:_maxSupply forKey:kDBHInformationModelIcoMaxSupply];
    [aCoder encodeObject:_percentChange24h forKey:kDBHInformationModelIcoPercentChange24h];
    [aCoder encodeObject:_symbol forKey:kDBHInformationModelIcoSymbol];
    [aCoder encodeObject:_lastUpdated forKey:kDBHInformationModelIcoLastUpdated];
    [aCoder encodeObject:_marketCapUsd forKey:kDBHInformationModelIcoMarketCapUsd];
    [aCoder encodeObject:_priceUsd forKey:kDBHInformationModelIcoPriceUsd];
    [aCoder encodeObject:_percentChange7d forKey:kDBHInformationModelIcoPercentChange7d];
    [aCoder encodeObject:_volumeUsd24h forKey:kDBHInformationModelIcoVolumeUsd24h];
    [aCoder encodeObject:_rank forKey:kDBHInformationModelIcoRank];
    [aCoder encodeObject:_priceBtc forKey:kDBHInformationModelIcoPriceBtc];
    [aCoder encodeObject:_availableSupply forKey:kDBHInformationModelIcoAvailableSupply];
    [aCoder encodeObject:_totalSupply forKey:kDBHInformationModelIcoTotalSupply];
    [aCoder encodeObject:_name forKey:kDBHInformationModelIcoName];
    [aCoder encodeObject:_percentChange1h forKey:kDBHInformationModelIcoPercentChange1h];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationModelIco *copy = [[DBHInformationModelIco alloc] init];
    
    
    
    if (copy) {

        copy.icoIdentifier = [self.icoIdentifier copyWithZone:zone];
        copy.priceCny = [self.priceCny copyWithZone:zone];
        copy.maxSupply = [self.maxSupply copyWithZone:zone];
        copy.percentChange24h = [self.percentChange24h copyWithZone:zone];
        copy.symbol = [self.symbol copyWithZone:zone];
        copy.lastUpdated = [self.lastUpdated copyWithZone:zone];
        copy.marketCapUsd = [self.marketCapUsd copyWithZone:zone];
        copy.priceUsd = [self.priceUsd copyWithZone:zone];
        copy.percentChange7d = [self.percentChange7d copyWithZone:zone];
        copy.volumeUsd24h = [self.volumeUsd24h copyWithZone:zone];
        copy.rank = [self.rank copyWithZone:zone];
        copy.priceBtc = [self.priceBtc copyWithZone:zone];
        copy.availableSupply = [self.availableSupply copyWithZone:zone];
        copy.totalSupply = [self.totalSupply copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.percentChange1h = [self.percentChange1h copyWithZone:zone];
    }
    
    return copy;
}


@end
