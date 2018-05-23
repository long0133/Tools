//
//  DBHLanguageTool.m
//  FBG
//
//  Created by 邓毕华 on 2018/1/27.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "DBHLanguageTool.h"

#import "AppDelegate.h"

static DBHLanguageTool *sharedModel;

@interface DBHLanguageTool()

@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation DBHLanguageTool

+(id)sharedInstance
{
    if (!sharedModel)
    {
        sharedModel = [[DBHLanguageTool alloc]init];
    }
    
    return sharedModel;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initLanguage];
    }
    
    return self;
}

-(void)initLanguage
{
    NSString *tmp = CURRENT_APP_LANGUAGE;
    NSString *path;
    //默认是系统语言
    if (!tmp)
    {
        tmp = [[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] isEqualToString:@"zh"] ? CNS : EN;
    }
    else 
    {
        tmp = CURRENT_APP_LANGUAGE;
    }
    
    self.language = tmp;
    path = [[NSBundle mainBundle]pathForResource:self.language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
}

-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table
{
    if (self.bundle)
    {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    
    return NSLocalizedStringFromTable(key, table, @"");
}

//-(void)changeNowLanguage
//{
//    if ([self.language isEqualToString:EN])
//    {
//        [self setNewLanguage:CNS];
//    }
//    else
//    {
//        [self setNewLanguage:EN];
//    }
//}

-(void)setNewLanguage:(NSString *)language {
    if ([language isEqualToString:CURRENT_APP_LANGUAGE])  {
        return;
    }
    
    if ([language isEqualToString:EN] || [language isEqualToString:CNS]) {
        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    
    self.language = language;
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self resetRootViewController];
}

//重新设置
//-(void)resetRootViewController {
//    [[AppDelegate delegate] goToTabbar];
//}

@end
