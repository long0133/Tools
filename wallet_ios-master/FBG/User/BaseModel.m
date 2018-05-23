//
//  BaseModel.m
//  FBG
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    return (self = [[super init] initWithDictionary:dict error:nil]);
}

- (instancetype)initWithString:(NSString*)string
{
    return (self = [[super init] initWithString:string error:nil]);
}
+(NSMutableArray*)arrayOfModelsFromDictionaries:(NSArray*)array
{
    NSError *error = nil;
    
    NSMutableArray *arr = [self arrayOfModelsFromDictionaries:array error:&error];
#ifdef DEBUG
    if (error)
    {
        NSLog(@"----%@---", error.localizedDescription);
    }
#endif
    return arr;
}

@end
