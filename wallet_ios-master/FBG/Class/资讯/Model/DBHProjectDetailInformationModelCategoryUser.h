//
//  DBHProjectDetailInformationModelCategoryUser.h
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHProjectDetailInformationModelCategoryUser : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, assign) BOOL isFavoriteDot;
@property (nonatomic, assign) double categoryUserIdentifier;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) BOOL isMarketFollow;
@property (nonatomic, strong) NSString *marketLost;
@property (nonatomic, strong) NSString *marketHige;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
