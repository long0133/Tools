//
//  DBHProjectDetailInformationModelCategoryPresentation.h
//
//  Created by   on 2018/2/12
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBHProjectDetailInformationModelCategoryPresentation : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double categoryPresentationIdentifier;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, strong) NSString *content;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
