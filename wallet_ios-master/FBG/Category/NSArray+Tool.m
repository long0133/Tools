//
//  NSArray+Tool.m
//  Tool
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "NSArray+Tool.h"
#import "DBHProjectHomeNewsModelData.h"
#import <HyphenateLite/EMMessage.h>
#import "DBHExchangeNoticeModelData.h"
#import "DBHProjectCommentDetailModel.h"

@implementation NSArray (Tool)

+ (NSArray *)arrayNamed:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}


- (NSString *)toJSONStringForArray
{
    NSData *paramsJSONData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:paramsJSONData encoding:NSUTF8StringEncoding];
}

+ (NSMutableArray *)arraySortedByArr:(NSMutableArray *)arr {
    if (arr.count == 0) {
        return nil;
    }
    
    NSArray *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[DBHProjectHomeNewsModelData class]]) {
            return [((DBHProjectHomeNewsModelData *)obj1).createdAt compare:((DBHProjectHomeNewsModelData *)obj2).createdAt];
        } else if ([obj1 isKindOfClass:[DBHExchangeNoticeModelData class]]) {
            return [((DBHExchangeNoticeModelData *)obj1).createdAt compare:((DBHExchangeNoticeModelData *)obj2).createdAt];
        } else if ([obj1 isKindOfClass:[DBHProjectCommentDetailModel class]]) {
            return [((DBHProjectCommentDetailModel *)obj2).category_comment_at compare:((DBHProjectCommentDetailModel *)obj1).category_comment_at]; // 倒序
        }
        return NSOrderedSame;
    }];
    return [NSMutableArray arrayWithArray:sortedArr];
}

@end
