//
//  DBHInformationForICOModelNEO.m
//
//  Created by   on 2018/2/11
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHInformationForICOModelNEO.h"


NSString *const kDBHInformationForICOModelNEOId = @"id";
NSString *const kDBHInformationForICOModelNEOPriceCny = PRICE_CNY;
NSString *const kDBHInformationForICOModelNEOMaxSupply = @"max_supply";
NSString *const kDBHInformationForICOModelNEOMarketCapCny = @"market_cap_cny";
NSString *const kDBHInformationForICOModelNEOPercentChange24h = @"percent_change_24h";
NSString *const kDBHInformationForICOModelNEOSymbol = @"symbol";
NSString *const kDBHInformationForICOModelNEO24hVolumeCny = @"24h_volume_cny";
NSString *const kDBHInformationForICOModelNEOLastUpdated = @"last_updated";
NSString *const kDBHInformationForICOModelNEOMarketCapUsd = @"market_cap_usd";
NSString *const kDBHInformationForICOModelNEOPriceUsd = PRICE_USD;
NSString *const kDBHInformationForICOModelNEOPercentChange7d = @"percent_change_7d";
NSString *const kDBHInformationForICOModelNEORank = @"rank";
NSString *const kDBHInformationForICOModelNEO24hVolumeUsd = @"24h_volume_usd";
NSString *const kDBHInformationForICOModelNEOPriceBtc = @"price_btc";
NSString *const kDBHInformationForICOModelNEOAvailableSupply = @"available_supply";
NSString *const kDBHInformationForICOModelNEOTotalSupply = @"total_supply";
NSString *const kDBHInformationForICOModelNEOName = NAME;
NSString *const kDBHInformationForICOModelNEOPercentChange1h = @"percent_change_1h";


@interface DBHInformationForICOModelNEO ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DBHInformationForICOModelNEO

