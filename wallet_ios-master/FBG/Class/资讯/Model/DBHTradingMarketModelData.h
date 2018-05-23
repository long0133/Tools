//
//  DBHTradingMarketModelData.h
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHTradingMarketModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *pairce;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *update;
@property (nonatomic, strong) NSString *volumPercent;
@property (nonatomic, strong) NSString *volum24;
@property (nonatomic, strong) NSString *pair;
@property (nonatomic, strong) NSString *url;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
