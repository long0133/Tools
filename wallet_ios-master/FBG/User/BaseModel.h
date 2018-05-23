//
//  BaseModel.h
//  FBG
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BaseModel : JSONModel

- (instancetype)initWithDictionary:(NSDictionary*)dict;

- (instancetype)initWithString:(NSString*)string;

+(NSMutableArray*)arrayOfModelsFromDictionaries:(NSArray*)array;

@end
