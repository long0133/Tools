//
//  DBHInfomationModelArticleUser.h
//
//  Created by   on 2018/2/7
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInfomationModelArticleUser : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double userId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
