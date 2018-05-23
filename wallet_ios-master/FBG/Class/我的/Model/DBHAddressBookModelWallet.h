//
//  DBHAddressBookModelWallet.h
//
//  Created by   on 2018/2/6
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBHAddressBookModelUser;

@interface DBHAddressBookModelWallet : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) double walletIdentifier;
@property (nonatomic, strong) NSString *deletedAt;
@property (nonatomic, strong) NSString *addressHash160;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) double categoryId;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) DBHAddressBookModelUser *user;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
