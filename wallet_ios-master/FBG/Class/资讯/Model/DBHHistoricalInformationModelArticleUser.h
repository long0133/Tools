//
//  DBHHistoricalInformationModelArticleUser.h
//
//  Created by   on 2018/1/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHHistoricalInformationModelArticleUser : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double userId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
