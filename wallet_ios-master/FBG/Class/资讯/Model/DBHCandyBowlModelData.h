//
//  DBHCandyBowlModelData.h
//
//  Created by   on 2018/1/31
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHCandyBowlModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, assign) double day;
@property (nonatomic, assign) double month;
@property (nonatomic, assign) double isScroll;
@property (nonatomic, assign) double year;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
