//
//  DBHAddressBookModelList.h
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHAddressBookModelWallet;

@interface DBHAddressBookModelList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) DBHAddressBookModelWallet *wallet;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) double listIdentifier;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
