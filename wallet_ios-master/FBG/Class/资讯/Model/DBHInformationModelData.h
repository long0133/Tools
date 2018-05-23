//
//  DBHInformationModelData.h
//
//  Created by   on 2018/1/26
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHInformationModelCategoryUser, DBHInformationModelLastArticle, DBHInformationModelIco;

@interface DBHInformationModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *longName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *industry;
@property (nonatomic, strong) DBHInformationModelCategoryUser *categoryUser;
@property (nonatomic, strong) NSString *coverImg;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) BOOL isScroll;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) DBHInformationModelLastArticle *lastArticle;
@property (nonatomic, strong) DBHInformationModelIco *ico;
@property (nonatomic, assign) double roomId;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) NSString *tokenHolder;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
