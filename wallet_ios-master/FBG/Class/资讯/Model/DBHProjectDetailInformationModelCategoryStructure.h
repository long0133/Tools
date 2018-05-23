//
//  DBHProjectDetailInformationModelCategoryStructure.h
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHProjectDetailInformationModelCategoryStructure : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double percentage;
@property (nonatomic, strong) NSString *colorValue;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *colorName;
@property (nonatomic, strong) NSString *desc;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
