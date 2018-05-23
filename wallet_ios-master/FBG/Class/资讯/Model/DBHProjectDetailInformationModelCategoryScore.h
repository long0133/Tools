//
//  DBHProjectDetailInformationModelCategoryScore.h
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHProjectDetailInformationModelCategoryScore : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double value;
@property (nonatomic, assign) double sort;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
