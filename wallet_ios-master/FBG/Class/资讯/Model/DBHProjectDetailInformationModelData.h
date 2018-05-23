//
//  DBHProjectDetailInformationModelData.h
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHProjectDetailInformationModelCategoryDesc, DBHProjectDetailInformationModelCategoryUser, DBHProjectDetailInformationModelCategoryPresentation, DBHProjectDetailInformationModelCategoryScore, DBHProjectDetailInformationModelIco;

@interface DBHProjectDetailInformationModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *tokenHolder;
@property (nonatomic, strong) DBHProjectDetailInformationModelCategoryDesc *categoryDesc;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSArray *categoryMedia;
@property (nonatomic, strong) NSArray *categoryExplorer;
@property (nonatomic, strong) NSString *industry;
@property (nonatomic, strong) DBHProjectDetailInformationModelCategoryUser *categoryUser;
@property (nonatomic, strong) NSString *coverImg;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) BOOL isScroll;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) DBHProjectDetailInformationModelCategoryPresentation *categoryPresentation;
@property (nonatomic, strong) NSArray *categoryIndustry;
@property (nonatomic, strong) DBHProjectDetailInformationModelCategoryScore *categoryScore;
@property (nonatomic, strong) NSString *icoPrice;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) DBHProjectDetailInformationModelIco *ico;
@property (nonatomic, strong) NSArray *categoryStructure;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) NSArray *categoryWallet;
@property (nonatomic, strong) NSString *longName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
