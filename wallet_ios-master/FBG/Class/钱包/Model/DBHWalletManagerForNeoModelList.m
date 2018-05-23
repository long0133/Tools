//
//  DBHWalletManagerForNeoModelList.m
//
//  Created by   on 2018/1/9
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "DBHWalletManagerForNeoModelList.h"
#import "DBHWalletManagerForNeoModelCategory.h"


//@property (nonatomic, strong) DBHWalletManagerForNeoModelCategory *category;
//@property (nonatomic, strong) NSString *address;
//@property (nonatomic, assign) NSInteger listIdentifier;
//@property (nonatomic, strong) NSString *createdAt;
//@property (nonatomic, strong) NSString *deletedAt;
//@property (nonatomic, strong) NSString *addressHash160;
//@property (nonatomic, assign) NSInteger categoryId;
//@property (nonatomic, assign) NSInteger userId;
//
//@property (nonatomic, strong) NSString *updatedAt;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, assign) NSInteger sort;


@implementation DBHWalletManagerForNeoModelList
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"listIdentifier" : @"id",
             @"createdAt" : @"created_at",
             @"deletedAt" : @"deleted_at",
             @"addressHash160" : @"address_hash160",
             @"categoryId" : @"category_id",
             @"userId" : @"user_id",
             @"updatedAt" : @"updated_at"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"gnt" : [YYWalletRecordGntModel class]
             };
}

//- (NSString *)description  {
//    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
//}

#pragma mark ------ Getters And Setters ------
- (NSMutableDictionary *)tokenStatistics {
    if (!_tokenStatistics) {
        _tokenStatistics = [NSMutableDictionary dictionary];
    }
    return _tokenStatistics;
}

@end
