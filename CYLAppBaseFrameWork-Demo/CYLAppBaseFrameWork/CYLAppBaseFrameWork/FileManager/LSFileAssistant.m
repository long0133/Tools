//
//  LSFileAssistant.m
//  LSCommonService
//
//  Created by 白开水_孙 on 15/3/19.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "LSFileAssistant.h"
#import <UIKit/UIKit.h>

@implementation LSFileAssistant
{
    LSSearchPathDirectory _directoryType;
}

@synthesize pathOfFile = _pathOfFile;

#pragma mark - init method
- (instancetype)initWithFilePath:(NSString *)filePath systemDirectoryType:(LSSearchPathDirectory)directoryType
{
    if (self = [super init]) {
        _pathOfFile = filePath;
        _directoryType = directoryType;
    }
    return self;
}

- (NSString *)pathOfFile
{
    return [[self class] absolutePathWithUserPath:_pathOfFile systemDirectoryType:_directoryType];
}

#pragma mark - load\save data methods
- (id)loadDataFromFileWithDataClass:(Class)class
{
    self.classOfContent = class;
    return [self loadDataFromFile];
}

- (id)loadDataFromFile
{
    NSString *absolutePath = [[self class] absolutePathWithUserPath:_pathOfFile
                                                systemDirectoryType:_directoryType];
    return [[_classOfContent alloc] initWithContentsOfFile:absolutePath];
}

- (BOOL)saveDataToFile:(id)data
{
    self.dataOfFile = data;
    return [self saveDataToFile];
}

- (BOOL)saveDataToFile
{
    [[self class] ensurePathExist:_pathOfFile systemDirectoryType:_directoryType];
    NSString *absolutePath = [[self class] absolutePathWithUserPath:_pathOfFile
                                                systemDirectoryType:_directoryType];
    if ([_dataOfFile isKindOfClass:[NSData class]]) {
        _classOfContent = [NSData class];
        NSData *data = (NSData *)_dataOfFile;
        return [data writeToFile:absolutePath atomically:YES];
    } else if ([_dataOfFile isKindOfClass:[NSDictionary class]]) {
        _classOfContent = [NSDictionary class];
        NSDictionary *dic = (NSDictionary *)_dataOfFile;
        return [dic writeToFile:absolutePath atomically:YES];
    } else if ([_dataOfFile isKindOfClass:[NSArray class]]) {
        _classOfContent = [NSArray class];
        NSArray *array = (NSArray *)_dataOfFile;
        return [array writeToFile:absolutePath atomically:YES];
    } else if ([_dataOfFile isKindOfClass:[NSString class]]) {
        _classOfContent = [NSString class];
        NSString *str = (NSString *)_dataOfFile;
        return [str writeToFile:absolutePath
                     atomically:YES
                       encoding:NSUTF8StringEncoding
                          error:nil];
    }
    return NO;
}

#pragma mark - class methods

+ (id)loadDataWithDataClass:(Class)class fromFileWithPath:(NSString *)pathOfFile systemDirectoryType:(LSSearchPathDirectory)directoryType
{
    NSString *absolutePath = [self absolutePathWithUserPath:pathOfFile
                                        systemDirectoryType:directoryType];
//    NSLog(@"%@",absolutePath);
    return [[class alloc] initWithContentsOfFile:absolutePath];
}

+ (BOOL)copyAppBundleFileWithPath:(NSString *)pathOfFile toSystemDirectoryType:(LSSearchPathDirectory)directoryType
{
    NSString *plistPathInBundle = [[NSBundle mainBundle] pathForResource:pathOfFile ofType:nil];
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathOfFile] && plistPathInBundle) {
        NSString *toPath = [LSFileAssistant absolutePathWithUserPath:pathOfFile systemDirectoryType:directoryType];
        return [[NSFileManager defaultManager] copyItemAtPath:plistPathInBundle toPath:toPath error:nil];
    } else {
        return NO;
    }
}

