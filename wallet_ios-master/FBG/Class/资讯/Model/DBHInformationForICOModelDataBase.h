//
//  DBHInformationForICOModelDataBase.h
//
//  Created by   on 2018/2/11
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHInformationForICOModelNEO;

@interface DBHInformationForICOModelDataBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) DBHInformationForICOModelNEO *nEO;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
