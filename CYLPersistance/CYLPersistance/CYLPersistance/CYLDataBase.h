//
//  CYLDataBase.h
//  CYLPersistance
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface CYLDataBase : NSObject
+ (instancetype)sharedInstance;
- (FMDatabase*)getDataBase;
@end
