//
//  DBHExchangeNoticeModelData.h
//
//  Created by   on 2018/2/8
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHExchangeNoticeModelData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL isScroll;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *sourceName;
@property (nonatomic, strong) NSString *sourceUrl;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *content;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
