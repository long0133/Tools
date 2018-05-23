//
//  DBHWalletManagerForNeoModelCategory.h
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHProjectDetailInformationModelIco.h"
#import "YYWalletCategoryIcoInfoModel.h"

@interface DBHWalletManagerForNeoModelCategory : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) NSInteger categoryIdentifier;
@property (nonatomic, strong) YYWalletCategoryIcoInfoModel *ico_info;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) DBHProjectDetailInformationModelIco *cap;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
