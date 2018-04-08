//
//  CYLDataBase.m
//  CYLPersistance
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "CYLDataBase.h"

@interface CYLDataBase()
@property (nonatomic, strong) FMDatabase *db;
@end

// 创建静态对象 防止外部访问
static CYLDataBase * sharedInstace;
@implementation CYLDataBase
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    // 一次函数
    dispatch_once(&onceToken, ^{
        if (sharedInstace == nil) {
            sharedInstace = [super allocWithZone:zone];
            [sharedInstace papareDataBase];
        }
    });
    
    return sharedInstace;
}

+ (instancetype)sharedInstance{
    
    return  [[self alloc] init];
}

#pragma mark - public

#pragma mark - private
- (void)papareDataBase{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (!app_Name || app_Name.length == 0) app_Name = @"creatDataBase_DefaultName";
    NSString *dbPath = [self getDatabasePath:app_Name];
    NSLog(@" log : %@",dbPath);
    _db = [FMDatabase databaseWithPath:dbPath];
}

- (NSString *)getDatabasePath:(NSString *)dbName {
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString *databasePath = [docsDir stringByAppendingPathComponent:dbName];
    
    return databasePath;
}

- (FMDatabase *)getDataBase{
    return self.db;
}

- (void)openDataBase{
    [self.db open];
}

- (void)closeDataBase{
    [self.db close];
}
@end
