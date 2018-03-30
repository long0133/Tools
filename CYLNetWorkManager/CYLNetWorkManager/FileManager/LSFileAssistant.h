//
//  LSFileAssistant.h
//  LSCommonService
//
//  Created by 白开水_孙 on 15/3/19.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LSSearchPathDirectory)
{
    /**
     *  对应NSDocumentDirectory，app 沙箱的 Documents 目录，目录文件默认会备份到iCloud
     */
    LSFileSystemPathDocument,
    /**
     *  对应NSCachesDirectory，app 沙箱的 Library/cache 目录，这个目录下的文件主要是缓存，系统会在需要的时候删除该目录，若被清理掉，必须不能影响 app 正常运行
     */
    LSFileSystemPathCache,
    /**
     *  对应NSTemporaryDirectory，app 沙箱的 tmp 目录，这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
     */
    LSFileSystemPathTmp,
    /**
     *  对应[NSBundle mainBundle]，app 沙箱的 .app 目录，这是应用程序的程序包目录，包含应用程序的本身。
     *  由于应用程序必须经过签名，所以您在运行时不能对这个目录中的内容进行修改，否则可能会使应用程序无法启动。
     */
    LSFileSystemPathProjectResource
};

@interface LSFileAssistant : NSObject
/**
 *  文件内容所对应的NSObject类型实例
 */
@property (nonatomic, strong) id dataOfFile;

/**
 *  文件绝对路径
 */
@property (nonatomic, copy, readonly) NSString *pathOfFile;

/**
 *  文件包含的内容对应的数据类型
 *  文件中存取内容对应的NSObject类型
 *  可以是 NSData, NSDictionary, NSArray, NSString之一
 *  这些类型都有初始化方法-initWithContentsOfFile
 */
@property (nonatomic, copy) Class classOfContent;

/**
 *  初始化文件存储实例
 *
 *  @param filePath      文件路径
 *  @param directoryType 文件在沙箱环境中的位置类型，参照LSSearchPathDirectory
 *
 *  @return 文件存取实例
 */
- (instancetype)initWithFilePath:(NSString *)filePath systemDirectoryType:(LSSearchPathDirectory)directoryType;

/**
 *  从文件中载入数据
 *
 *  @return 返回文件中所包含的内容
 */
- (id)loadDataFromFile;

/**
 *  从文件中载入数据
 *
 *  @param class 文件中存取内容对应的NSObject类型
 *
 *  @return 返回文件中所包含的内容
 */
- (id)loadDataFromFileWithDataClass:(Class)aClass;

/**
 *  从文件中载入数据
 *
 *  @param class         文件中存取内容对应的NSObject类型
 *  @param pathOfFile    文件在沙箱指定目录中的相对路径
 *  @param directoryType 文件在沙箱中的目录
 *
 *  @return 返回文件中所包含的内容
 */
+ (id)loadDataWithDataClass:(Class)aClass fromFileWithPath:(NSString *)pathOfFile systemDirectoryType:(LSSearchPathDirectory)directoryType;

/**
 *  向文件中保存指定当前file assistant包含的数据dataOfFile
 */
- (BOOL)saveDataToFile;

/**
 *  向文件中保存数据
 *  @param data 需要保存的数据
 */
- (BOOL)saveDataToFile:(id)data;

/**
 *  从app中复制文件到沙盒中
 *
 *  @param pathOfFile    文件名
 *  @param directoryType 文件在沙箱中的目录
 */
+ (BOOL)copyAppBundleFileWithPath:(NSString *)pathOfFile toSystemDirectoryType:(LSSearchPathDirectory)directoryType;


/**
 *  向文件中保存数据
 *
 *  @param dataOfFile    需要保存的数据
 *  @param pathOfFile    文件在沙箱指定目录中的相对路径
 *  @param directoryType 文件在沙箱中的目录
 */
+ (BOOL)saveData:(id)dataOfFile toFileWithPath:(NSString *)pathOfFile systemDirectoryType:(LSSearchPathDirectory)directoryType;

/**
 *  删除一个路径
 *
 *  @param pathOfFile    需要删除的数据
 *  @param directoryType 件在沙箱中的目录
 */
+ (BOOL)removeFileWithPath:(NSString *)pathOfFile systemDirectoryType:(LSSearchPathDirectory)directoryType;

/**
 *  返回绝对路径
 *
 *  @param path          文件在沙箱指定目录中的相对路径
 *  @param directoryType 文件在沙箱中的目录
 *
 *  @return 文件绝对路径
 */
+ (NSString *)absolutePathWithUserPath:(NSString *)path systemDirectoryType:(LSSearchPathDirectory)directoryType;

/**
 *  确保path对应的路径一定存在
 *
 *  @param path          文件在pathDiretory中的相对路径
 *  @param directoryType 文件在沙箱中的目录
 */
+ (void)ensurePathExist:(NSString *)path systemDirectoryType:(LSSearchPathDirectory)directoryType;

/**
 *  判断path对应的路径是否存在
 *
 *  @param path          文件在pathDiretory中的相对路径
 *  @param directoryType 文件在沙箱中的目录
 */
+ (BOOL)fileExistAtPath:(NSString *)path systemDirectoryType:(LSSearchPathDirectory)directoryType;

/**
 *  获取一个随机文件名 32位
 */
+ (NSString *)randFileName;

/**
 *  获取一个时间戳文件名
 */
+ (NSString *)timeFileName;

@end
