//
//  DBHInformationModelLastArticle.h
//
//  Created by   on 2018/1/26
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHInformationModelLastArticle : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) double lastArticleIdentifier;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *url;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
