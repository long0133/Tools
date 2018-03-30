//
//  TKFileManager.m
//  Thinking
//
//  Created by O*O on 17/2/10.
//  Copyright © 2017年 lane. All rights reserved.
//

#import "TKFileManager.h"
#import "LSFileAssistant.h"

@implementation TKFileManager

+ (void)removeFileWithPath:(NSString*)path{
    [LSFileAssistant removeFileWithPath:path systemDirectoryType:LSFileSystemPathDocument];
}

+ (void)saveData:(id)data withFileName:(NSString *)fileName
{
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:data];
    [LSFileAssistant saveData:archiveData toFileWithPath:fileName systemDirectoryType:LSFileSystemPathDocument];
}

+ (id)loadDataWithFileName:(NSString *)fileName
{
    id object = nil;
    NSData *data = [LSFileAssistant loadDataWithDataClass:[NSData class] fromFileWithPath:fileName systemDirectoryType:LSFileSystemPathDocument];
    if (data) {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return object;
}

+ (void)copyDefaultFileName:(NSString *)fileName
{
    if (![LSFileAssistant fileExistAtPath:fileName systemDirectoryType:LSFileSystemPathDocument]) {
        [LSFileAssistant copyAppBundleFileWithPath:fileName toSystemDirectoryType:LSFileSystemPathDocument];
    }
}

+ (void)deleteFileName:(NSString *)fileName
{
    [LSFileAssistant removeFileWithPath:fileName systemDirectoryType:LSFileSystemPathDocument];
}

+ (void)saveValue:(id)value forKey:(NSString *)key
{
    [[[NSUserDefaults alloc] initWithSuiteName:@"UserDefaultsIdentifier"] setValue:value forKey:key];
}

+ (id)ValueWithKey:(NSString *)key
{
    return [[[NSUserDefaults alloc] initWithSuiteName:@"UserDefaultsIdentifier"] valueForKey:key];
}
@end