+ (BOOL)saveData:(id)dataOfFile toFileWithPath:(NSString *)pathOfFile systemDirectoryType:(LSSearchPathDirectory)directoryType
{
    [self ensurePathExist:pathOfFile systemDirectoryType:directoryType];
    NSString *absolutePath = [self absolutePathWithUserPath:pathOfFile
                                        systemDirectoryType:directoryType];
    if ([dataOfFile isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)dataOfFile;
        return [data writeToFile:absolutePath atomically:YES];
    } else if ([dataOfFile isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)dataOfFile;
        return [dic writeToFile:absolutePath atomically:YES];
    } else if ([dataOfFile isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)dataOfFile;
        return [array writeToFile:absolutePath atomically:YES];
    } else if ([dataOfFile isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)dataOfFile;
        return [str writeToFile:absolutePath
                     atomically:YES
                       encoding:NSUTF8StringEncoding
                          error:nil];
    }
    return NO;
}

+ (BOOL)removeFileWithPath:(NSString *)pathOfFile systemDirectoryType:(LSSearchPathDirectory)directoryType
{
    if (directoryType == LSFileSystemPathProjectResource) {
        return NO;
    }
    
    return [self removeItemAtPath:[self absolutePathWithUserPath:pathOfFile
                                             systemDirectoryType:directoryType]];
}

+ (BOOL)removeItemAtPath:(NSString *)absolutePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:absolutePath error:nil];
}

/**
 *  获取由pathDiretory和path决定的文件的绝对目录
 *
 *  @param path          文件在pathDiretory中的相对路径
 *  @param directoryType 文件在沙箱中的目录
 *
 *  @return 文件绝对路径
 */
+ (NSString *)absolutePathWithUserPath:(NSString *)path systemDirectoryType:(LSSearchPathDirectory)directoryType
{
    NSSearchPathDirectory directory = NSDocumentDirectory;
    NSString *prefix = nil;
    switch (directoryType) {
        case LSFileSystemPathCache:
            directory = NSCachesDirectory;
            break;
        case LSFileSystemPathTmp:
            prefix = NSTemporaryDirectory();
            break;
        case LSFileSystemPathProjectResource:
            prefix = [[NSBundle mainBundle] bundlePath];
        default:
            break;
    }
    if (!prefix) {
        prefix = [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) firstObject];
    }
    return path.length > 0 ? [prefix stringByAppendingFormat:@"/%@", path] : prefix;
}

+ (void)ensurePathExist:(NSString *)path systemDirectoryType:(LSSearchPathDirectory)directoryType
{
    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    NSMutableString *mutablePath = [[NSMutableString alloc] init];
    [mutablePath appendString:[self absolutePathWithUserPath:nil systemDirectoryType:directoryType]];
    
    [pathArray enumerateObjectsUsingBlock:^(NSString *nodeName, NSUInteger idx, BOOL *stop) {
        [mutablePath appendFormat:@"/%@", nodeName];
        [self forceEnsurePathExistWithAbsolutePath:mutablePath
                                          isFolder:idx == [pathArray count] - 1 ? NO : YES];
        
    }];
}

+ (BOOL)fileExistAtPath:(NSString *)path systemDirectoryType:(LSSearchPathDirectory)directoryType
{
    NSMutableString *mutablePath = [[NSMutableString alloc] init];
    [mutablePath appendString:[self absolutePathWithUserPath:path systemDirectoryType:directoryType]];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    return [filemanager fileExistsAtPath:mutablePath];
}

+ (BOOL)forceEnsurePathExistWithAbsolutePath:(NSString *)path isFolder:(BOOL)isFolder
{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL test = [filemanager fileExistsAtPath:path isDirectory:&isDirectory];
    if (test && (isDirectory == isFolder)) {
        return YES;
    }
    
    NSError *error = nil;
    BOOL success = NO;
    if (isFolder) {
        success = [filemanager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    } else {
        success = [filemanager createFileAtPath:path contents:nil attributes:nil];
    }
    
    //文件已经存在，创建文件夹时，存在同名的文件。这里直接删除同名文件。
    //使用本方法需慎重，防止数据丢失。
    if (error.code == 516) {
        error = nil;
        [filemanager removeItemAtPath:path error:&error];
        if (!error) {
            return [self forceEnsurePathExistWithAbsolutePath:path isFolder:isFolder];
        } else {
            return NO;
        }
    }
    return !error;
}

+ (NSString *)randFileName
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    NSString *udid = (__bridge NSString *)string;
    udid = [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(string);
    return udid;
}

+ (NSString *)timeFileName
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
}


@end