@synthesize nEOIdentifier = _nEOIdentifier;
@synthesize priceCny = _priceCny;
@synthesize maxSupply = _maxSupply;
@synthesize marketCapCny = _marketCapCny;
@synthesize percentChange24h = _percentChange24h;
@synthesize symbol = _symbol;
@synthesize volumeCny24h = _volumeCny24h;
@synthesize lastUpdated = _lastUpdated;
@synthesize marketCapUsd = _marketCapUsd;
@synthesize priceUsd = _priceUsd;
@synthesize percentChange7d = _percentChange7d;
@synthesize rank = _rank;
@synthesize volumeUsd24h = _volumeUsd24h;
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
            self.nEOIdentifier = [self objectOrNilForKey:kDBHInformationForICOModelNEOId fromDictionary:dict];
            self.priceCny = [self objectOrNilForKey:kDBHInformationForICOModelNEOPriceCny fromDictionary:dict];
            self.maxSupply = [self objectOrNilForKey:kDBHInformationForICOModelNEOMaxSupply fromDictionary:dict];
            self.marketCapCny = [self objectOrNilForKey:kDBHInformationForICOModelNEOMarketCapCny fromDictionary:dict];
            self.percentChange24h = [self objectOrNilForKey:kDBHInformationForICOModelNEOPercentChange24h fromDictionary:dict];
            self.symbol = [self objectOrNilForKey:kDBHInformationForICOModelNEOSymbol fromDictionary:dict];
            self.volumeCny24h = [self objectOrNilForKey:kDBHInformationForICOModelNEO24hVolumeCny fromDictionary:dict];
            self.lastUpdated = [self objectOrNilForKey:kDBHInformationForICOModelNEOLastUpdated fromDictionary:dict];
            self.marketCapUsd = [self objectOrNilForKey:kDBHInformationForICOModelNEOMarketCapUsd fromDictionary:dict];
            self.priceUsd = [self objectOrNilForKey:kDBHInformationForICOModelNEOPriceUsd fromDictionary:dict];
            self.percentChange7d = [self objectOrNilForKey:kDBHInformationForICOModelNEOPercentChange7d fromDictionary:dict];
            self.rank = [self objectOrNilForKey:kDBHInformationForICOModelNEORank fromDictionary:dict];
            self.volumeUsd24h = [self objectOrNilForKey:kDBHInformationForICOModelNEO24hVolumeUsd fromDictionary:dict];
            self.priceBtc = [self objectOrNilForKey:kDBHInformationForICOModelNEOPriceBtc fromDictionary:dict];
            self.availableSupply = [self objectOrNilForKey:kDBHInformationForICOModelNEOAvailableSupply fromDictionary:dict];
            self.totalSupply = [self objectOrNilForKey:kDBHInformationForICOModelNEOTotalSupply fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDBHInformationForICOModelNEOName fromDictionary:dict];
            self.percentChange1h = [self objectOrNilForKey:kDBHInformationForICOModelNEOPercentChange1h fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.nEOIdentifier forKey:kDBHInformationForICOModelNEOId];
    [mutableDict setValue:self.priceCny forKey:kDBHInformationForICOModelNEOPriceCny];
    [mutableDict setValue:self.maxSupply forKey:kDBHInformationForICOModelNEOMaxSupply];
    [mutableDict setValue:self.marketCapCny forKey:kDBHInformationForICOModelNEOMarketCapCny];
    [mutableDict setValue:self.percentChange24h forKey:kDBHInformationForICOModelNEOPercentChange24h];
    [mutableDict setValue:self.symbol forKey:kDBHInformationForICOModelNEOSymbol];
    [mutableDict setValue:self.volumeCny24h forKey:kDBHInformationForICOModelNEO24hVolumeCny];
    [mutableDict setValue:self.lastUpdated forKey:kDBHInformationForICOModelNEOLastUpdated];
    [mutableDict setValue:self.marketCapUsd forKey:kDBHInformationForICOModelNEOMarketCapUsd];
    [mutableDict setValue:self.priceUsd forKey:kDBHInformationForICOModelNEOPriceUsd];
    [mutableDict setValue:self.percentChange7d forKey:kDBHInformationForICOModelNEOPercentChange7d];
    [mutableDict setValue:self.rank forKey:kDBHInformationForICOModelNEORank];
    [mutableDict setValue:self.volumeUsd24h forKey:kDBHInformationForICOModelNEO24hVolumeUsd];
    [mutableDict setValue:self.priceBtc forKey:kDBHInformationForICOModelNEOPriceBtc];
    [mutableDict setValue:self.availableSupply forKey:kDBHInformationForICOModelNEOAvailableSupply];
    [mutableDict setValue:self.totalSupply forKey:kDBHInformationForICOModelNEOTotalSupply];
    [mutableDict setValue:self.name forKey:kDBHInformationForICOModelNEOName];
    [mutableDict setValue:self.percentChange1h forKey:kDBHInformationForICOModelNEOPercentChange1h];

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

    self.nEOIdentifier = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOId];
    self.priceCny = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOPriceCny];
    self.maxSupply = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOMaxSupply];
    self.marketCapCny = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOMarketCapCny];
    self.percentChange24h = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOPercentChange24h];
    self.symbol = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOSymbol];
    self.volumeCny24h = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEO24hVolumeCny];
    self.lastUpdated = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOLastUpdated];
    self.marketCapUsd = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOMarketCapUsd];
    self.priceUsd = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOPriceUsd];
    self.percentChange7d = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOPercentChange7d];
    self.rank = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEORank];
    self.volumeUsd24h = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEO24hVolumeUsd];
    self.priceBtc = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOPriceBtc];
    self.availableSupply = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOAvailableSupply];
    self.totalSupply = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOTotalSupply];
    self.name = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOName];
    self.percentChange1h = [aDecoder decodeObjectForKey:kDBHInformationForICOModelNEOPercentChange1h];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_nEOIdentifier forKey:kDBHInformationForICOModelNEOId];
    [aCoder encodeObject:_priceCny forKey:kDBHInformationForICOModelNEOPriceCny];
    [aCoder encodeObject:_maxSupply forKey:kDBHInformationForICOModelNEOMaxSupply];
    [aCoder encodeObject:_marketCapCny forKey:kDBHInformationForICOModelNEOMarketCapCny];
    [aCoder encodeObject:_percentChange24h forKey:kDBHInformationForICOModelNEOPercentChange24h];
    [aCoder encodeObject:_symbol forKey:kDBHInformationForICOModelNEOSymbol];
    [aCoder encodeObject:_volumeCny24h forKey:kDBHInformationForICOModelNEO24hVolumeCny];
    [aCoder encodeObject:_lastUpdated forKey:kDBHInformationForICOModelNEOLastUpdated];
    [aCoder encodeObject:_marketCapUsd forKey:kDBHInformationForICOModelNEOMarketCapUsd];
    [aCoder encodeObject:_priceUsd forKey:kDBHInformationForICOModelNEOPriceUsd];
    [aCoder encodeObject:_percentChange7d forKey:kDBHInformationForICOModelNEOPercentChange7d];
    [aCoder encodeObject:_rank forKey:kDBHInformationForICOModelNEORank];
    [aCoder encodeObject:_volumeUsd24h forKey:kDBHInformationForICOModelNEO24hVolumeUsd];
    [aCoder encodeObject:_priceBtc forKey:kDBHInformationForICOModelNEOPriceBtc];
    [aCoder encodeObject:_availableSupply forKey:kDBHInformationForICOModelNEOAvailableSupply];
    [aCoder encodeObject:_totalSupply forKey:kDBHInformationForICOModelNEOTotalSupply];
    [aCoder encodeObject:_name forKey:kDBHInformationForICOModelNEOName];
    [aCoder encodeObject:_percentChange1h forKey:kDBHInformationForICOModelNEOPercentChange1h];
}

- (id)copyWithZone:(NSZone *)zone {
    DBHInformationForICOModelNEO *copy = [[DBHInformationForICOModelNEO alloc] init];
    
    
    
    if (copy) {

        copy.nEOIdentifier = [self.nEOIdentifier copyWithZone:zone];
        copy.priceCny = [self.priceCny copyWithZone:zone];
        copy.maxSupply = [self.maxSupply copyWithZone:zone];
        copy.marketCapCny = [self.marketCapCny copyWithZone:zone];
        copy.percentChange24h = [self.percentChange24h copyWithZone:zone];
        copy.symbol = [self.symbol copyWithZone:zone];
        copy.volumeCny24h = [self.volumeCny24h copyWithZone:zone];
        copy.lastUpdated = [self.lastUpdated copyWithZone:zone];
        copy.marketCapUsd = [self.marketCapUsd copyWithZone:zone];
        copy.priceUsd = [self.priceUsd copyWithZone:zone];
        copy.percentChange7d = [self.percentChange7d copyWithZone:zone];
        copy.rank = [self.rank copyWithZone:zone];
        copy.volumeUsd24h = [self.volumeUsd24h copyWithZone:zone];
        copy.priceBtc = [self.priceBtc copyWithZone:zone];
        copy.availableSupply = [self.availableSupply copyWithZone:zone];
        copy.totalSupply = [self.totalSupply copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.percentChange1h = [self.percentChange1h copyWithZone:zone];
    }
    
    return copy;
}


@end
