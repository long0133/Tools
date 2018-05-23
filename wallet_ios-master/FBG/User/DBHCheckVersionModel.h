//
//  DBHCheckVersionModel.h
//  FBG
//
//  Created by yy on 2018/3/21.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHCheckVersionModel : NSObject

+ (instancetype)sharedInstance;

- (void)checkVersion:(NSString *)tipStr;

@end
