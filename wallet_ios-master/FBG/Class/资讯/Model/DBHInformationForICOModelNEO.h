//
//  DBHInformationForICOModelNEO.h
//
//  Created by   on 2018/2/11
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationForICOModelNEO : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *nEOIdentifier;
@property (nonatomic, strong) NSString *priceCny;
@property (nonatomic, assign) id maxSupply;
@property (nonatomic, strong) NSString *marketCapCny;
@property (nonatomic, strong) NSString *percentChange24h;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *volumeCny24h;
@property (nonatomic, strong) NSString *lastUpdated;
@property (nonatomic, strong) NSString *marketCapUsd;
@property (nonatomic, strong) NSString *priceUsd;
@property (nonatomic, strong) NSString *percentChange7d;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *volumeUsd24h;
@property (nonatomic, strong) NSString *priceBtc;
@property (nonatomic, strong) NSString *availableSupply;
@property (nonatomic, strong) NSString *totalSupply;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *percentChange1h;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
