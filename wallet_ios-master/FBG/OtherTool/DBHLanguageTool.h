//
//  DBHLanguageTool.h
//  FBG
//
//  Created by 邓毕华 on 2018/1/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DBHGetStringWithKeyFromTable(key, tbl) [[DBHLanguageTool sharedInstance] getStringForKey:key withTable:tbl]

@interface DBHLanguageTool : NSObject

@property (nonatomic, copy) NSString *language;

+(instancetype)sharedInstance;

/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param table table
 *
 *  @return 返回table中指定的key的值
 */
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

/**
 *  改变当前语言
 */
//-(void)changeNowLanguage;

/**
 *  设置新的语言
 *
 *  @param language 新语言
 */
-(void)setNewLanguage:(NSString*)language;

@end
