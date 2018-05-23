//
//  DBHMarketDetailMoneyRealTimePriceModelData.h
//
//  Created by   on 2017/12/5
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHMarketDetailMoneyRealTimePriceModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *volume;
@property (nonatomic, strong) NSString *priceCny;
@property (nonatomic, strong) NSString *minPrice24h;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *changeCny24h;
@property (nonatomic, strong) NSString *maxPrice24h;
@property (nonatomic, strong) NSString *minPriceCny24h;
@property (nonatomic, strong) NSString *volumeCny;
@property (nonatomic, strong) NSString *change24h;
@property (nonatomic, strong) NSString *maxPriceCny24h;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
