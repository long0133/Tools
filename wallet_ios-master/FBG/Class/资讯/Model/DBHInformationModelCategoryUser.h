//
//  DBHInformationModelCategoryUser.h
//
//  Created by   on 2018/2/13
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationModelCategoryUser : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double categoryUserIdentifier;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) BOOL isFavoriteDot;
@property (nonatomic, strong) NSString *marketLost;
@property (nonatomic, strong) NSString *marketHige;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) double userId;
@property (nonatomic, assign) BOOL isMarketFollow;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *score;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
